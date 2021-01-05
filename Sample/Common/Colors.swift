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

class SharedCustomizationImp: SharedCustomizationProtocol {
    func regularFont(size: CGFloat) -> UIFont {
        UIFont.systemFont(ofSize: size)
    }

    func semiBoldFont(size: CGFloat) -> UIFont {
        UIFont.boldSystemFont(ofSize: size)
    }

    func boldFont(size: CGFloat) -> UIFont {
        UIFont.boldSystemFont(ofSize: size)
    }

    var fontSizeSmall: CGFloat = dp(10)
    var fontSizeMedium: CGFloat = dp(12)
    var fontSizeLarge: CGFloat = dp(14)
    var fontSizeXLarge: CGFloat = dp(16)

    var kernSmall: CGFloat = dp(0.5)
    var kernLarge: CGFloat = dp(1)
    var kernXLarge: CGFloat = dp(1.5)

    var lineSpacingSmall: CGFloat = dp(1)
    var defaultTextWhite: UIColor {
        .defaultTextColor
    }
    var defaultTextBlack: UIColor {
        .defaultTextColor
    }
    var defaultBackgroundWhite: UIColor {
        .defaultBackgroundColor
    }
    var defaultCellBackgroundSelected: UIColor {
        .defaultBackgroundColor
    }
}
