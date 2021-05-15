#if canImport(UIKit)
import UIKit

open class DefaultTheme: ThemeProtocol {

    /* Fonts */

    open var fontSizeXSmall: CGFloat = 8.2
    open var fontSizeSmall: CGFloat = 11
    open var fontSizeMedium: CGFloat = 14
    open var fontSizeLarge: CGFloat = 16
    open var fontSizeXLarge: CGFloat = 24
    open var kernSmall: CGFloat = 0.4
    open var kernMedium: CGFloat = 0.92
    open var kernLarge: CGFloat = 1
    open var kernXLarge: CGFloat = 1.5
    open var lineSpacingSmall: CGFloat = 4
    open var lineSpacingMedium: CGFloat = 5
    open var lineSpacingLarge: CGFloat = 6

    open var fontRegular = "AppleSDGothicNeo-Regular"
    open var fontSemiBold = "AppleSDGothicNeo-SemiBold"
    open var fontBold = "AppleSDGothicNeo-Medium"
    open var fontExtraBold = "AppleSDGothicNeo-Bold"

    open func regularFont(size: CGFloat) -> UIFont {
        UIFont(name: fontRegular, size: size)!
    }
    open func semiBoldFont(size: CGFloat) -> UIFont {
        UIFont(name: fontSemiBold, size: size)!
    }
    open func boldFont(size: CGFloat) -> UIFont {
        UIFont(name: fontBold, size: size)!
    }
    open func xboldFont(size: CGFloat) -> UIFont {
        UIFont(name: fontExtraBold, size: size)!
    }

    /* Dimensions */

    open var marginXSmall: CGFloat = 4
    open var marginSmall: CGFloat = 5
    open var marginMedium: CGFloat = 15
    open var marginLarge: CGFloat = 24
    open var marginXLarge: CGFloat = 36
    open var marginXXLarge: CGFloat = 64
    open var marginXXXLarge: CGFloat = 96

    open var standardCornerRadius: CGFloat = 8
    open var navigationButtonHeight: CGFloat = 34
    open var toolbarHeightDefaultFixed: CGFloat = 54

    open func dp(_ value: CGFloat) -> CGFloat {
        value
    }

    /* Colors */

    open var toolbarBackground: UIColor = UIColor.dynamic(light: .white, dark: .black)
    open var toolbarTextColor: UIColor = UIColor.dynamic(light: .black, dark: .white)
    open var dividerColor: UIColor = UIColor.dynamic(light: UIColor(hex: "E3ECF2"), dark: UIColor(hex: "1B1314"))
    open var placeholderTextColor: UIColor = UIColor.dynamic(light: .black, dark: .white)
    open var cellBackgroundColor: UIColor = UIColor.dynamic(light: .white, dark: .black)
    open var cellBackgroundColorHighlight: UIColor = UIColor.dynamic(light: UIColor(hex: "F2F2F2"), dark: UIColor(hex: "141414"))

    open func applyDpScaling() {
        let keyPaths: [ReferenceWritableKeyPath<DefaultTheme, CGFloat>] = [
            \.marginXSmall,
            \.marginSmall,
            \.marginMedium,
            \.marginLarge,
            \.marginXLarge,
            \.marginXXLarge,
            \.marginXXXLarge,
            \.standardCornerRadius,
            \.toolbarHeightDefaultFixed,
            \.navigationButtonHeight,
            \.fontSizeXSmall,
            \.fontSizeSmall,
            \.fontSizeMedium,
            \.fontSizeLarge,
            \.fontSizeXLarge,
            \.lineSpacingSmall,
            \.lineSpacingMedium,
            \.lineSpacingLarge
        ]

        keyPaths.forEach {
            self[keyPath: $0] = dp(self[keyPath: $0])
        }
    }

    public init() {
        applyDpScaling()
    }
}

#endif
