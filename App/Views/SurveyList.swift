import SwiftUI
import RealmSwift

/// View a list of all Surveys in the realm. User can swipe to delete Items.
struct SurveyList: View {
    // ObservedResults is a collection of all Survey objects in the realm.
    // Deleting objects from the observed collection
    // deletes them from the realm.
    @ObservedResults(Survey.self, sortDescriptor: SortDescriptor(keyPath: "_id", ascending: true)) var surveys
    
    var body: some View {
        VStack {
            List {
                ForEach(surveys) { survey in
                    SurveyRow(survey: survey)
                }
                .onDelete(perform: $surveys.remove)
            }
            .listStyle(InsetListStyle())
        }
        .navigationBarTitle("Surveys", displayMode: .inline)
    }
}
