//
//  AddSurveyView.swift
//  PineappleOnPizza
//
//  Created by David Freifeld on 8/24/23.
//

import SwiftUI
import RealmSwift

struct AddSurveyView: View {
    @Binding var isPresentingAddSurveyView: Bool
    @State var user: User
    
    var body: some View {
        VStack(spacing: 20) {
            NavigationLink {
                CreateSurveyView(isPresentingAddSurveyView: $isPresentingAddSurveyView, user: user)
            } label: {
                Text("Create New Survey")
            }
                .frame(width: 250, height: 75)
                .background(Color("CompletedSurveyColor"))
                .foregroundColor(.white)
                .clipShape(Capsule())
            
            NavigationLink {
                JoinSurveyView(isPresentingAddSurveyView: $isPresentingAddSurveyView)
            } label: {
                Text("Join Existing Survey")
            }
                .frame(width: 250, height: 75)
                .background(Color("CompletedSurveyColor"))
                .foregroundColor(.white)
                .clipShape(Capsule())
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    isPresentingAddSurveyView = false
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("MainBackgroundColor"))
        .navigationTitle("Add Survey")
    }
}
