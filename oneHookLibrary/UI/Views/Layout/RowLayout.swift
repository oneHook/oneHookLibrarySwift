import UIKit

open class RowLayout: BaseView {

    var spacing: CGFloat = 0

    open override func layoutSubviews() {
        super.layoutSubviews()
        guard subviews.isNotEmpty else {
            return
        }
        let childCount = CGFloat(subviews.count)
        let childWidth = (bounds.width - spacing * (childCount - 1)) / childCount
        for index in subviews.indices {
            let child = subviews[index]
            let currX = CGFloat(index) * (childWidth + spacing)
            child.frame = CGRect(x: currX, y: 0, width: childWidth, height: bounds.height)
        }
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard subviews.isNotEmpty else {
            return .zero
        }
        let childCount = CGFloat(subviews.count)
        let childWidth = (size.width - spacing * (childCount - 1)) / childCount
        var maxHeight = CGFloat(0)
        for index in subviews.indices {
            let child = subviews[index]
            let childSize = child.sizeThatFits(CGSize(width: childWidth, height: CGFloat.greatestFiniteMagnitude))
            maxHeight = max(childSize.height, maxHeight)
        }
        return CGSize(width: size.width, height: maxHeight)
    }
}
