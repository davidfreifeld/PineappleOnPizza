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
    @State var isPresentingCreateSurveyView = false
    @State var isPresentingJoinSurveyView = false
    
    var body: some View {
        NavigationView {
            SurveyList()
            .navigationBarTitle("Surveys"/*, displayMode: .inline*/)
            .navigationBarItems(leading: self.leadingBarButton,
                                trailing: HStack {
                Button {
                    isPresentingJoinSurveyView = true
                } label: {
                    Image(systemName: "icloud.and.arrow.down") // "person.fill.badge.plus"
                }
                Button {
                    isPresentingCreateSurveyView = true
                } label: {
                    Image(systemName: "plus")
                }
            })
            .sheet(isPresented: $isPresentingJoinSurveyView) {
                NavigationView {
                    JoinSurveyView(isPresentingJoinSurveyView: $isPresentingJoinSurveyView)
                }
            }
            .sheet(isPresented: $isPresentingCreateSurveyView) {
                NavigationView {
                    CreateSurveyView(isPresentingCreateSurveyView: $isPresentingCreateSurveyView, user: user)
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
}
