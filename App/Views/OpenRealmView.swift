import SwiftUI
import RealmSwift

/// Called when login completes. Opens the realm and navigates to the Items screen.
struct OpenRealmView: View {
    @AutoOpen(appId: theAppConfig.appId, timeout: 2000) var autoOpen
    // We must pass the user, so we can set the user.id when we create Item objects
    @State var user: User
    @State var showMySurveys = true
    // Configuration used to open the realm.
    @Environment(\.realmConfiguration) private var config

    var body: some View {
        switch autoOpen {
        case .connecting:
            // Starting the Realm.autoOpen process.
            // Show a progress view.
            ProgressView()
        case .waitingForUser:
            // Waiting for a user to be logged in before executing
            // Realm.asyncOpen.
            ProgressView("Waiting for user to log in...")
        case .open(let realm):
            // The realm has been opened and is ready for use.
            // Show the Surveys view.
            SurveysView(leadingBarButton: AnyView(LogoutButton()), user: user, showMySurveys: $showMySurveys/*, isInOfflineMode: $isInOfflineMode*/)
                // showMySurveys toggles the creation of a subscription
                // When it's toggled on, only the original subscription is shown -- "my_surveys".
                // When it's toggled off, *all* surveys are downloaded to the
                // client, including from other users.
                .onChange(of: showMySurveys) { newValue in
                    let subs = realm.subscriptions
                    subs.update {
                        if newValue {
                            subs.remove(named: Constants.allSurveys)
                        } else {
                            if subs.first(named: Constants.allSurveys) == nil {
                                subs.append(QuerySubscription<Survey>(name: Constants.allSurveys))
                            }
                        }
                    }
                }
                .onAppear {
                    if let _ = realm.subscriptions.first(named: Constants.allSurveys) {
                        // The client was subscribed to all items from a previous
                        // session, so set UI toggle accordingly
                        showMySurveys = false
                    }
                }
                .environment(\.realm, realm)
        case .progress(let progress):
            // The realm is currently being downloaded from the server.
            // Show a progress view.
            ProgressView(progress)
        case .error(let error):
            // Opening the Realm failed.
            // Show an error view.
            ErrorView(error: error)
        }
    }
}
