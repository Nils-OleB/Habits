//
//  Persistence.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 18.01.21.
//

import CoreData
import Combine
import os.log
#if !os(watchOS)
import WidgetKit
#endif
#if os(watchOS)
import ClockKit
#endif

class PersistenceController: ObservableObject {
    static let shared = PersistenceController()
    
    var viewContext: NSManagedObjectContext {
      return container.viewContext
    }
        
    private let container: NSPersistentCloudKitContainer
    private var subscriptions: Set<AnyCancellable> = []
    
    private lazy var historyRequestQueue = DispatchQueue(label: "history")
    private var lastHistoryToken: NSPersistentHistoryToken?
    private lazy var tokenFileURL: URL = {
        let url = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("Habits", isDirectory: true)
      do {
        try FileManager.default
          .createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
      } catch {
        let nsError = error as NSError
        os_log(
          .error,
          log: .default,
          "Failed to create history token directory: %@",
          nsError)
      }
      return url.appendingPathComponent("token.data", isDirectory: false)
    }()

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Habits")
        
        let storeURL = URL.storeURL(databaseName: "Habits")
        let description = NSPersistentStoreDescription(url: storeURL)
        
        // for previews
        if inMemory {
            description.url = URL(fileURLWithPath: "/dev/null")
        }
        
        
        let id = "iCloud.com.nils-ole.Habits4"
        let cloudKitOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: id)
        description.cloudKitContainerOptions = cloudKitOptions
        
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        //        do {
        //            try container.initializeCloudKitSchema()
        //        } catch {
        //            print("Unable to initialize CloudKit schema: \(error.localizedDescription)")
        //        }
        
        viewContext.automaticallyMergesChangesFromParent = true
        viewContext.mergePolicy = NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType
        viewContext.transactionAuthor = "Habits"
        
        if !inMemory {
          do {
            try viewContext.setQueryGenerationFrom(.current)
          } catch {
            let nsError = error as NSError
            os_log(
              .error,
              log: .default,
              "Failed to pin viewContext to the current generation: %@",
              nsError)
          }
        }
        
        // Observe Core Data remot change notifications
        NotificationCenter.default
          .publisher(for: .NSPersistentStoreRemoteChange)
          .sink {
            self.processRemoteStoreChange($0)
          }
          .store(in: &subscriptions)
        
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(calendarDayDidChange),
                                               name:.NSCalendarDayChanged,
                                               object:nil)
        
        loadHistoryToken()
    }
    
    //MARK: - Data functions
    
    func deleteManagedObject(_ object: NSManagedObject) {
      viewContext.perform { [context = viewContext] in
        context.delete(object)
        self.saveViewContext()
      }
    }
    
    func addHabit(titel: String?,
                  symbolID: SymbolHelper.SymbolID,
                  colorID: ColorHelper.ColorID,
                  goal: Int64,
                  goalPeriodID: GoalPeriodHelper.GoalPeriodID) {
        viewContext.perform { [context = viewContext] in
            let cdHabit = CDHabit(context: context)
            cdHabit.titel = titel
            cdHabit.symbolID = symbolID
            cdHabit.colorID = colorID
            cdHabit.goal = goal
            cdHabit.goalPeriodID = goalPeriodID
            
            cdHabit.position = Int64(CDHabit.getAllCDHabits(in: context).count)
            cdHabit.internal_id = UUID().uuidString
            cdHabit.creationDate = Date()
            
            self.saveViewContext()
        }
    }
    
    func changeHabit(_ habit: CDHabit,
                     titel: String?,
                     symbolID: SymbolHelper.SymbolID,
                     colorID: ColorHelper.ColorID,
                     goal: Int64,
                     goalPeriodID: GoalPeriodHelper.GoalPeriodID) {
        viewContext.performAndWait {
            habit.titel = titel
            habit.symbolID = symbolID
            habit.colorID = colorID
            habit.goal = goal
            habit.goalPeriodID = goalPeriodID
            
            self.saveViewContext()
        }
    }
    
    func deleteEntry(of habit: CDHabit, withDayString dayString: String) {
        guard let entrys = habit.entrys else {return}
        
        let dayEntrys = entrys.filter({ (habitEntry) -> Bool in
            return (habitEntry as! CDHabitEntry).dayString == dayString
        })
        
        if let entryToDelete = dayEntrys.last as? CDHabitEntry {
            deleteManagedObject(entryToDelete)
        }
    }
    
    func addEntry(to cdHabit: CDHabit, withDayString dayString: String) {
        viewContext.perform { [context = viewContext] in
            let cdHabitEntry = CDHabitEntry(context: context)
            cdHabitEntry.habit = cdHabit
            cdHabitEntry.dayString = dayString
            cdHabitEntry.creationDate = Date()
            
            self.saveViewContext()
        }
    }
    
    func saveViewContext() {
        print("save")
        guard viewContext.hasChanges else { return }
        print("has changed")
        do {
            try viewContext.save()
            updateExtensions()
        } catch {
            let nsError = error as NSError
            os_log(.error, log: .default, "Error saving changes %@", nsError)
        }
    }
    
    // MARK: - History Management

    private func loadHistoryToken() {
      do {
        let tokenData = try Data(contentsOf: tokenFileURL)
        lastHistoryToken = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSPersistentHistoryToken.self, from: tokenData)
      } catch {
        let nsError = error as NSError
        os_log(
          .error,
          log: .default,
          "Failed to load history token data file: %@",
          nsError)
      }
    }

    private func storeHistoryToken(_ token: NSPersistentHistoryToken) {
      do {
        let data = try NSKeyedArchiver
          .archivedData(withRootObject: token, requiringSecureCoding: true)
        try data.write(to: tokenFileURL)
        lastHistoryToken = token
      } catch {
        let nsError = error as NSError
        os_log(
          .error,
          log: .default,
          "Failed to write history token data file: %@",
          nsError)
      }
    }
    
    func processRemoteStoreChange(_ notification: Notification) {
        historyRequestQueue.async {
            let backgroundContext = self.container.newBackgroundContext()
            backgroundContext.performAndWait {
                let request = NSPersistentHistoryChangeRequest
                    .fetchHistory(after: self.lastHistoryToken)
                
                if let historyFetchRequest = NSPersistentHistoryTransaction.fetchRequest {
                    historyFetchRequest.predicate =
                        NSPredicate(format: "%K != %@", "author", "Habits")
                    request.fetchRequest = historyFetchRequest
                }
                
                do {
                    let result = try backgroundContext.execute(request) as? NSPersistentHistoryResult
                    guard
                        let transactions = result?.result as? [NSPersistentHistoryTransaction],
                        !transactions.isEmpty
                    else {
                        return
                    }
                    
                    print("remoteChange")
                    // Update the viewContext with the changes
                    self.mergeChanges(from: transactions)
                    self.updateExtensions()
                    
                    if let newToken = transactions.last?.token {
                        // Update the history token using the last transaction.
                        self.storeHistoryToken(newToken)
                    }
                } catch {
                    let nsError = error as NSError
                    os_log(
                        .error,
                        log: .default,
                        "Persistent history request error: %@",
                        nsError)
                }
            }
        }
    }
    
    private func mergeChanges(from transactions: [NSPersistentHistoryTransaction]) {
        let context = viewContext
        context.perform {
            transactions.forEach { transaction in
                guard let userInfo = transaction.objectIDNotification().userInfo else {
                    return
                }
                
                NSManagedObjectContext
                    .mergeChanges(fromRemoteContextSave: userInfo, into: [context])
            }
        }
    }
    
    func updateExtensions() {
        print("updateExtensions")
        #if !os(watchOS)
        WidgetCenter.shared.reloadAllTimelines()
        #endif
        #if os(watchOS)
        DispatchQueue.global().async {
            CLKComplicationServer.sharedInstance().reloadComplicationDescriptors()
            for complication in CLKComplicationServer.sharedInstance().activeComplications ?? [] {
                CLKComplicationServer.sharedInstance().reloadTimeline(for: complication)
            }
        }
        #endif
    }
    
    //MARK: - Day change
    
    @objc func calendarDayDidChange() {
        DayInformation.shared.dayString = Date().dayMonthYearString
        #if !os(watchOS)
        WidgetCenter.shared.reloadAllTimelines()
        #endif
    }
}

extension PersistenceController {
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for n in 0..<10 {
//            addHabit(titel: "\(n)",
//                             symbolID: SymbolHelper.randomSymbol,
//                             colorID: ColorHelper.randomColor,
//                             goal: Int64(n),
//                             goalPeriodID: .daily)
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}
