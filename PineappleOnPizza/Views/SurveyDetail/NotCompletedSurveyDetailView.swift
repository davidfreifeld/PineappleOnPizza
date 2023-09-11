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
            
            List {
                SurveyQuestionSection(survey: survey)
            }
            .scrollContentBackground(.hidden)
            .background(Color("MainBackgroundColor"))
            .frame(maxHeight: 150)
            
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
                    if true /* no error */ {
                        isPresentingViewPredictionView = true
                    } else {
                        
                    }
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
            Spacer()
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
