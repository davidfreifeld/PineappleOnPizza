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
    @State var isInCreateSurveyView = false
    @State var isInJoinSurveyView = false
    
    var body: some View {
        NavigationView {
            SurveyList()
            .navigationBarTitle("Surveys"/*, displayMode: .inline*/)
            .navigationBarItems(leading: self.leadingBarButton,
                                trailing: HStack {
                Button {
                    isInJoinSurveyView = true
                } label: {
                    Image(systemName: "icloud.and.arrow.down") // "person.fill.badge.plus"
                }
                Button {
                    isInCreateSurveyView = true
                } label: {
                    Image(systemName: "plus")
                }
            })
            .sheet(isPresented: $isInJoinSurveyView) {
                NavigationView {
                    JoinSurveyView(isInJoinSurveyView: $isInJoinSurveyView)
                }
            }
            .sheet(isPresented: $isInCreateSurveyView) {
                NavigationView {
                    CreateSurveyView(isInCreateSurveyView: $isInCreateSurveyView, user: user)
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
}
