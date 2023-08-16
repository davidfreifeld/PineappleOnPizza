import SwiftUI
import RealmSwift

/// Show a detail view of a Survey. User can edit the summary or mark the Survey complete.
struct SurveyDetailView: View {
    // This property wrapper observes the Survey object and
    // invalidates the view when the Survey object changes.
    @ObservedRealmObject var survey: Survey

    @State private var isPresentingTallyResponseView = false
    @State private var isPresentingPredictionView = false
    
    @Environment(\.realm) var realm
    
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
                    if survey.status == Status.completed {
                        if survey.totalVotes > 0 {
                            ProgressView(value: Double(answer.currentVotes) / Double(survey.totalVotes)) {
                                HStack {
                                    Text(answer.answerText)
                                    Spacer()
                                    Text("\(Int((Double(answer.currentVotes) / Double(survey.totalVotes) * 100).rounded()))%")
                                }
                            }
                        } else {
                            HStack {
                                Text(answer.answerText)
                                Spacer()
                                Text("No votes")
                            }
                        }
                    } else {
                        Text(answer.answerText)
                    }
                }
            }
            Section("User Actions") {
                Button(action: {
                    isPresentingPredictionView = true
                }) {
                    HStack {
                        Spacer()
                        Text("Set Prediction")
                        Spacer()
                    }
                }
                .disabled(survey.status != Status.new || survey.answers.first!.predictions.contains(where: { $0.user_id == app.currentUser?.id }))
                Button(action: {
                    isPresentingTallyResponseView = true
                }) {
                    HStack {
                        Spacer()
                        Text("Tally Response")
                        Spacer()
                    }
                }
                .disabled(survey.status != Status.open)
            }
            Section("Owner Actions") {
                Button(action: {
                    let thawedSurvey = survey.thaw()
                    try! realm.write {
                        thawedSurvey!.status = Status.open
                    }
                }) {
                    HStack {
                        Spacer()
                        Text("Open Survey")
                        Spacer()
                    }
                }
                .disabled(survey.owner_id != app.currentUser?.id || survey.status != Status.new || !survey.areAllPredictionsIn())
                Button(action: {
                    let thawedSurvey = survey.thaw()
                    try! realm.write {
                        thawedSurvey!.status = Status.completed
                    }
                }) {
                    HStack {
                        Spacer()
                        Text("Complete Survey")
                        Spacer()
                    }
                }
                .disabled(survey.owner_id != app.currentUser?.id || survey.status != Status.open)
            }
        }
        .navigationBarTitle("Survey \(survey.code)"/*, displayMode: .inline*/)
        .sheet(isPresented: $isPresentingTallyResponseView) {
            NavigationView {
                TallyResponseView(survey: survey, isPresentingTallyResponseView: $isPresentingTallyResponseView)
            }
        }
        .sheet(isPresented: $isPresentingPredictionView) {
            NavigationView {
                PredictionView(survey: survey, userHasPrediction: survey.answers.first!.predictions.contains(where: { $0.user_id == app.currentUser?.id }), isPresentingPredictionView: $isPresentingPredictionView)
            }
        }
    }
}
