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
    
    @State private var selection: String?
    
    @Binding var isPresentingTallyResponseView: Bool
    
    @Environment(\.realm) private var realm
    
    var body: some View {
        List(selection: $selection) {
            SurveyQuestionSection(survey: survey)
            Section(header: Text("Answers")) {
                ForEach(survey.answers) { answer in
                    Button(answer.answerText) {
                        let thawedAnswer = answer.thaw()
                        try! realm.write {
                            thawedAnswer!.currentVotes = thawedAnswer!.currentVotes + 1
                        }
                        isPresentingTallyResponseView = false
                    }
                    .listRowBackground(Color("ListItemColor"))
                }
            }
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
    }
}
