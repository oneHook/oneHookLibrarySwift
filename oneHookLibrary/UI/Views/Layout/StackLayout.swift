import UIKit

open class StackLayout: BaseView {

    public enum Orientation {
        case horizontal
        case vertical
    }

    public var orientation: Orientation = .horizontal

    public var spacing: CGFloat = 0
    public var contentGravity: Gravity = .start

    override open func commonInit() {
        super.commonInit()
    }

    private func measureChildren(_ size: CGSize) -> (childrenSizes: [CGSize], sizeThatFits: CGSize) {
        var childrenSizes: [CGSize] = []
        var realChildCount = 0
        for view in self.subviews {
            if view.isHidden || view.shouldSkip {
                childrenSizes.append(CGSize.zero)
            } else {
                realChildCount += 1
                let childSize = view.sizeThatFits(size)
                childrenSizes.append(
                    CGSize(width: childSize.width + view.marginStart + view.marginEnd,
                           height: childSize.height + view.marginTop + view.marginBottom)
                )
            }
        }
        var sizeThatFits = CGSize.zero
        if orientation == .horizontal {
            var widthTotal: CGFloat = 0
            var maxHeight: CGFloat = 0
            childrenSizes.forEach { (childSize) in
                widthTotal += childSize.width
                maxHeight = max(maxHeight, childSize.height)
            }
            sizeThatFits = CGSize(
                width: widthTotal + spacing * CGFloat(realChildCount - 1) + paddingStart + paddingEnd,
                height: maxHeight + paddingTop + paddingBottom
            )
        } else {
            var maxWidth: CGFloat = 0
            var totalHeight: CGFloat = 0
            childrenSizes.forEach { (childSize) in
                maxWidth = max(maxWidth, childSize.width)
                totalHeight += childSize.height
            }
            sizeThatFits = CGSize(width: maxWidth + paddingStart + paddingEnd,
                                  height: totalHeight + spacing * CGFloat(realChildCount - 1) + paddingTop + paddingEnd)
        }
        return (childrenSizes: childrenSizes, sizeThatFits: sizeThatFits)
    }

    open override func sizeToFit() {
        bounds = CGRect(origin: .zero, size: sizeThatFits(CGSize.max))
    }

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        if layoutParams.layoutSize != CGSize.zero {
            return layoutParams.layoutSize
        }
        let measured = measureChildren(
            CGSize(width: size.width - paddingStart - paddingEnd,
                   height: size.height - paddingTop - paddingBottom)
        )
        return measured.sizeThatFits
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        let width = bounds.size.width
        let height = bounds.size.height
        let measured = measureChildren(
            CGSize(width: width - paddingStart - paddingEnd,
                   height: height - paddingTop - paddingBottom)
        )
        let childrenSizes = measured.childrenSizes
        let sizeThatFits = measured.sizeThatFits

        var currX: CGFloat = paddingStart
        var currY: CGFloat = paddingTop

        if contentGravity.contains(.centerHorizontal) && orientation == .horizontal {
            currX = (width - sizeThatFits.width) / 2 + paddingStart
        }
        if contentGravity.contains(.centerVertical) && orientation == .vertical {
            currY = (height - sizeThatFits.height) / 2 + paddingTop
        }
        if contentGravity.contains(.end) && orientation == .horizontal {
            currX = width - sizeThatFits.width + paddingStart
        }
        if contentGravity.contains(.bottom) && orientation == .vertical {
            currY = height - sizeThatFits.height + paddingTop
        }

        zip(subviews, childrenSizes).forEach { (view, childSize) in
            if view.isHidden || view.shouldSkip {
                return
            }
            var viewX = currX + view.marginStart
            var viewY = currY + view.marginTop
            var viewWidth = min(max(0, childSize.width - view.marginStart - view.marginEnd), width - viewX)
            var viewHeight = min(max(0, childSize.height - view.marginTop - view.marginBottom), height - viewY)

            if orientation == .horizontal {
                if view.layoutGravity.contains(.fillVertical) {
                    viewHeight = height - view.marginTop - view.marginBottom - paddingTop - paddingBottom
                }
                if view.layoutGravity.contains(.centerVertical) {
                    viewY = (height - paddingTop - paddingBottom - childSize.height + view.marginTop + view.marginBottom) / 2 + paddingTop
                } else if view.layoutGravity.contains(.bottom) {
                    viewY = height - (childSize.height - view.marginTop) - paddingBottom
                }
            } else {
                if view.layoutGravity.contains(.fillHorizontal) {
                    viewWidth = width - view.marginStart - view.marginEnd - paddingStart - paddingEnd
                }
                if view.layoutGravity.contains(.centerHorizontal) {
                    viewX = (width - paddingStart - paddingEnd - childSize.width + view.marginStart + view.marginEnd) / 2 + paddingStart
                } else if view.layoutGravity.contains(.end) {
                    viewX = width - (childSize.width - view.marginStart) - paddingEnd
                }
            }
            view.frame = CGRect(x: viewX,
                                y: viewY,
                                width: viewWidth,
                                height: viewHeight)
            if orientation == .horizontal {
                currX += childSize.width + spacing
            } else {
                currY += childSize.height + spacing
            }
        }
    }
}
