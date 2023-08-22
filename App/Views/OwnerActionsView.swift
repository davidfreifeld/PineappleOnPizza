//
//  OwnerActionsView.swift
//  App
//
//  Created by David Freifeld on 8/17/23.
//

import SwiftUI
import RealmSwift

struct OwnerActionsView: View {
    @ObservedRealmObject var survey: Survey
    
    @Environment(\.realm) var realm
    
    @Binding var isPresentingOwnerActionsView: Bool
    
    @State var isPresentingConfirmOpenView = false
    @State var isPresentingConfirmUnopenView = false
    @State var isPresentingConfirmReopenView = false
    @State var isPresentingConfirmCompleteView = false
    
    var body: some View {
        List {
            SurveyQuestionSection(survey: survey)
            if survey.status == Status.new {
                Button(action: {
                    isPresentingConfirmOpenView = true
                }) {
                    HStack {
                        Spacer()
                        Text("Open Survey")
                        Spacer()
                    }
                }
                .disabled(!survey.areAllPredictionsIn)
            } else if survey.status == Status.open {
                Button(action: {
                    isPresentingConfirmUnopenView = true
                }) {
                    HStack {
                        Spacer()
                        Text("Unopen Survey")
                        Spacer()
                    }
                }
                if survey.totalVotes >= survey.minVotes {
                    Button(action: {
                        isPresentingConfirmCompleteView = true
                    }) {
                        HStack {
                            Spacer()
                            Text("Complete Survey")
                            Spacer()
                        }
                    }
                }
            } else if survey.status == Status.completed {
                Button(action: {
                    isPresentingConfirmReopenView = true
                }) {
                    HStack {
                        Spacer()
                        Text("Reopen Survey")
                        Spacer()
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Dismiss") {
                    isPresentingOwnerActionsView = false
                }
            }
        }
        .navigationBarTitle("Survey Owner Actions", displayMode: .inline)
        .confirmationDialog("Are you sure?", isPresented: $isPresentingConfirmOpenView) {
            Button("Open Survey") {
                updateSurveyStatus(status: Status.open)
            }
        } message: {
            Text("Are you sure you are ready to open the survey?")
        }
        .confirmationDialog("Are you sure?", isPresented: $isPresentingConfirmUnopenView) {
            Button("Unopen Survey") {
                updateSurveyStatus(status: Status.new)
            }
        } message: {
            Text("Are you sure you want to unopen the survey?")
        }
        .confirmationDialog("Are you sure?", isPresented: $isPresentingConfirmCompleteView) {
            Button("Complete Survey") {
                updateSurveyStatus(status: Status.completed)
            }
        } message: {
            Text("Are you sure you want to complete the survey?")
        }
        .confirmationDialog("Are you sure?", isPresented: $isPresentingConfirmReopenView) {
            Button("Reopen Survey") {
                updateSurveyStatus(status: Status.open)
            }
        } message: {
            Text("Are you sure you want to reopen the survey?")
        }
    }
    
    func updateSurveyStatus(status: Status) {
        let thawedSurvey = survey.thaw()
        try! realm.write {
            thawedSurvey!.status = status
        }
        isPresentingOwnerActionsView = false
    }
    
}


