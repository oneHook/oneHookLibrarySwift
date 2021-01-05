import UIKit

open class EDVisualEffectView: UIVisualEffectView {

    private var _layoutParams: LayoutParams = LayoutParams()
    override open var layoutParams: LayoutParams {
        return _layoutParams
    }

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        if layoutSize == CGSize.zero {
            return super.sizeThatFits(size)
        }
        return CGSize(width: min(size.width, layoutSize.width),
                      height: min(size.height, layoutSize.height))
    }
}
