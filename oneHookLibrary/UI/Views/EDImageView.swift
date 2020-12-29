import UIKit

open class EDImageView: UIImageView {

    private var _layoutParams: LayoutParams = LayoutParams()
    override open var layoutParams: LayoutParams {
        _layoutParams
    }

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        if layoutSize == CGSize.zero {
            return super.sizeThatFits(size)
        }
        return CGSize(width: min(size.width, layoutSize.width),
                      height: min(size.height, layoutSize.height))
    }
}
