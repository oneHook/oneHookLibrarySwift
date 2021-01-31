#if canImport(UIKit)
import UIKit

public class Fonts {
    public static func regular(_ size: CGFloat) -> UIFont { Theme.current.regularFont(size: size) }
    public static func semiBold(_ size: CGFloat) -> UIFont{ Theme.current.semiBoldFont(size: size) }
    public static func bold(_ size: CGFloat) -> UIFont{ Theme.current.boldFont(size: size) }
    public static func xbold(_ size: CGFloat) -> UIFont{ Theme.current.xboldFont(size: size) }

    public static var fontSizeXSmall: CGFloat { Theme.current.fontSizeXSmall }
    public static var fontSizeSmall: CGFloat { Theme.current.fontSizeSmall }
    public static var fontSizeMedium: CGFloat { Theme.current.fontSizeMedium }
    public static var fontSizeLarge: CGFloat { Theme.current.fontSizeLarge }
    public static var fontSizeXLarge: CGFloat { Theme.current.fontSizeXLarge }

    public static var lineSpacingSmall: CGFloat { Theme.current.lineSpacingSmall }
    public static var lineSpacingMedium: CGFloat { Theme.current.lineSpacingSmall }
    public static var lineSpacingLarge: CGFloat  { Theme.current.lineSpacingSmall }

    public static var kernSmall: CGFloat { Theme.current.kernSmall }
    public static var kernMedium: CGFloat { Theme.current.kernSmall }
    public static var kernLarge: CGFloat { Theme.current.kernSmall }
    public static var kernXLarge: CGFloat { Theme.current.kernSmall }
}

#endif
