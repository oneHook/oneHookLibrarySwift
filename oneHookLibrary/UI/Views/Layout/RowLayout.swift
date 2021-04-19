import UIKit

open class RowLayout: BaseView {

    public var spacing: CGFloat = 0

    open override func layoutSubviews() {
        super.layoutSubviews()
        guard subviews.isNotEmpty else {
            return
        }
        let childCount = CGFloat(subviews.count)
        let childWidth = (bounds.width - paddingStart - paddingEnd - spacing * (childCount - 1)) / childCount
        for index in subviews.indices {
            let child = subviews[index]
            let currX = paddingStart + CGFloat(index) * (childWidth + spacing)
            child.frame = CGRect(
                x: currX,
                y: paddingTop,
                width: childWidth,
                height: bounds.height - paddingTop - paddingBottom
            )
        }
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard layoutSize == .zero else {
            return layoutSize
        }
        guard subviews.isNotEmpty else {
            return .zero
        }
        let childCount = CGFloat(subviews.count)
        let childWidth = (size.width - paddingStart - paddingEnd - spacing * (childCount - 1)) / childCount
        var maxHeight = CGFloat(0)
        for index in subviews.indices {
            let child = subviews[index]
            let childSize = child.sizeThatFits(CGSize(width: childWidth, height: CGFloat.greatestFiniteMagnitude))
            maxHeight = max(childSize.height, maxHeight)
        }
        return CGSize(width: size.width, height: maxHeight + paddingTop + paddingBottom)
    }
}
