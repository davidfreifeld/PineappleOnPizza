import SwiftUI
import RealmSwift

/// Show a detail view of a Survey. User can edit the summary or mark the Survey complete.
struct JoinSurveyView: View {
    @State private var surveyCode: String = ""
    @Binding var isInJoinSurveyView: Bool

    @ObservedResults(Survey.self) var surveys
    
    @Environment(\.realm) private var realm
    
    var body: some View {
        Form {
            Section {
                TextField("Survey Code", text: $surveyCode)
                    .onAppear {
                        UITextField.appearance().clearButtonMode = .whileEditing
                    }
            }
            Section {
                Button(action: {
                    let thawedSurvey = surveys.first(where: { $0.code == surveyCode })!.thaw()
                    try! realm.write {
                        thawedSurvey!.users.append(app.currentUser!.id)
                    }
                    isInJoinSurveyView = false
                }) {
                    HStack {
                        Spacer()
                        Text("Join Survey")
                        Spacer()
                    }
                }
                Button(action: {
                    // If the user cancels, we don't want to
                    // append the new object we created to the
                    // list, so we set the ``isInCreateSurveyView``
                    // value to false to return to the SurveysView.
                    isInJoinSurveyView = false
                }) {
                    HStack {
                        Spacer()
                        Text("Cancel")
                        Spacer()
                    }
                }
            }
        }
        .navigationBarTitle("Join Existing Survey")
    }
}
