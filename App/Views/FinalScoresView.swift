//
//  FinalScoresView.swift
//  App
//
//  Created by David Freifeld on 8/18/23.
//

import SwiftUI
import RealmSwift

struct FinalScoresView: View {
    @ObservedRealmObject var survey: Survey
    var body: some View {
//        Text("My score: \(survey.getUserFinalScore(user_id: app.currentUser!.id))")
//            .foregroundColor(.green)
        // show all scores
        ForEach(0..<survey.users.count, id: \.self) { userIndex in
            Text("\(survey.users[userIndex]): \(survey.getUserFinalScore(user_id: app.currentUser!.id))")
        }
    }
}
