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
        Section(header: HStack {
            if survey.status != Status.completed {
                Text("\(survey.status.name)")
                    .background(survey.status.rowColor)
                    .padding(2)
                    .clipShape(Capsule())
            }
            Text("Survey Code: \(survey.code)")
        }) {
            Text(survey.questionText)
                .font(.headline)
                .listRowBackground(Color("ListItemColor"))
        }
    }
}
