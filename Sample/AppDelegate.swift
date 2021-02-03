import UIKit
import oneHookLibrary

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Theme.current = AppTheme()
        window = UIWindow(frame: UIScreen.main.bounds)
        let menuController = MenuViewController()
        let mainController = UINavigationController(rootViewController: menuController).apply {
            $0.navigationBar.isHidden = true
        }
        window?.rootViewController = mainController
        window?.makeKeyAndVisible()
        return true
    }
}

