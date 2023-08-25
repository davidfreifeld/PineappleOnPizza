//
//  TallyResponseButton.swift
//  App
//
//  Created by David Freifeld on 8/17/23.
//

import SwiftUI

struct TallyResponseButton: View {
    
    @Binding var isPresentingTallyResponseView: Bool
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    isPresentingTallyResponseView = true
                }, label: {
                    Image(systemName: "checklist")
                        .font(.system(size: 23))
                        .frame(width: 77, height: 70)
                        .foregroundColor(Color.white)
//                                .padding(.bottom, 7)
                        .background(Color("CompletedSurveyColor"))
                })
                
                .clipShape(Circle())
                .padding()
                .shadow(color: Color.black.opacity(0.3),
                        radius: 3,
                        x: 3,
                        y: 3)
            }
        }
    }
}
