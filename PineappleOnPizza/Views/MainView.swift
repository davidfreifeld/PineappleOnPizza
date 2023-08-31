//
//  MainView.swift
//  App
//
//  Created by David Freifeld on 8/15/23.
//

import SwiftUI
import RealmSwift

struct MainView: View {
    var leadingBarButton: AnyView?
    
    @ObservedResults(Survey.self) var surveys
    @EnvironmentObject var errorHandler: ErrorHandler
    
    @State var user: User
    @State var isPresentingAddSurveyView = false
    
    var body: some View {
        NavigationView {
            SurveyList()
            .navigationBarTitle("Surveys"/*, displayMode: .inline*/)
            .navigationBarItems(leading: self.leadingBarButton,
                                trailing: HStack {
                Button {
                    isPresentingAddSurveyView = true
                } label: {
                    Image(systemName: "plus")
                }
            })
            .sheet(isPresented: $isPresentingAddSurveyView) {
                NavigationView {
                    AddSurveyView(isPresentingAddSurveyView: $isPresentingAddSurveyView, user: user)
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
        .preferredColorScheme(.light)
    }
}
