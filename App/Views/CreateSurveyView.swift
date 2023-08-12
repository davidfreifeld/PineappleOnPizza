import SwiftUI
import RealmSwift

/// Instantiate a new Survey object, and then
/// append it to the ``surveys`` collection to add it to the Item list.
struct CreateSurveyView: View {
    // The ``surveys`` ObservedResults collection is the
    // entire list of Survey objects in the realm.
    @ObservedResults(Survey.self) var surveys
    // Create a new Realm Survey object.
    @State private var newSurvey = Survey()
    // We've passed in the ``creatingNewSurvey`` variable
    // from the SurveysView to know when the user is done
    // with the new Survey and we should return to the SurveysView.
    @Binding var isInCreateSurveyView: Bool
    @State var user: User
    @State var questionText = ""
    @State var answerText = ""

    var body: some View {
        Form {
            Section(header: Text("Survey Question")) {
                // When using Atlas Device Sync, binding directly to the
                // synced property can cause performance issues. Instead,
                // we'll bind to a `@State` variable and then assign to the
                // synced property when the user presses `Save`
                TextField("New survey", text: $questionText)
                    .onAppear {
                        UITextField.appearance().clearButtonMode = .whileEditing
                    }
            }
            Section(header: Text("Answers")) {
                ForEach(newSurvey.answers) { answer in
                    Text(answer.answerText)
                }
                .onDelete { indices in
                    newSurvey.answers.remove(atOffsets: indices)
                }
                HStack {
                    TextField("Add Answer", text: $answerText)
                    Button(action: {
                        // TODO: Include the last answer if it's filled in, even
                        // if they didn't hit the plus button
                        let answer = Answer()
                        answer.answerText = answerText
                        newSurvey.answers.append(answer)
                        answerText = ""
                    }) {
                        Image(systemName: "plus.circle.fill")
                    }
                    .disabled(answerText.isEmpty)
                }
            }
            Section {
                Button(action: {
                    newSurvey.owner_id = user.id
                    // To avoid updating too many times and causing Sync-related
                    // performance issues, we only assign to the `newSurvey.questionText`
                    // once when the user presses `Save`.
                    newSurvey.questionText = questionText
                    // Append the last answer, even if the user didn't hit the plus
                    if answerText != "" {
                        let answer = Answer()
                        answer.answerText = answerText
                        newSurvey.answers.append(answer)
                    }
                    // Appending the new Survey object to the ``surveys``
                    // ObservedResults collection adds it to the
                    // realm in an implicit write.
                    $surveys.append(newSurvey)
                    // Now we're done with this view, so set the
                    // ``isInCreateSurveyView`` variable to false to
                    // return to the SurveysView.
                    isInCreateSurveyView = false
                }) {
                    HStack {
                        Spacer()
                        Text("Save")
                        Spacer()
                    }
                }
                Button(action: {
                    // If the user cancels, we don't want to
                    // append the new object we created to the
                    // list, so we set the ``isInCreateSurveyView``
                    // value to false to return to the SurveysView.
                    isInCreateSurveyView = false
                }) {
                    HStack {
                        Spacer()
                        Text("Cancel")
                        Spacer()
                    }
                }
            }
        }
        .navigationBarTitle("Create New Survey")
    }
}
