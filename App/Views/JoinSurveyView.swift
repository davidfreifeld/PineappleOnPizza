import SwiftUI
import RealmSwift

/// Show a detail view of a Survey. User can edit the summary or mark the Survey complete.
struct JoinSurveyView: View {
    @State private var surveyCode: String = ""
    @State private var nickname: String = ""
    @Binding var isPresentingJoinSurveyView: Bool

    @ObservedResults(Survey.self) var surveys
    
    @Environment(\.realm) private var realm
    
    @State var errorMessage: ErrorMessage? = nil
    
    var body: some View {
        Form {
            Section {
                TextField("Survey Code", text: $surveyCode)
                    .onAppear {
                        UITextField.appearance().clearButtonMode = .whileEditing
                    }
            }
            Section(header: Text("Nickname")) {
                TextField("Optional", text: $nickname)
                    .onAppear {
                        UITextField.appearance().clearButtonMode = .whileEditing
                    }
            }
            Section {
                Button(action: {
                    guard let survey = surveys.first(where: { $0.code == surveyCode.uppercased() }) else {
                        self.errorMessage = ErrorMessage(errorText: "Could not find survey")
                        return
                    }
                    do {
                        if survey.thaw()!.users.contains(app.currentUser!.id) {
                            self.errorMessage = ErrorMessage(errorText: "You've already joined this survey!")
                        } else {
                            try realm.write {
                                survey.thaw()!.users.append(app.currentUser!.id)
                                isPresentingJoinSurveyView = false
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
            }
        }
        .navigationBarTitle("Join Existing Survey")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    isPresentingJoinSurveyView = false
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
    }
}
