import UIKit

public protocol SharedCustomizationProtocol {

    /* Fonts */

    func regularFont(size: CGFloat) -> UIFont
    func semiBoldFont(size: CGFloat) -> UIFont
    func boldFont(size: CGFloat) -> UIFont

    var fontSizeSmall: CGFloat { get }
    var fontSizeMedium: CGFloat { get }
    var fontSizeLarge: CGFloat { get }
    var fontSizeXLarge: CGFloat { get }
    var kernSmall: CGFloat { get }
    var kernLarge: CGFloat { get }
    var kernXLarge: CGFloat { get }
    var lineSpacingSmall: CGFloat { get }

    /* Colors */

    var defaultTextWhite: UIColor { get }
    var defaultTextBlack: UIColor { get }
    var defaultBackgroundWhite: UIColor { get }
    var defaultCellBackgroundSelected: UIColor { get }

//    var defaultTextColor: UIColor { get }
//    var defaultTextColorLight: UIColor { get }
//    var defaultTextBlack2: UIColor { get }
//    var defaultTextColorDark: UIColor { get }
//
//    var dividerColor: UIColor { get }
//    var defaultBarBackground: UIColor { get }
//
//    var primaryRed: UIColor { get }
//    var primaryGreen: UIColor { get }
//    var primaryBlue: UIColor { get }
//
//    var accentColor: UIColor { get }
//    var accentColor2: UIColor { get }
//
//    var colorActiveState: UIColor? { get }
//    var colorInactiveState: UIColor? { get }
//    var tutorialNextTipButtonColorNormal: UIColor? { get }
//    var tutorialNextTipButtonColorHighlight: UIColor? { get }
//
//    /* Controller */
//    var promptNoPhotoAccess: UIAlertController? { get }
}

public class SharedCustomization {
    public static var shared: SharedCustomizationProtocol?

    /* Fonts */

    static func regularFont(size: CGFloat) -> UIFont {
        shared?.regularFont(size: size) ?? UIFont.systemFont(ofSize: size)
    }

    static func semiBoldFont(size: CGFloat) -> UIFont {
        shared?.semiBoldFont(size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }

    static func boldFont(size: CGFloat) -> UIFont {
        shared?.boldFont(size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }

    static var fontSizeSmall: CGFloat {
        shared?.fontSizeSmall ?? dp(11)
    }

    static var fontSizeMedium: CGFloat {
        shared?.fontSizeMedium ?? dp(14)
    }

    static var fontSizeLarge: CGFloat {
        shared?.fontSizeLarge ?? dp(16)
    }

    static var fontSizeXLarge: CGFloat {
        shared?.fontSizeXLarge ?? dp(20)
    }

    static var kernSmall: CGFloat {
        shared?.kernSmall ?? 0.4
    }

    static var kernLarge: CGFloat {
        shared?.kernLarge ?? 1.0
    }

    static var kernXLarge: CGFloat {
        shared?.kernXLarge ?? 1.5
    }

    static var lineSpacingSmall: CGFloat {
        shared?.lineSpacingSmall ?? dp(4)
    }

    /* Colors */

    static var defaultTextWhite: UIColor {
        shared?.defaultTextWhite ?? .white
    }

    static var defaultTextBlack: UIColor {
        shared?.defaultTextBlack ?? .black
    }

    static var defaultBackgroundWhite: UIColor {
        shared?.defaultBackgroundWhite ?? .white
    }

    static var defaultCellBackgroundSelected: UIColor {
        shared?.defaultCellBackgroundSelected ?? UIColor(hex: "#F2F2F2")
    }
//
//    static var defaultTextColorLight: UIColor {
//        shared?.defaultTextColorLight ?? .lightGray
//    }
//
//    static var defaultTextColor: UIColor {
//        shared?.defaultTextColor ?? .black
//    }
//

//    static var defaultTextBlack2: UIColor {
//        shared?.defaultTextBlack2 ?? UIColor(hex: "314454")
//    }
//
//    static var defaultTextColorDark: UIColor {
//        shared?.defaultTextColorDark ?? UIColor.darkGray
//    }
//
//    static var dividerColor: UIColor {
//        shared?.dividerColor ?? UIColor(hex: "#E3ECF2")
//    }
//
//    static var defaultBarBackground: UIColor {
//        shared?.defaultBarBackground ?? UIColor.lightGray
//    }
//

//
//    static var primaryRed: UIColor {
//        shared?.primaryRed ?? UIColor.red
//    }
//
//    static var primaryGreen: UIColor {
//        shared?.primaryGreen ?? UIColor.green
//    }
//
//    static var primaryBlue: UIColor {
//        shared?.primaryBlue ?? UIColor.blue
//    }
//
//    static var accentColor: UIColor {
//        shared?.accentColor ?? SharedCustomization.primaryBlue
//    }
//
//    static var accentColor2: UIColor {
//        shared?.accentColor2 ?? SharedCustomization.primaryBlue.darker(by: 5)
//    }
//
//    static var colorActiveState: UIColor {
//        shared?.colorActiveState ?? UIColor(hex: "#88C057")
//    }
//
//    static var colorInactiveState: UIColor {
//        shared?.colorInactiveState ?? UIColor(hex: "#E6E7E8")
//    }
//
//    static var tutorialNextTipButtonColorNormal: UIColor {
//        shared?.tutorialNextTipButtonColorNormal ?? UIColor(hex: "#00BC99")
//    }
//
//    static var tutorialNextTipButtonColorHighlight: UIColor {
//        shared?.tutorialNextTipButtonColorHighlight ?? UIColor(hex: "#00BC99").darker(by: 5)
//    }
}
