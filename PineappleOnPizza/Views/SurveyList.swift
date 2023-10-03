import SwiftUI
import RealmSwift

/// View a list of all Surveys in the realm. User can swipe to delete Items.
struct SurveyList: View {
    // ObservedResults is a collection of all Survey objects in the realm.
    // Deleting objects from the observed collection
    // deletes them from the realm.
    @ObservedResults(Survey.self, where: { $0.userMap.keys.contains(app.currentUser!.id) }, sortDescriptor: SortDescriptor(keyPath: "_id", ascending: true)) var surveys
//    @Environment(\.realm) var realm
    
    var body: some View {
        List {
            if !surveys.where({ $0.status == Status.new }).isEmpty {
                Section("Surveys Accepting Predictions") {
                    ForEach(surveys.where { $0.status == Status.new }) { survey in
                        SurveyRow(survey: survey)
                    }
                }
            }
            if !surveys.where({ $0.status == Status.open }).isEmpty {
                Section("Surveys Accepting Responses") {
                    ForEach(surveys.where { $0.status == Status.open }) { survey in
                        SurveyRow(survey: survey)
                    }
                }
            }
            if !surveys.where({ $0.status == Status.completed }).isEmpty {
                Section("Completed Surveys") {
                    ForEach(surveys.where { $0.status == Status.completed }) { survey in
                        SurveyRow(survey: survey)
                    }
                }
//                .onDelete { indices in
//                    let thawedSurvey = surveys.where { $0.status == Status.completed }[indices.first!].thaw()
//                    try! realm.write {
//                        thawedSurvey!.status = Status.archived
//                    }
//                }
            }
        }
    }
}
