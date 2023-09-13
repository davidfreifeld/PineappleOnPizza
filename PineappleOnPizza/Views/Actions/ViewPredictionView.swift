//
//  PredictionView.swift
//  PineappleOnPizza
//
//  Created by David Freifeld on 7/30/23.
//

import SwiftUI
import RealmSwift

struct ViewPredictionView: View {
    
    @ObservedRealmObject var survey: Survey
    
    @Binding var isPresentingViewPredictionView: Bool
    
    var body: some View {
        List {
            SurveyQuestionSection(survey: survey)
            Section(header: Text("Answers")) {
                ForEach(survey.answers) { answer in
                    if let userPrediction = answer.getUserPrediction(user_id: app.currentUser!.id) {
                        ProgressView(value: userPrediction) {
                            HStack {
                                Text(answer.answerText)
                                Spacer()
                                Text("\(Int(userPrediction * 100))%")
                            }
                        }
                    } else {
                        HStack {
                            Text(answer.answerText)
                            Spacer()
                            Text("N/A")
                        }
                    }
                }
                .listRowBackground(Color("ListItemColor"))
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Dismiss") {
                    isPresentingViewPredictionView = false
                }
            }
        }
        .navigationBarTitle("Survey Prediction", displayMode: .inline)
        .scrollContentBackground(.hidden)
        .background(Color("MainBackgroundColor"))
    }
}
