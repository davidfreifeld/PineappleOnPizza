//
//  QuestionGroupBoxView.swift
//  PineappleOnPizza
//
//  Created by David Freifeld on 8/31/23.
//

import SwiftUI
import RealmSwift

struct SurveyQuestionInfoView: View {
    
    @ObservedRealmObject var survey: Survey
    
    var body: some View {
        VStack {
            // The status and survey code
            HStack {
                Text("\(survey.status.name)")
                    .background(survey.status.rowColor)
                    .padding(2)
                    .clipShape(Capsule())
                Text("Survey Code: \(survey.code)")
                    .font(.callout)
            }
            .padding(EdgeInsets(top: 10, leading: 0, bottom: 5, trailing: 0))
            
            // The survey question and answers
            VStack(alignment: .leading) {
                Label(survey.questionText, systemImage: "questionmark.bubble.fill")
                    .font(.headline)
                    .padding(.bottom, 10)
                ForEach(survey.answers) { answer in
                    Text("•\t\(answer.answerText)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 2)
                } // ForEach
                .padding(.leading, 30)
            }
            .padding(20) // for inside the rounded rectangle
            .background(Color("ListItemColor"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)) // for outside the rounded rectangle
        }
    }
}

struct QuestionGroupBoxView_Previews: PreviewProvider {
    static var previews: some View {
        SurveyQuestionInfoView(survey: Survey.pineapple_open)
    }
}
