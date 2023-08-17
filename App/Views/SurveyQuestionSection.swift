//
//  SurveyQuestionSection.swift
//  App
//
//  Created by David Freifeld on 8/17/23.
//

import SwiftUI
import RealmSwift

struct SurveyQuestionSection: View {
    @ObservedRealmObject var survey: Survey
    var body: some View {
        Section(header: Text("Survey Code: \(survey.code)")) {
            Text(survey.questionText)
                .font(.headline)
        }
    }
}
