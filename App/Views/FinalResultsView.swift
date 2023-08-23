//
//  FinalScoresView.swift
//  App
//
//  Created by David Freifeld on 8/18/23.
//

import SwiftUI
import RealmSwift

struct FinalResultsView: View {
    @ObservedRealmObject var survey: Survey
    @Binding var isPresentingFinalResultsView: Bool
    var body: some View {
        //        Text("My email: \(app.currentUser!.profile.email!)")
        
        List {
            SurveyQuestionSection(survey: survey)
//            ForEach(0..<survey.users.count, id: \.self) { userIndex in
            ForEach(survey.getFinalScoresSortedUserList(), id: \.self) { user_id in
                HStack {
                    if survey.userMap[user_id] == "" {
                        Text(Utils.getSubstringAtEnd(value: user_id))
                    } else {
                        Text(survey.userMap[user_id]!)
                    }
                    Text(user_id == app.currentUser!.id ? "(Me):" : ":")
                    Spacer()
                    Text(Utils.formatNumber(value: survey.getUserFinalScore(user_id: user_id)))
                        
                }
                .foregroundColor(user_id == app.currentUser!.id ? .green : .black)
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Dismiss") {
                    isPresentingFinalResultsView = false
                }
            }
        }
        .navigationBarTitle("Final Results", displayMode: .inline)
        
    }
}
