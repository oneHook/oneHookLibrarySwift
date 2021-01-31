#if canImport(UIKit)
import UIKit

public protocol ThemeProtocol {

    /* Dimens */

    func dp(_ value: CGFloat) -> CGFloat
    var marginXSmall: CGFloat { get }
    var marginSmall: CGFloat { get }
    var marginMedium: CGFloat { get }
    var marginLarge: CGFloat { get }
    var marginXLarge: CGFloat { get }
    var marginXXLarge: CGFloat { get }
    var marginXXXLarge: CGFloat { get }
    var standardCornerRadius: CGFloat { get }
    var toolbarHeightDefaultFixed: CGFloat { get }
    var navigationButtonHeight: CGFloat { get }

    /* Fonts */

    func regularFont(size: CGFloat) -> UIFont
    func semiBoldFont(size: CGFloat) -> UIFont
    func boldFont(size: CGFloat) -> UIFont
    func xboldFont(size: CGFloat) -> UIFont

    var fontSizeXSmall: CGFloat { get }
    var fontSizeSmall: CGFloat { get }
    var fontSizeMedium: CGFloat { get }
    var fontSizeLarge: CGFloat { get }
    var fontSizeXLarge: CGFloat { get }

    var kernSmall: CGFloat { get }
    var kernMedium: CGFloat { get }
    var kernLarge: CGFloat { get }
    var kernXLarge: CGFloat { get }

    var lineSpacingSmall: CGFloat { get }
    var lineSpacingMedium: CGFloat { get }
    var lineSpacingLarge: CGFloat { get }

    /* Colors */

    var isDarkMode: Bool { get }
    var toolbarBackground: UIColor { get }
    var toolbarTextColor: UIColor { get }
    var dividerColor: UIColor { get }
    var placeholderTextColor: UIColor { get }
    var cellBackgroundColor: UIColor { get }
    var cellBackgroundColorHighlight: UIColor { get }
}

public class Theme {
    public static var current: ThemeProtocol = DefaultTheme()
}

#endif
