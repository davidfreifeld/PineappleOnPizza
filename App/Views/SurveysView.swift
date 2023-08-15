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
    @State var isInJoinSurveyView = false
//    @Binding var showMySurveys: Bool

    var body: some View {
        NavigationView {
            VStack {
                if isInCreateSurveyView {
                    CreateSurveyView(isInCreateSurveyView: $isInCreateSurveyView, user: user)
                } else if isInJoinSurveyView {
                    JoinSurveyView(isInJoinSurveyView: $isInJoinSurveyView)
                }
                else {
//                    Toggle("Show Only My Surveys", isOn: $showMySurveys).padding()
                    SurveyList()
                }
            }
            .navigationBarItems(leading: self.leadingBarButton,
                                trailing: HStack {
                Button {
                    isInJoinSurveyView = true
                } label: {
                    Image(systemName: "person.fill.badge.plus")
                }
                Button {
                    isInCreateSurveyView = true
                } label: {
                    Image(systemName: "plus")
                }
            })
        }
    }
}
