import SwiftUI
import RealmSwift

/// View a list of all Surveys in the realm. User can swipe to delete Items.
struct CompletedSurveyList: View {
    // ObservedResults is a collection of all Survey objects in the realm.
    // Deleting objects from the observed collection
    // deletes them from the realm.
    @ObservedResults(Survey.self, where: { $0.users.contains(app.currentUser!.id) }, sortDescriptor: SortDescriptor(keyPath: "_id", ascending: true)) var surveys
    
    var body: some View {
        List {
            ForEach(surveys.where { $0.isComplete }) { survey in
                SurveyRow(survey: survey)
            }
        }
    }
}
