import SwiftUI
import RealmSwift

/// Show a detail view of a Survey. User can edit the summary or mark the Survey complete.
struct SurveyDetailView: View {
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
                    if survey.isComplete {
                        ProgressView(value: Double(answer.currentVotes) / Double(survey.totalVotes)) {
                            HStack {
                                Text(answer.answerText)
                                Spacer()
                                if survey.totalVotes > 0 {
                                    Text("\(Int((Double(answer.currentVotes) / Double(survey.totalVotes) * 100).rounded()))%")
                                } else {
                                    Text("No votes")
                                }
                            }
                        }
                    } else {
                        Text(answer.answerText)
                    }
                }
            }
            Button(action: {

            }) {
                HStack {
                    Spacer()
                    Text("Set Prediction")
                    Spacer()
                }
            }
                .disabled(survey.answers.first!.predictions.contains(where: { $0.user_id == app.currentUser?.id }))
            Button(action: {

            }) {
                HStack {
                    Spacer()
                    Text("View Prediction")
                    Spacer()
                }
            }
            .disabled(!survey.answers.first!.predictions.contains(where: { $0.user_id == app.currentUser?.id }))
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
                .disabled(survey.isComplete)
            }
            Section {
                Toggle(isOn: $survey.isComplete) {
                    Text("Complete")
                }
                .disabled(survey.owner_id != app.currentUser?.id)
            }
        }
        .navigationBarTitle("Survey", displayMode: .inline)
        .sheet(isPresented: $isPresentingTallyResponseView) {
            NavigationView {
                TallyResponseView(survey: survey, isPresentingTallyResponseView: $isPresentingTallyResponseView)
            }
        }
    }
}
