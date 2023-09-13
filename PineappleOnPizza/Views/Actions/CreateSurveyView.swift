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
    @Binding var isPresentingAddSurveyView: Bool
    @State var user: User
    @State var questionText = ""
    @State var answerText = ""
    @State var minVotes = 20.0
    @State var nickname = ""
    
    @State var errorMessage: ErrorMessage? = nil

    func randomString() -> String {
      let letters = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
      return String((0..<6).map{ _ in letters.randomElement()! })
    }
    
    var body: some View {
        Form {
            Section("Survey Question") {
                // When using Atlas Device Sync, binding directly to the
                // synced property can cause performance issues. Instead,
                // we'll bind to a `@State` variable and then assign to the
                // synced property when the user presses `Save`
                TextField("Do you like pineapple on pizza?", text: $questionText)
                    .onAppear {
                        UITextField.appearance().clearButtonMode = .whileEditing
                    }
                    .listRowBackground(Color("ListItemColor"))
            }
            Section(header: Text("Answers")) {
                ForEach(newSurvey.answers) { answer in
                    Text(answer.answerText)
                        .listRowBackground(Color("ListItemColor"))
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
                .listRowBackground(Color("ListItemColor"))
            }
            Section(header: Text("Minimum Votes Required")) {
                HStack {
                    Slider(value: $minVotes, in: 0...200, step: 1) {
                        Text("Minimum Votes Required")
                    }
                    Spacer()
                    Text("\(Int(minVotes))")
                }
                .listRowBackground(Color("ListItemColor"))
            }
            Section(header: Text("My Nickname (For Scoreboard)")) {
                TextField("Optional", text: $nickname)
                    .onAppear {
                        UITextField.appearance().clearButtonMode = .whileEditing
                    }
                    .listRowBackground(Color("ListItemColor"))
            }
            HStack {
                Spacer()
                Button(action: {
                    // Append the last answer, even if the user didn't hit the plus
                    if answerText != "" {
                        let answer = Answer()
                        answer.answerText = answerText
                        newSurvey.answers.append(answer)
                    }
                    
                    if questionText == "" {
                        self.errorMessage = ErrorMessage(errorText: "Please supply a question for this survey.")
                    } else if newSurvey.answers.count < 2 {
                        self.errorMessage = ErrorMessage(errorText: "Please supply at least two answers for this survey.")
                    } else {
                        newSurvey.owner_id = user.id
                        // To avoid updating too many times and causing Sync-related
                        // performance issues, we only assign to the `newSurvey.questionText`
                        // once when the user presses `Save`.
                        newSurvey.questionText = questionText
                        newSurvey.minVotes = Int(minVotes)
                        newSurvey.code = randomString()
                        newSurvey.userMap[user.id] = nickname
                        newSurvey.status = Status.new
                        // Appending the new Survey object to the ``surveys``
                        // ObservedResults collection adds it to the
                        // realm in an implicit write.
                        $surveys.append(newSurvey)
                        // Now we're done with this view, so set the
                        // ``isInCreateSurveyView`` variable to false to
                        // return to the SurveysView.
                        answerText = ""
                        newSurvey = Survey()
                        isPresentingAddSurveyView = false
                    }
                }) {
                    HStack {
                        Spacer()
                        Text("Save")
                        Spacer()
                    }
                }
                .frame(width: 200, height: 60)
                .background(Color("CompletedSurveyColor"))
                .foregroundColor(.white)
                .clipShape(Capsule())
                Spacer()
            } // HStack
            .listRowBackground(Color("MainBackgroundColor"))
        } // Form
        .navigationBarTitle("Create New Survey")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    isPresentingAddSurveyView = false
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color("MainBackgroundColor"))
        .alert(item: $errorMessage) { errorMessage in
            Alert(
                title: Text("Failed to create survey"),
                message: Text(errorMessage.errorText),
                dismissButton: .cancel()
            )
        }
    }
}
