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
                // This is to view the prediction, that's already been set
                ForEach(0..<survey.answers.count, id: \.self) { answerIndex in
                    HStack {
                        ProgressView(value: Double(survey.answers[answerIndex].predictions.first( where: { $0.user_id == app.currentUser?.id } )!.predictionValue) / Double(100)) {
                            HStack {
                                Text(survey.answers[answerIndex].answerText)
                                Spacer()
                                Text("\(Int(Double(survey.answers[answerIndex].predictions.first( where: { $0.user_id == app.currentUser?.id } )!.predictionValue)))%")
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
