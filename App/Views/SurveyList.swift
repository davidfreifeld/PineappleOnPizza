import SwiftUI
import RealmSwift

/// View a list of all Surveys in the realm. User can swipe to delete Items.
struct SurveyList: View {
    @State var showOpenSurveys: Bool
    // ObservedResults is a collection of all Survey objects in the realm.
    // Deleting objects from the observed collection
    // deletes them from the realm.
    @ObservedResults(Survey.self, sortDescriptor: SortDescriptor(keyPath: "_id", ascending: true)) var surveys
    
    var body: some View {
        VStack {
            List {
                if showOpenSurveys {
                    ForEach(surveys.where { !$0.isComplete && $0.users.contains(app.currentUser!.id) }) { survey in
                        SurveyRow(survey: survey)
                    }
                } else {
                    ForEach(surveys.where { $0.isComplete && $0.users.contains(app.currentUser!.id) }) { survey in
                        SurveyRow(survey: survey)
                    }
                }
                
            }
//            .listStyle(InsetListStyle())
        }
    }
}
