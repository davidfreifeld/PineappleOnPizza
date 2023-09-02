import SwiftUI
import RealmSwift

/// Show a detail view of a Survey. User can edit the summary or mark the Survey complete.
struct JoinSurveyView: View {
    @State private var surveyCode: String = ""
    @State private var nickname: String = ""
    @Binding var isPresentingAddSurveyView: Bool

    @ObservedResults(Survey.self) var surveys
    
    @Environment(\.realm) private var realm
    
    @State var errorMessage: ErrorMessage? = nil
    
    var body: some View {
        VStack {
            Form {
                Section("Survey Code") {
                    TextField("ABC123", text: $surveyCode)
                        .onAppear {
                            UITextField.appearance().clearButtonMode = .whileEditing
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
            } // Form

            Button(action: {
                guard let survey = surveys.first(where: { $0.code == surveyCode.uppercased() }) else {
                    self.errorMessage = ErrorMessage(errorText: "Could not find survey")
                    return
                }
                do {
                    if survey.thaw()!.userMap.keys.contains(app.currentUser!.id) {
                        self.errorMessage = ErrorMessage(errorText: "You've already joined this survey!")
                    } else {
                        try realm.write {
//                                survey.thaw()!.users.append(app.currentUser!.id)
                            survey.thaw()!.userMap[app.currentUser!.id] = nickname
                            isPresentingAddSurveyView = false
                        }
                    }
                } catch {
                    self.errorMessage = ErrorMessage(errorText: error.localizedDescription)
                }
            }) {
                HStack {
                    Spacer()
                    Text("Join Survey")
                    Spacer()
                }
            }
            .frame(width: 200, height: 60)
            .background(Color("CompletedSurveyColor"))
            .foregroundColor(.white)
            .clipShape(Capsule())

        } // VStack
        .navigationBarTitle("Join Existing Survey")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    isPresentingAddSurveyView = false
                }
            }
        }
        .alert(item: $errorMessage) { errorMessage in
            Alert(
                title: Text("Failed to join survey"),
                message: Text(errorMessage.errorText),
                dismissButton: .cancel()
            )
        }
        .scrollContentBackground(.hidden)
        .background(Color("MainBackgroundColor"))
    }
}
