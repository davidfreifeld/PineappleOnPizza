import SwiftUI
import RealmSwift

/// Show a detail view of a Survey. User can edit the summary or mark the Survey complete.
struct SurveyDetailView: View {
    // This property wrapper observes the Survey object and
    // invalidates the view when the Survey object changes.
    @ObservedRealmObject var survey: Survey

    @State private var isPresentingTallyResponseView = false
    @State private var isPresentingSetPredictionView = false
    @State private var isPresentingViewPredictionView = false
    @State private var isPresentingOwnerActionsView = false
    
    @Environment(\.realm) var realm
    
    var body: some View {
        ZStack {
            List {
                SurveyQuestionSection(survey: survey)
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
                                .font(.subheadline)
                                .italic()
                                .foregroundColor(.gray)
                        }
                    }
                }
                
//                // Prediction Section
                if survey.userHasPrediction {
                    Section {
                        Button(action: {
                            isPresentingViewPredictionView = true
                        }) {
                            HStack {
                                Spacer()
                                Text("View My Prediction")
                                Spacer()
                            }
                        }
                    }
                }
                else {
                    Section {
                        Button(action: {
                            isPresentingSetPredictionView = true
                        }) {
                            HStack {
                                Spacer()
                                Text("Set Prediction")
                                Spacer()
                            }
                        }
                    }
                }
                
                if survey.status == Status.completed {
                    Text("My score: \(survey.getUserScore(user_id: app.currentUser!.id))")
                }
            }
            
            if survey.status == Status.open {
                TallyResponseButton(isPresentingTallyResponseView: $isPresentingTallyResponseView)
            }
        }
        .navigationBarTitle("Survey")
        .navigationBarItems(trailing:
            Button {
                isPresentingOwnerActionsView = true
            } label: {
                Image(systemName: "gearshape")
            }
            .disabled(survey.owner_id != app.currentUser?.id)
        )
        .sheet(isPresented: $isPresentingTallyResponseView) {
            NavigationView {
                TallyResponseView(survey: survey, isPresentingTallyResponseView: $isPresentingTallyResponseView)
            }
        }
        .sheet(isPresented: $isPresentingViewPredictionView) {
            NavigationView {
                ViewPredictionView(survey: survey, isPresentingViewPredictionView: $isPresentingViewPredictionView)
            }
        }
        .sheet(isPresented: $isPresentingSetPredictionView) {
            NavigationView {
                SetPredictionView(survey: survey, isPresentingSetPredictionView: $isPresentingSetPredictionView)
            }
        }
        .sheet(isPresented: $isPresentingOwnerActionsView) {
            NavigationView {
                OwnerActionsView(survey: survey, isPresentingOwnerActionsView: $isPresentingOwnerActionsView)
            }
        }
    }
}
