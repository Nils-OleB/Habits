//
//  SymbolHelper.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 23.10.20.
//

import Foundation

class SymbolHelper {
    static var symbols = SymbolID.allCases
    
    static var randomSymbol: SymbolID {
        return symbols.randomElement() ?? .symbol_1
    }
    
    enum SymbolID: String, CaseIterable {
        case symbol_1 = "pencil"
        case symbol_2 = "square.and.pencil"
        case symbol_3 = "terminal"
        case symbol_4 = "book"
        case symbol_5 = "books.vertical"
        case symbol_6 = "book.closed"
        case symbol_7 = "graduationcap"
        case symbol_8 = "ticket"
        case symbol_9 = "zzz"
        case symbol_10 = "moon.zzz"
        case symbol_11 = "keyboard"
        case symbol_12 = "drop"
        case symbol_13 = "play.circle"
        case symbol_14 = "music.note"
        case symbol_15 = "mic"
        case symbol_16 = "suit.club"
        case symbol_17 = "text.bubble"
        case symbol_18 = "phone"
        case symbol_19 = "envelope"
        case symbol_20 = "cart"
        case symbol_21 = "creditcard"
        case symbol_22 = "pianokeys"
        case symbol_23 = "tuningfork"
        case symbol_24 = "paintbrush.pointed"
        case symbol_25 = "hammer"
        case symbol_26 = "stethoscope"
        case symbol_27 = "case"
        case symbol_28 = "building.columns"
        case symbol_29 = "map"
        case symbol_30 = "tv"
        case symbol_31 = "guitars"
        case symbol_32 = "bicycle"
        case symbol_33 = "bed.double"
        case symbol_34 = "lungs"
        case symbol_35 =  "pills"
        case symbol_36 = "leaf"
        case symbol_37 = "sportscourt"
        case symbol_38 = "face.smiling"
        case symbol_39 = "comb"
        case symbol_40 = "alarm"
        case symbol_41 = "gamecontroller"
        case symbol_42 = "paintpalette"
        case symbol_43 = "figure.walk"
        case symbol_44 = "studentdesk"
        case symbol_45 = "dollarsign.circle"
    }
}
