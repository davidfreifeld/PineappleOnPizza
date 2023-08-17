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
        ZStack {
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
                Section("Actions") {
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
                }
                if survey.owner_id == app.currentUser?.id {
                    OwnerActionsView(survey: survey)
                }
            }
            if survey.status == Status.open {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            isPresentingTallyResponseView = true
                        }, label: {
                            Image(systemName: "checklist")
                            //                        Text("+")
                                .font(.system(size: 23))
                                .frame(width: 77, height: 70)
                                .foregroundColor(Color.white)
                            //                            .padding(.bottom, 7)
                                .background(Color.blue)
                        })
                        
                        //                    .cornerRadius(38.5)
                        .clipShape(Circle())
                        .padding()
                        .shadow(color: Color.black.opacity(0.3),
                                radius: 3,
                                x: 3,
                                y: 3)
                    }
                }
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
