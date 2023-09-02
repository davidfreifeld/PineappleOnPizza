//
//  TallyResponseView.swift
//  PineappleOnPizza
//
//  Created by David Freifeld on 7/21/23.
//

import SwiftUI
import RealmSwift

struct TallyResponseView: View {
    // This property wrapper observes the Survey object and
    // invalidates the view when the Survey object changes.
    @ObservedRealmObject var survey: Survey
    
    @State private var selection: Answer?
    @State var errorMessage: ErrorMessage? = nil
    
    @Binding var isPresentingTallyResponseView: Bool

    @Environment(\.realm) private var realm
    
    var body: some View {
        VStack {
            
            List {
                SurveyQuestionSection(survey: survey)
            }
            .frame(maxHeight: 100)
            
            List(selection: $selection) {
                Section(header: Text("Answers")) {
                    ForEach(survey.answers, id: \.self) { answer in
                        Label(answer.answerText, systemImage: selection != nil && selection!.id == answer.id ? "checkmark.circle.fill" : "circle")
                            .listRowBackground(Color("ListItemColor"))
                    } // ForEach
                } // Section "Answers"
            } // List - Answers
            
            Button("Submit") {
                if selection == nil {
                    self.errorMessage = ErrorMessage(errorText: "Please select an answer")
                } else {
                    let thawedAnswer = survey.answers.first { $0.id == selection!.id }!.thaw()
                    try! realm.write {
                        thawedAnswer!.currentVotes = thawedAnswer!.currentVotes + 1
                    }
                    isPresentingTallyResponseView = false
                }
            }
            .frame(width: 200, height: 60)
            .background(Color("CompletedSurveyColor"))
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    isPresentingTallyResponseView = false
                }
            }
        }
        .navigationTitle("Tally Response")
        .scrollContentBackground(.hidden)
        .background(Color("MainBackgroundColor"))
        .alert(item: $errorMessage) { errorMessage in
            Alert(
                title: Text("Failed to submit response"),
                message: Text(errorMessage.errorText),
                dismissButton: .cancel()
            )
        }
    }
}
