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
                    HStack {
                        ProgressView(value: answer.getUserPrediction(user_id: app.currentUser!.id) / Double(100)) {
                            HStack {
                                Text(answer.answerText)
                                Spacer()
                                Text("\(Int(answer.getUserPrediction(user_id: app.currentUser!.id)))%")
                            }
                        }
                    }
                }
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
    }
}
