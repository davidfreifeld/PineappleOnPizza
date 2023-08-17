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
    
    var body: some View {
        Section("Owner Actions") {
            Button(action: {
                let thawedSurvey = survey.thaw()
                try! realm.write {
                    thawedSurvey!.status = Status.open
                }
            }) {
                HStack {
                    Spacer()
                    Text("Open Survey")
                    Spacer()
                }
            }
            .disabled(survey.status != Status.new || !survey.areAllPredictionsIn())
            Button(action: {
                let thawedSurvey = survey.thaw()
                try! realm.write {
                    thawedSurvey!.status = Status.completed
                }
            }) {
                HStack {
                    Spacer()
                    Text("Complete Survey")
                    Spacer()
                }
            }
            .disabled(survey.status != Status.open)
        }
    }
}
