import SwiftUI
import RealmSwift

/// Show a detail view of a Survey. User can edit the summary or mark the Survey complete.
struct NotCompletedSurveyDetailView: View {
    // This property wrapper observes the Survey object and
    // invalidates the view when the Survey object changes.
    @ObservedRealmObject var survey: Survey

    @State private var isPresentingTallyResponseView: Bool = false
    @State private var isPresentingSetPredictionView: Bool = false
    @State private var isPresentingViewPredictionView: Bool = false
    
    var body: some View {
        VStack {
            
            SurveyQuestionInfoView(survey: survey)
            
            // ATTEMPT 2
//            HStack {
//                Text("\(survey.status.name)")
//                    .background(survey.status.rowColor)
//                    .padding(2)
//                    .clipShape(Capsule())
//                Text("Survey Code: \(survey.code)")
//            }
//            .padding(15)
//
//            RoundedRectangle(cornerRadius: 16)
//                .foregroundColor(Color("ListItemColor"))
//                .frame(width: 350, height: 400)
//                .overlay(
//                    VStack(alignment: .leading) {
//                        Label(survey.questionText, systemImage: "questionmark.bubble.fill")
//                        ScrollView(.vertical, showsIndicators: true) {
//                            VStack(alignment: .leading, spacing: 10) {
//                                ForEach(survey.answers) { answer in
//                                    Text("•\t\(answer.answerText)")
//                                        .frame(maxWidth: .infinity, alignment: .leading)
//                                } // ForEach
//                            } // VStack
//                        } // ScrollView
//                        .frame(maxHeight: 100)
//                        .padding(.leading, 30)
//                    } // VStack
//                        .padding(.leading, 20)
////                        .padding(.trailing, 5)
//                ) // overlay
            
            // ATTEMPT 1
//            GroupBox(label: Label(survey.questionText, systemImage: "questionmark.bubble.fill")
//            ) {
//                ScrollView(.vertical, showsIndicators: true) {
//                    VStack(alignment: .leading, spacing: 10) {
//                        ForEach(survey.answers) { answer in
//                            Text("•\t\(answer.answerText)")
//                                .frame(maxWidth: .infinity,
//                                       alignment: .leading)
//                        } // ForEach
//                    } // VStack
//                    .padding(2)
//                } // ScrollView
//                .frame(height: 50)
//            } // GroupBox
//            .padding(20)
//            .background(Color("ListRowColor"))
            
            Spacer()
            
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
        } // VStack
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("MainBackgroundColor"))
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
    }
}

struct NotCompletedSurveyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NotCompletedSurveyDetailView(survey: Survey.pineapple_open)
        }
    }
}
