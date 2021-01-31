#if canImport(UIKit)
import UIKit

extension UIColor {
    public static var isDarkMode: Bool { Theme.current.isDarkMode }
    public static var ed_toolbarBackgroundColor: UIColor { Theme.current.toolbarBackground }
    public static var ed_toolbarTextColor: UIColor { Theme.current.toolbarTextColor }
    public static var ed_dividerColor: UIColor { Theme.current.dividerColor }
    public static var ed_placeholderTextColor: UIColor { Theme.current.placeholderTextColor }
    public static var ed_cellBackgroundColor: UIColor { Theme.current.cellBackgroundColor }
    public static var ed_cellBackgroundColorHighlight: UIColor { Theme.current.cellBackgroundColorHighlight }

}

#endif
