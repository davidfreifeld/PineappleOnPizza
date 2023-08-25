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
        VStack {
            List {
                SurveyQuestionSection(survey: survey)
                Section(header: Text("Scoreboard")) {
                    ForEach(Array(survey.getFinalScoresSortedUserList().enumerated()), id: \.element) { index, user_id in
                        HStack {
                            if survey.userMap[user_id] == "" {
                                Text(Utils.getSubstringAtEnd(value: user_id))
                            } else {
                                Text("\(index+1). \(survey.userMap[user_id]!)")
                            }
                            Text(user_id == app.currentUser!.id ? "(Me)" : "")
                            Spacer()
                            Text(Utils.formatNumber(value: survey.getUserFinalScore(user_id: user_id)))
                        }
                        .listRowBackground(Color("ListItemColor"))
                        .font(user_id == app.currentUser!.id ? Font.body.weight(.bold) : Font.body.weight(.regular))
                    }
                }
            } // List
            if app.currentUser!.id == survey.getFinalScoresSortedUserList()[0] {
                Text("You won!")
                    .font(.headline)
                Image("pineapple-happy-alpha")
                    .resizable()
                    .frame(width: 160, height: 160)
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
        .scrollContentBackground(.hidden)
        .background(Color("MainBackgroundColor"))
    }
}
