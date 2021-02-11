import UIKit

open class EDTextField: UITextField {

    private var _layoutParams: LayoutParams = LayoutParams()
    override open var layoutParams: LayoutParams {
        _layoutParams
    }

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        if layoutSize == CGSize.zero {
            let superSize = super.sizeThatFits(CGSize(width: size.width - paddingStart - paddingEnd,
                                                      height: size.height - paddingTop - paddingBottom))
            /* That strange + 1 pixel is a workaround of iOS UILabel measuring bug */
            return CGSize(width: superSize.width + paddingStart + paddingEnd,
                          height: superSize.height + paddingTop + paddingBottom + 1)
        }
        return layoutSize
    }

    open override func sizeToFit() {
        bounds = CGRect(origin: .zero, size: sizeThatFits(CGSize.max))
    }

    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(
            x: bounds.origin.x + paddingStart,
            y: bounds.origin.y + paddingTop,
            width: bounds.size.width - paddingStart - paddingEnd,
            height: bounds.size.height - paddingTop - paddingBottom
        )
    }

    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        textRect(forBounds: bounds)
    }
}
