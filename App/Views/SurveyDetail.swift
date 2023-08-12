import SwiftUI
import RealmSwift

/// Show a detail view of a Survey. User can edit the summary or mark the Survey complete.
struct SurveyDetail: View {
    // This property wrapper observes the Survey object and
    // invalidates the view when the Survey object changes.
    @ObservedRealmObject var survey: Survey

    @State private var isPresentingTallyResponseView = false
    
    var body: some View {
        List {
            // TODO: Edit Survey?
            Section(header: Text("Question")) {
                // Accessing the observed survey object lets us update the live object
                // No need to explicitly update the object in a write transaction
                Text(survey.questionText)
            }
            Section(header: Text("Answers")) {
                ForEach(survey.answers) { answer in
                    Text(answer.answerText)
                }
            }
            Section {
                Button(action: {
                    isPresentingTallyResponseView = true
                }) {
                    HStack {
                        Spacer()
                        Text("Tally Response")
                        Spacer()
                    }
                }
            }
            Section {
                Toggle(isOn: $survey.isComplete) {
                    Text("Complete")
                }
            }
        }
        .navigationBarTitle("Survey", displayMode: .inline)
        .sheet(isPresented: $isPresentingTallyResponseView) {
            if #available(iOS 16.0, *) {
                NavigationStack {
                    TallyResponseView(survey: survey, isPresentingTallyResponseView: $isPresentingTallyResponseView)
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
