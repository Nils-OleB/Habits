//
//  URLExtension.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 27.01.21.
//

import Foundation

public extension URL {
    /// Returns a URL for the given app group and database pointing to the sqlite database.
    static func storeURL(databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.nils-ole.habits")
        else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
