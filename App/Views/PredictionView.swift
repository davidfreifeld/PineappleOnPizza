//
//  PredictionView.swift
//  PineappleOnPizza
//
//  Created by David Freifeld on 7/30/23.
//

import SwiftUI
import RealmSwift

struct PredictionView: View {
    @ObservedRealmObject var survey: Survey
    
    @State var predictions: [Double]
    
    @Binding var isPresentingPredictionView: Bool
    
    @Environment(\.realm) private var realm
    
    init(survey: Survey, isPresentingPredictionView: Binding<Bool>) {
        self.survey = survey
        self._isPresentingPredictionView = isPresentingPredictionView
        
        // initialize all the predictions to be equal
        let answers = survey.answers
        let answerCount = answers.count
        let defaultPrediction = 100.0 / Double(answerCount)
        self.predictions = Array(repeating: defaultPrediction, count: answers.count)
    }
    
    var body: some View {
        List {
            Section(header: Text("Question")) {
                Text(survey.questionText)
            }
            Section(header: Text("Answers")) {
                // This section is for setting a prediction
                if !survey.answers.first!.predictions.contains(where: { $0.user_id == app.currentUser?.id }) {
                    ForEach(0..<survey.answers.count, id: \.self) { answerIndex in
                        Text(survey.answers[answerIndex].answerText)
                        HStack {
                            Slider(value: $predictions[answerIndex], in: 0...100, step: 1) {
                                Text("Prediction")
                            }
                            Spacer()
                            Text("\(Int(predictions[answerIndex]))%")
                        }
                    }
                    HStack {
                        Text("Total (Must Be 100% to Submit):")
                        Spacer()
                        Text("\(Int(predictions.reduce(0, +)))%")
                    }
                }
//                // This is to view the prediction, that's already been set
//                else {
//                    ForEach(0..<survey.answers.count) { answerIndex in
//                        HStack {
//                            ProgressView(value: Double() / Double(100)) {
//                                HStack {
//                                    Text(survey.answers[answerIndex].answerText)
//                                    Spacer()
//                                    Text("\(Int(Double()))%")
//                                }
//                            }
//                        }
//                    }
//                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Dismiss") {
                    isPresentingPredictionView = false
                }
            }
//            if !model.hasUserSetPrediction(surveyId: surveyId) {
            ToolbarItem(placement: .confirmationAction) {
                Button("Submit") {
                    for answerIndex in 0..<survey.answers.count {
                        let newPrediction = Prediction()
                        newPrediction.user_id = app.currentUser!.id
                        newPrediction.predictionValue = predictions[answerIndex]
                        
                        let answer = survey.answers[answerIndex]
                        let thawedAnswer = answer.thaw()
                        
                        try! realm.write {
                            thawedAnswer!.predictions.append(newPrediction)
                        }
                    }
                    isPresentingPredictionView = false
                }
//                .disabled(predictions.values.reduce(0, +) != 100)
            }
        }
        .navigationTitle("Survey Prediction")
    }
}
