//
//  Status.swift
//  App
//
//  Created by David Freifeld on 8/16/23.
//

import SwiftUI
import RealmSwift

enum Status: Int, PersistableEnum {
    case new = 1
    case open = 2
    case completed = 3
    var name: String {
        switch self {
        case .new:
            return "New"
        case .open:
            return "Open"
        case .completed:
            return "Completed"
        }
    }
    var rowColor: Color {
        switch self {
        case .new: return Color("NewSurveyColor")
        case .open: return Color("OpenSurveyColor")
        case .completed: return Color("CompletedSurveyColor")
        }
    }
}
