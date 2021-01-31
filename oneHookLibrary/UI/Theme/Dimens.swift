#if canImport(UIKit)
import UIKit

public func dp(_ value: CGFloat) -> CGFloat {
    return Theme.current.dp(value)
}

public class Dimens {
    public static var marginXSmall: CGFloat { Theme.current.marginXSmall }
    public static var marginSmall: CGFloat { Theme.current.marginSmall }
    public static var marginMedium: CGFloat { Theme.current.marginMedium }
    public static var marginLarge: CGFloat { Theme.current.marginLarge }
    public static var marginXLarge: CGFloat { Theme.current.marginXLarge }
    public static var marginXXLarge: CGFloat { Theme.current.marginXXLarge }
    public static var marginXXXLarge: CGFloat { Theme.current.marginXXXLarge }
    public static var standardCornerRadius: CGFloat { Theme.current.standardCornerRadius }

    public static var toolbarHeightDefaultFixed: CGFloat { Theme.current.toolbarHeightDefaultFixed }
    public static var navigationButtonHeight: CGFloat { Theme.current.navigationButtonHeight }
}

#endif
