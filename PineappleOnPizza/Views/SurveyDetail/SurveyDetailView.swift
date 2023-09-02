import SwiftUI
import RealmSwift

/// Show a detail view of a Survey. User can edit the summary or mark the Survey complete.
struct SurveyDetailView: View {
    // This property wrapper observes the Survey object and
    // invalidates the view when the Survey object changes.
    @ObservedRealmObject var survey: Survey

    @State private var isPresentingOwnerActionsView = false
    @State private var showHelpMessage = false
    
    var body: some View {
        ZStack {
            // The main part of the view
            if survey.status == Status.completed {
                CompletedSurveyDetailView(survey: survey)
            } else {
                NotCompletedSurveyDetailView(survey: survey)
            }
            
            // A pop-up help message
            if showHelpMessage {
                PineappleMessageView(message: survey.statusString)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("MainBackgroundColor"))
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
                Image(systemName: "gearshape")
            }
            .disabled(survey.owner_id != app.currentUser?.id)
        })
        .sheet(isPresented: $isPresentingOwnerActionsView) {
            NavigationView {
                OwnerActionsView(survey: survey, isPresentingOwnerActionsView: $isPresentingOwnerActionsView)
            }
        }
    }
}

struct SurveyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SurveyDetailView(survey: Survey.pineapple_open)
        }
    }
}
