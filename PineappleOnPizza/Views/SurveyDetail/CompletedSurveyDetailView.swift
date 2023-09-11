import SwiftUI
import RealmSwift

/// Show a detail view of a Survey. User can edit the summary or mark the Survey complete.
struct CompletedSurveyDetailView: View {
    // This property wrapper observes the Survey object and
    // invalidates the view when the Survey object changes.
    @ObservedRealmObject var survey: Survey

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
                                    ProgressView(value: answer.getUserPrediction(user_id: app.currentUser!.id))
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
                        } // ForEach
                        HStack {
                            Rectangle()
                                .frame(width: 15, height: 15)
                                .foregroundColor(.black)
                            Text("Survey result").font(.caption)
                            Spacer()
                            Rectangle()
                                .frame(width: 15, height: 15)
                                .foregroundColor(Color("CompletedSurveyColor"))
                            Text("My prediction").font(.caption)
                        }
                        .listRowBackground(Color("ListItemColor"))
                    } // Section "Answers"
                } // List
//                .frame(maxHeight: 500)
                
                
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
                
                Spacer()
                
                Image("pineapple-thumbs-up-alpha")
                    .resizable()
                    .frame(width: 120, height: 150)
            } // VStack
            .scrollContentBackground(.hidden)
            .background(Color("MainBackgroundColor"))
            
        }
        .sheet(isPresented: $isPresentingFinalResultsView) {
            NavigationView {
                FinalResultsView(survey: survey, isPresentingFinalResultsView: $isPresentingFinalResultsView)
            }
        }
    }
}
