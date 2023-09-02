//
//  PredictionView.swift
//  PineappleOnPizza
//
//  Created by David Freifeld on 7/30/23.
//

import SwiftUI
import RealmSwift

struct SetPredictionView: View {
    @ObservedRealmObject var survey: Survey

    @State var predictions: [Double]
    
    @Binding var isPresentingSetPredictionView: Bool
    
    @Environment(\.realm) private var realm
    
    init(survey: Survey, isPresentingSetPredictionView: Binding<Bool>) {
        self.survey = survey
        self._isPresentingSetPredictionView = isPresentingSetPredictionView
        
        // initialize all the predictions to be equal
        let answers = survey.answers
        let answerCount = answers.count
        let defaultPrediction = 100.0 / Double(answerCount)
        self.predictions = Array(repeating: defaultPrediction, count: answers.count)
    }
    
    var body: some View {
        List {
            SurveyQuestionSection(survey: survey)
            Section(header: Text("Answers")) {
                // This section is for setting a prediction
                ForEach(0..<survey.answers.count, id: \.self) { answerIndex in
                    Text(survey.answers[answerIndex].answerText)
                        .listRowBackground(Color("ListItemColor"))
                    HStack {
                        Slider(value: $predictions[answerIndex], in: 0...100, step: 1) {
                            Text("Prediction")
                        }
                        Spacer()
                        Text("\(Int(predictions[answerIndex]))%")
                    }
                    .listRowBackground(Color("ListItemColor"))
                }
                HStack {
                    Text("Total (Must Be 100% to Submit):")
                    Spacer()
                    Text("\(Int(predictions.reduce(0, +)))%")
                }
                .listRowBackground(Color("ListItemColor"))
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    isPresentingSetPredictionView = false
                }
            }
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
                    isPresentingSetPredictionView = false
                }
                .disabled(predictions.map { Int($0) }.reduce(0, +) != 100)
            }
        }
        .navigationBarTitle("Survey Prediction", displayMode: .inline)
        .scrollContentBackground(.hidden)
        .background(Color("MainBackgroundColor"))
    }
}
