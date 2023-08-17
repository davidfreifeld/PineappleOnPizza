import SwiftUI
import RealmSwift

struct SurveyRow: View {
    @ObservedRealmObject var survey: Survey
    
    var body: some View {
        NavigationLink(destination: SurveyDetailView(survey: survey)) {
            HStack {
                Text(survey.questionText)
                Spacer()
//                if survey.status == Status.completed {
//                    Image(systemName: "checkmark")
//                        .foregroundColor(.blue)
//                        .padding(.trailing, 10)
//                }
                if survey.owner_id == app.currentUser?.id {
                    Image(systemName: "person.badge.key.fill")
                        .foregroundColor(.blue)
//                        .padding(.trailing, 10)
                }
            }
        }
//        .listRowBackground(survey.status.rowColor)
    }
}
