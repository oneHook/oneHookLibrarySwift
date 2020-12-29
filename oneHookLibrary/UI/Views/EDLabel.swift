import UIKit

open class EDLabel: UILabel {

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

    override open func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: paddingTop,
                                  left: paddingStart,
                                  bottom: paddingBottom,
                                  right: paddingEnd)
        super.drawText(in: rect.inset(by: insets))
    }
}

