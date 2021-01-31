import UIKit
import oneHookLibrary

extension UIColor {

    private static var isDarkMode: Bool {
        if #available(iOS 12.0, *) {
            let delegate = UIApplication.shared.delegate as? AppDelegate
            return delegate?.window?.traitCollection.userInterfaceStyle == .dark
        } else {
            return false
        }
    }

    static var defaultToolbarBackground: UIColor {
        if isDarkMode {
            return UIColor(white: 0, alpha: 0.9)
        } else {
            return UIColor(hex: "F2F2F2")
        }
    }

    static var defaultTextColor: UIColor {
        if isDarkMode {
            return .white
        } else {
            return .black
        }
    }

    static var defaultBackgroundColor: UIColor {
        if isDarkMode {
            return .black
        } else {
            return .white
        }
    }
}
