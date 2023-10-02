//
//  MainView.swift
//  App
//
//  Created by David Freifeld on 8/15/23.
//

import SwiftUI
import RealmSwift

struct MainView: View {
    @ObservedResults(Survey.self) var surveys
    @EnvironmentObject var errorHandler: ErrorHandler
    
    @State var user: User
    @State var isPresentingCreateSurveyView = false
    @State var isPresentingJoinSurveyView = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 20) {
                    Button(action: {
                        isPresentingCreateSurveyView = true
                    }) {
                        HStack {
                            Spacer()
                            Text("Create New\nSurvey")
                            Spacer()
                        }
                    }
                    .frame(width: 150, height: 50)
                    .background(Color("CompletedSurveyColor"))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    
                    Button(action: {
                        isPresentingJoinSurveyView = true
                    }) {
                        HStack {
                            Spacer()
                            Text("Join Existing\nSurvey")
                            Spacer()
                        }
                    }
                    .frame(width: 150, height: 50)
                    .background(Color("CompletedSurveyColor"))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                }
                SurveyList()
            }
            .scrollContentBackground(.hidden)
            .background(Color("MainBackgroundColor"))
            .navigationBarTitle("Surveys"/*, displayMode: .inline*/)
            .navigationBarItems(trailing: LogoutButton())
            .sheet(isPresented: $isPresentingCreateSurveyView) {
                NavigationView {
                    CreateSurveyView(isPresentingAddSurveyView: $isPresentingCreateSurveyView, user: user)
                }
            }
            .sheet(isPresented: $isPresentingJoinSurveyView) {
                NavigationView {
                    JoinSurveyView(isPresentingAddSurveyView: $isPresentingJoinSurveyView)
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
        .preferredColorScheme(.light)
    }
}
