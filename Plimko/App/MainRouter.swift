import UIKit

final class MainRouter {
    static let shared = MainRouter()
    private var window = UIWindow(frame: UIScreen.main.bounds)
    private let rootViewController: UINavigationController
    
    private init() {
       
        rootViewController = UINavigationController()
        rootViewController.isNavigationBarHidden = true
        self.window.rootViewController = rootViewController
        self.window.makeKeyAndVisible()
    }
    
    func showMenu() {
        let vc = MenuViewController()
        rootViewController.pushViewController(vc, animated: true)
    }
    
    func showMap() {
        rootViewController.pushViewController(SelectLevelViewController(), animated: true)
    }
    
    func pop(animated: Bool) {
        rootViewController.popViewController(animated: animated)
    }
    
    func popToRoot() {
        rootViewController.popToRootViewController(animated: true)
    }
    
    func popToMap() {
        rootViewController.viewControllers.forEach {
            if let vc = $0 as? SelectLevelViewController {
                rootViewController.popToViewController(vc, animated: true)
            }
        }
    }
    
    func showGame(level: Int) {
        rootViewController.pushViewController(GameViewController(level: level), animated: false)
    }
    
    func showResultScreen(isWin: Bool, id: Int, seconds: Int) {
        rootViewController.pushViewController(ResultViewController(isWin: isWin, id: id, seconds: seconds), animated: true)
    }
    
    func showGameWithPopPrevious(level: Int) {
        self.showGame(level: level)
        let count = rootViewController.viewControllers.count
        rootViewController.viewControllers.remove(at: count - 2)
    }
    
    func showPrivacy() {
        rootViewController.pushViewController(PrivacyPolicyViewController(), animated: true)
    }
    
    func dismiss() {
        rootViewController.dismiss(animated: true)
    }
    
    func showProfile() {
        rootViewController.pushViewController(ProfileViewController(), animated: false)
    }
    
    func showStat(id: Int) {
        rootViewController.pushViewController(StatisticsViewController(id: id), animated: true)
    }
    
    func showStore() {
        rootViewController.pushViewController(StoreViewController(), animated: false)
    }
    
    func showDetailLevelScreen(id: Int) {
        rootViewController.pushViewController(DetailLevelViewController(id: id), animated: true)
    }
    
    func showDetailAchievement(id: Int) {
        rootViewController.present(DetailAchievementViewController(id: id), animated: true)
    }
    
    func showTestResult() {
        rootViewController.pushViewController(TestResultViewController(), animated: true)
    }
}
