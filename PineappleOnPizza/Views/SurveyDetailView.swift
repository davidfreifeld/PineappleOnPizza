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
    @State private var showHelpMessage = false
    
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
                                    .tint(.black)
                                    .listRowBackground(Color("ListItemColor"))
                                    // Show the user's prediction next to the results
                                    if survey.status == Status.completed {
                                        ProgressView(value: answer.getUserPrediction(user_id: app.currentUser!.id) / Double(100))
                                            .listRowBackground(Color("ListItemColor"))
                                    }
                                } else {
                                    HStack {
                                        Text(answer.answerText)
                                        Spacer()
                                        Text("No votes")
                                    }
                                    .listRowBackground(Color("ListItemColor"))
                                }
                                // if not completed, just show the answer
                            } else {
                                Text(answer.answerText)
                                    .font(.subheadline)
                                    .italic()
                                    .listRowBackground(Color("ListItemColor"))
                            }
                        }
                    }
                }
                .frame(maxHeight: 500)
                
                if survey.status == Status.open {
                    Button(action: {
                        isPresentingTallyResponseView = true
                    }) {
                        HStack {
                            Spacer()
                            Text("Tally Response")
                            Spacer()
                        }
                    }
                    .frame(width: 250, height: 50)
                    .background(Color("CompletedSurveyColor"))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .padding(.bottom, 20)
                }
                
                // Prediction button Section
                if survey.status != Status.completed {
                    if survey.userHasPrediction {
                        Button(action: {
                            isPresentingViewPredictionView = true
                        }) {
                            HStack {
                                Spacer()
                                Text("View My Prediction")
                                Spacer()
                            }
                        }
                        .frame(width: 200, height: 40)
                        .background(.gray)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .padding(.bottom, 20)
                    }
                    else {
                        Button(action: {
                            isPresentingSetPredictionView = true
                        }) {
                            HStack {
                                Spacer()
                                Text("Set Prediction")
                                Spacer()
                            }
                        }
                        .frame(width: 250, height: 50)
                        .background(Color("CompletedSurveyColor"))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .padding(.bottom, 20)
                    }
                } else {
                    Button(action: {
                        isPresentingFinalResultsView = true
                    }) {
                        HStack {
                            Spacer()
                            Text("View Final Results")
                            Spacer()
                        }
                    }
                    .frame(width: 250, height: 50)
                    .background(Color("CompletedSurveyColor"))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .padding(.bottom, 20)
                }
                
                Spacer()
                if survey.status == Status.completed {
                    Image("pineapple-thumbs-up-alpha")
                        .resizable()
                        .frame(width: 120, height: 150)
                }
            } // VStack
            .scrollContentBackground(.hidden)
            .background(Color("MainBackgroundColor"))
            
            if showHelpMessage {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(Color(UIColor.lightGray))
                    .frame(width: 250, height: 150, alignment: .bottom)
                    .overlay(
                        VStack {
                            Text(survey.statusString).font(.body)
                        }
                        .padding()
                        .multilineTextAlignment(.center)
                    )
            }
            
        }
        
        .navigationBarTitle("Survey")
        .navigationBarItems(trailing: HStack {
            Button {
                showHelpMessage = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.showHelpMessage = false
                }
            } label: {
                Image(systemName: "questionmark.circle")
            }
            Button {
                isPresentingOwnerActionsView = true
            } label: {
                Image(systemName: "gearshape.fill")
            }
            .disabled(survey.owner_id != app.currentUser?.id)
        })
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
