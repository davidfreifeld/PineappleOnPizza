import SwiftUI
import RealmSwift

struct ContentView: View {
    @ObservedObject var app: RealmSwift.App
    @EnvironmentObject var errorHandler: ErrorHandler

    var body: some View {
        if let user = app.currentUser {
            let config = user.flexibleSyncConfiguration(initialSubscriptions: { subs in
                if let _ = subs.first(named: Constants.allSurveys) {
                    // Existing subscription found - do nothing
                    return
                } else {
                    // No subscription - create it
                    subs.append(QuerySubscription<Survey>(name: Constants.allSurveys))
                }
            })
            OpenRealmView(user: user)
                // Store configuration in the environment to be opened in next view
                .environment(\.realmConfiguration, config)
        } else {
            // If there is no user logged in, show the login view.
            LoginView()
        }
    }
}
