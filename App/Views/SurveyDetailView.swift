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
    @State private var isPresentingFinalResultsView = false
    
    var body: some View {
        ZStack {
            VStack {
                List {
                    // The title / question
                    SurveyQuestionSection(survey: survey)
                    
                    // The answers
                    Section(header: Text("Answers")) {
                        ForEach(survey.answers) { answer in
                            // If completed, show the results
                            if survey.status == Status.completed {
                                if survey.totalVotes > 0 {
                                    ProgressView(value: Double(answer.currentVotes) / Double(survey.totalVotes)) {
                                        HStack {
                                            Text(answer.answerText)
                                            Spacer()
                                            Text("\(Int((Double(answer.currentVotes) / Double(survey.totalVotes) * 100).rounded()))%")
                                        }
                                    }
                                    // Show the user's prediction next to the results
                                    if survey.status == Status.completed {
                                        ProgressView(value: answer.getUserPrediction(user_id: app.currentUser!.id) / Double(100))
                                            .tint(.green)
                                    }
                                } else {
                                    HStack {
                                        Text(answer.answerText)
                                        Spacer()
                                        Text("No votes")
                                    }
                                }
                                // if not completed, just show the answer
                            } else {
                                Text(answer.answerText)
                                    .font(.subheadline)
                                    .italic()
//                                    .foregroundColor(.gray)
                                    .listRowBackground(Color("ListItemColor"))
                            }
                        }
                    }
                    
                    // Prediction button Section
                    if survey.status != Status.completed {
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
                                .frame(width: 150, height: 50)
                                .background(Color("CompletedSurveyColor"))
                                .foregroundColor(.white)
                                .clipShape(Capsule())
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
                    } else {
                        Section {
                            Text("My error score: \(Utils.formatNumber(value: survey.getUserFinalScore(user_id: app.currentUser!.id)))")
                                .foregroundColor(.green)
                        }
                        Section {
                            Button(action: {
                                isPresentingFinalResultsView = true
                            }) {
                                HStack {
                                    Spacer()
                                    Text("View Final Results")
                                    Spacer()
                                }
                            }
                        }
                    }
                }
            } // List
            .scrollContentBackground(.hidden)
            .background(Color("MainBackgroundColor"))
            
            VStack {
                Spacer()
                Image("pineapple-with-sign-alpha")
                    .resizable()
                    .frame(width: 150, height: 150)
            }
//            Text(survey.statusString)
//                .frame(maxWidth: 300, alignment: .center)
            
            // a floating button for tallying responses, only if it's an Open survey
            if survey.status == Status.open {
                TallyResponseButton(isPresentingTallyResponseView: $isPresentingTallyResponseView)
            }
        } // ZStack
        
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
        .sheet(isPresented: $isPresentingFinalResultsView) {
            NavigationView {
                FinalResultsView(survey: survey, isPresentingFinalResultsView: $isPresentingFinalResultsView)
            }
        }
    }
}
