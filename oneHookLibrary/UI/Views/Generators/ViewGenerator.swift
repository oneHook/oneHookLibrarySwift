import UIKit

public class ViewGenerator {
    
    public static func divider() -> BaseView {
        BaseView().apply({ (divider) in
            divider.backgroundColor = .ed_dividerColor
            divider.layoutSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: dp(1))
        })
    }

    public static func toolbar() -> EDToolbar {
        EDToolbar().apply({ (toolbar) in
            toolbar.backgroundColor = .ed_toolbarBackgroundColor
        })
    }
}
