import UIKit

open class EqualWeightLayout: BaseView {

    public var cellHeight: CGFloat = dp(85)
    public var showDivider: Bool = false
    public var spacing: CGFloat = 0
    public var dividerTopBottomPadding: CGFloat = dp(12)
    public var dividerWidth: CGFloat = dp(1)
    public var dividerColor: UIColor = .ed_dividerColor {
        didSet {
            for divider in dividers {
                divider.backgroundColor = self.dividerColor.cgColor
            }
        }
    }

    private var cellSpacing: CGFloat {
        2.0 * spacing + (showDivider ? dividerWidth : 0)
    }

    private var spaceCount: Int {
        max(0, subviews.count - 1)
    }

    private var dividerCount: Int {
        showDivider ? max(0, subviews.count - 1) : 0
    }

    private var dividers = [CALayer]()

    private var cellMaxWidth: CGFloat {
        guard subviews.count > 0 else {
            return bounds.width - paddingStart - paddingEnd
        }
        return (bounds.width - paddingStart - paddingEnd - CGFloat(spaceCount) * cellSpacing) / CGFloat(subviews.count)
    }

    private func makeDividerLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.backgroundColor = dividerColor.cgColor
        return layer
    }

    /* Calculate total number of dividers needed
     and make sure we have just the right number of dividers */
    private func makeOrRemoveDividers() {
        let dividerCount = self.dividerCount

        makeOrRemove(
            toTargetCount: dividerCount,
            from: dividers.count,
            make: {
                let divider = makeDividerLayer()
                dividers.append(divider)
                layer.addSublayer(divider)
        }, remove: {
            let layer = dividers.removeLast()
            layer.removeFromSuperlayer()
        })
    }

    override open func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        makeOrRemoveDividers()

        guard showDivider else {
            return
        }

        let dividerHeight = bounds.height - paddingTop - paddingBottom - dividerTopBottomPadding * 2
        var currX: CGFloat = paddingStart
        for divider in dividers {
            currX += cellMaxWidth + spacing
            divider.frame = CGRect(x: currX,
                                   y: paddingTop + dividerTopBottomPadding,
                                   width: dividerWidth,
                                   height: dividerHeight)
            currX += dividerWidth + spacing
        }
    }

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        CGSize(width: size.width, height: cellHeight)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        let cellMaxHeight = bounds.height - paddingTop - paddingBottom
        var currX: CGFloat = paddingStart
        let currY: CGFloat = paddingTop

        for view in subviews {
            view.frame = CGRect(x: currX + view.marginStart,
                                y: currY + view.marginTop,
                                width: cellMaxWidth - view.marginStart - view.marginEnd,
                                height: cellMaxHeight - view.marginTop - view.marginBottom)
            currX = view.frame.maxX + cellSpacing
        }
    }

    open override func invalidateAppearance() {
        let dividerColor = self.dividerColor
        self.dividerColor = dividerColor
    }
}
