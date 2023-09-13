//
//  FinalScoresView.swift
//  App
//
//  Created by David Freifeld on 8/18/23.
//

import SwiftUI
import RealmSwift

struct FinalResultsView: View {
//    @State var finalScores: Array<(String, Double)> //[(String, Double)]
    @ObservedRealmObject var survey: Survey
    @Binding var isPresentingFinalResultsView: Bool
    
    var body: some View {
        VStack {
            List {
                SurveyQuestionSection(survey: survey)
                Section(header: Text("Error Scores (Lower is better)")) {
                    ForEach(Array(survey.getFinalScoresSortedUserList().enumerated()), id: \.self.0) { index, tuple in
                        HStack {
                            Text("\(index+1).")
                            if survey.userMap[tuple.0] == "" {
                                Text(StringUtils.getSubstringAtEnd(value: tuple.0))
                            } else {
                                Text(survey.userMap[tuple.0]!)
                            }
                            Text(tuple.0 == app.currentUser!.id ? "(Me)" : "")
                            Spacer()
                            if tuple.1 == nil {
                                Text("N/A")
                            } else {
                                Text(StringUtils.formatNumber(value: tuple.1!))
                            }
                        }
                        .listRowBackground(Color("ListItemColor"))
                        .font(tuple.0 == app.currentUser!.id ? Font.body.weight(.bold) : Font.body.weight(.regular))
                    }
                }
            } // List
            if app.currentUser!.id == survey.getFinalScoresSortedUserList()[0].0 {
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
