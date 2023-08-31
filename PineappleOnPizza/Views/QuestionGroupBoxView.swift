//
//  QuestionGroupBoxView.swift
//  PineappleOnPizza
//
//  Created by David Freifeld on 8/31/23.
//

import SwiftUI

struct QuestionGroupBoxView: View {
    @State var questionText: String = "Do you like pineapple on pizza?"
    @State var answers: [String] = ["Yes", "No", "Maybe", "IDGAF"]
    var body: some View {
        GroupBox(label:
            Label(questionText, systemImage: "questionmark.bubble.fill")
        ) {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(answers, id: \.self) { answer in
                        Text("•\t\(answer)")
                            .frame(maxWidth: .infinity,
                                   alignment: .leading)
                    }
                }
                .padding(2)
            }
            .frame(height: 50)
        }
        .padding(20)
    }
}

struct QuestionGroupBoxView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionGroupBoxView()
    }
}
