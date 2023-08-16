//
//  MainView.swift
//  App
//
//  Created by David Freifeld on 8/15/23.
//

import SwiftUI
import RealmSwift

enum Tab: Int {
    case openSurveys = 1
    case completedSurveys = 2
    var title: String {
        switch self {
        case .openSurveys:
            return "Open Surveys"
        case .completedSurveys:
            return "Completed Surveys"
        }
    }
}

struct MainView: View {
    var leadingBarButton: AnyView?
    
    @State var user: User
    @State var isInCreateSurveyView = false
    @State var isInJoinSurveyView = false
    @State var selectedTab = Tab.openSurveys
    
    var body: some View {
        NavigationView {
//            TabView(selection: $selectedTab) {
                OpenSurveyList()
                    .tabItem {
                        Label("Open Surveys", systemImage: "checklist.unchecked") //"rectangle.and.pencil.and.ellipsis"
                    }
                    .tag(Tab.openSurveys)
//                CompletedSurveyList()
//                    .tabItem {
//                        Label("Completed Surveys", systemImage: "checklist.checked")
//                    }
//                    .tag(Tab.completedSurveys)
//            }
            .navigationBarTitle(selectedTab.title/*, displayMode: .inline*/)
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
        }
    }
}
