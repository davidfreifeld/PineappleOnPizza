//
//  PineappleMessageView.swift
//  PineappleOnPizza
//
//  Created by David Freifeld on 8/25/23.
//

import SwiftUI

struct PineappleMessageView: View {
    @State var message: String
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .foregroundColor(Color(UIColor.lightGray))
            .frame(width: 350, height: 200, alignment: .bottom)
            .overlay(
                ZStack {
                    Image("pineapple-with-sign-long-alpha")
                        .resizable()
                        .frame(width: 325, height: 175)
                    Text(message)
                        .font(.caption)
                        .frame(maxWidth: 175, maxHeight: 100)
                        .padding(.leading, 120)
                        .padding(.top, 70)
                        
                }
                .padding()
                .multilineTextAlignment(.center)
            )
    }
}

struct PineappleMessageView_Previews: PreviewProvider {
    static var previews: some View {
        PineappleMessageView(message: "This is a new survey, still accepting user predictions. Once all the predictions are in, you can open it for voting!")
    }
}
