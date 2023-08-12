import SwiftUI
import RealmSwift

/// Show a detail view of a Survey. User can edit the summary or mark the Survey complete.
struct SurveyDetail: View {
    // This property wrapper observes the Survey object and
    // invalidates the view when the Survey object changes.
    @ObservedRealmObject var survey: Survey

    var body: some View {
        Form {
            Section(header: Text("Edit Survey")) {
                // Accessing the observed survey object lets us update the live object
                // No need to explicitly update the object in a write transaction
                TextField("Question", text: $survey.questionText)
            }
            Section {
                Toggle(isOn: $survey.isComplete) {
                    Text("Complete")
                }
            }
        }
        .navigationBarTitle("Update Suruvey", displayMode: .inline)
    }
}
