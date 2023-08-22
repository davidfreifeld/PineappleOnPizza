//
//  SurveyRowColorView.swift
//  App
//
//  Created by David Freifeld on 8/21/23.
//

import SwiftUI
import RealmSwift

struct SurveyRowColorView: View {
    @ObservedRealmObject var survey: Survey
    var body: some View {
        survey.status.rowColor
    }
}
