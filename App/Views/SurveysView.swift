import SwiftUI
import RealmSwift

/// Use views to see a list of all Surveys, add or delete Surveys, or logout.
struct SurveysView: View {
    var leadingBarButton: AnyView?
    // ObservedResults is a mutable collection; here it's
    // all of the Survey objects in the realm.
    // You can append or delete surveys directly from the collection.
    @ObservedResults(Survey.self) var surveys
    @EnvironmentObject var errorHandler: ErrorHandler

    @State var questionText = ""
    @State var user: User
    @State var isInCreateSurveyView = false
    @Binding var showMySurveys: Bool

    var body: some View {
        NavigationView {
            VStack {
                if isInCreateSurveyView {
                    CreateSurveyView(isInCreateSurveyView: $isInCreateSurveyView, user: user)
                }
                else {
                    Toggle("Show Only My Surveys", isOn: $showMySurveys).padding()
                    SurveyList()
                }
                NavigationLink(destination: JoinSurveyView()) {
                    HStack {
                        Spacer()
                        Text("Join Existing Survey")
                        Spacer()
                    }
                }
            }
            .navigationBarItems(leading: self.leadingBarButton,
                                trailing: HStack {
                Button {
                    isInCreateSurveyView = true
                } label: {
                    Image(systemName: "plus")
                }
            })
        }
    }
}
