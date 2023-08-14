import SwiftUI
import RealmSwift

struct SurveyRow: View {
    @ObservedRealmObject var survey: Survey
    
    var body: some View {
        NavigationLink(destination: SurveyDetailView(survey: survey)) {
            Text(survey.questionText)
            Spacer()
            if survey.isComplete {
                Image(systemName: "checkmark")
                    .foregroundColor(.blue)
                    .padding(.trailing, 10)
            }
            if survey.owner_id == app.currentUser?.id {
                Text("(mine)")
            }
        }
    }
}
