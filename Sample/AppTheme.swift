import oneHookLibrary
import UIKit

class AppTheme: DefaultTheme {

    override var isDarkMode: Bool {
        get {
            if #available(iOS 12.0, *) {
                let window = (UIApplication.shared.delegate as? AppDelegate)?.window
                return window?.traitCollection.userInterfaceStyle == .dark
            } else {
                return false
            }
        }
        set {
        }
    }

    override var toolbarBackground: UIColor {
        get {
            if isDarkMode {
                return .black
            } else {
                return .white
            }
        }
        set {}
    }

    override var toolbarTextColor: UIColor {
        get {
            if isDarkMode {
                return .white
            } else {
                return .black
            }
        }
        set {}
    }

    override var dividerColor: UIColor {
        get {
            if isDarkMode {
                return .white
            } else {
                return UIColor(hex: "E3ECF2")
            }
        }
        set {}
    }

    override var placeholderTextColor: UIColor {
        get {
            if isDarkMode {
                return .white
            } else {
                return .black
            }
        }
        set {}
    }

    override var cellBackgroundColor: UIColor {
        get {
            if isDarkMode {
                return .black
            } else {
                return .white
            }
        }
        set {}
    }

    override var cellBackgroundColorHighlight: UIColor {
        get {
            if isDarkMode {
                return .black
            } else {
                return .white
            }
        }
        set {}
    }
}
