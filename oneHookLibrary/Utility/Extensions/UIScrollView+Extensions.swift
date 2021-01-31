import UIKit

extension UIScrollView {
    public func disableAutomaticInsetAdjustment() {
        contentInsetAdjustmentBehavior = .never
        if #available(iOS 13.0, *) {
            automaticallyAdjustsScrollIndicatorInsets = false
        }
    }

    public func enableAutomaticInsetAdjustment() {
        contentInsetAdjustmentBehavior = .automatic
        if #available(iOS 13.0, *) {
            automaticallyAdjustsScrollIndicatorInsets = true
        }
    }

    /// Sets the `contentInset` and copies it's `top` and `bottom` values to the `scrollIndicatorInsets`
    public var allInsets: UIEdgeInsets {
        get {
            Tracking.shared?.recordAppError("allInsets getter shoud not be used", makeAssertionFailure: false)
            return contentInset
        }
        set {
            contentInset = newValue
            scrollIndicatorInsets = UIEdgeInsets(
                top: newValue.top,
                left: scrollIndicatorInsets.left,
                bottom: newValue.bottom,
                right: scrollIndicatorInsets.right
            )
        }
    }
}
