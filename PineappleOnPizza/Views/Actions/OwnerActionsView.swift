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
    @State var isPresentingConfirmArchiveView = false
    
    var body: some View {
        VStack {
            List {
                SurveyQuestionSection(survey: survey)
            }
            .frame(maxHeight: 150)
            if survey.status == Status.new && survey.areAllPredictionsIn {
                Button(action: {
                    isPresentingConfirmOpenView = true
                }) {
                    HStack {
                        Spacer()
                        Text("Open Survey")
                        Spacer()
                    }
                }
                .frame(width: 250, height: 50)
                .background(Color("CompletedSurveyColor"))
                .foregroundColor(.white)
                .clipShape(Capsule())
            } else if survey.status == Status.open {
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
                    .frame(width: 250, height: 50)
                    .background(Color("CompletedSurveyColor"))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                }
                Button(action: {
                    isPresentingConfirmUnopenView = true
                }) {
                    HStack {
                        Spacer()
                        Text("Unopen Survey")
                        Spacer()
                    }
                }
                .frame(width: 150, height: 40)
                .background(.gray)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .padding(.top, 10)
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
                .frame(width: 150, height: 40)
                .background(.gray)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
            // Archive the survey
            Button(action: {
                isPresentingConfirmArchiveView = true
            }) {
                HStack {
                    Spacer()
                    Text("Archive Survey")
                    Spacer()
                }
            }
            .frame(width: 150, height: 40)
            .background(.gray)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .padding(.top, 10)
            Spacer()
            PineappleMessageView(message: survey.statusString)
        } // VStack
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
        .confirmationDialog("Are you sure?", isPresented: $isPresentingConfirmArchiveView) {
            Button("Archive Survey") {
                updateSurveyStatus(status: Status.archived)
            }
        } message: {
            Text("Are you sure you want to archive the survey?")
        }
        .scrollContentBackground(.hidden)
        .background(Color("MainBackgroundColor"))
    }
    
    func updateSurveyStatus(status: Status) {
        let thawedSurvey = survey.thaw()
        try! realm.write {
            thawedSurvey!.status = status
        }
        isPresentingOwnerActionsView = false
    }
    
}


