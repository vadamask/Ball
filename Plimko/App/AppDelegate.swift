import UIKit

@main

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if !UserDefaults.standard.bool(forKey: "firstLaunch") {
            LevelsService.shared.initialize()
            SkinsService.shared.initialize()
            AchievementsService.shared.initialize()
            UserDefaults.standard.setValue(true, forKey: "firstLaunch")
        }
        
        MainRouter.shared.showMenu()
        return true
    }
}

