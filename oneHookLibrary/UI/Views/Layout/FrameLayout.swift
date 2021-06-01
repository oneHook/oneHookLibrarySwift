import UIKit

open class FrameLayout: BaseView {

    private func measureChildren(_ size: CGSize) -> [CGSize] {
        var childrenSizes: [CGSize] = []
        for view in self.subviews {
            if view.isHidden || view.shouldSkip {
                childrenSizes.append(CGSize.zero)
            } else {
                let childSize = view.sizeThatFits(
                    CGSize(width: size.width - view.marginStart - view.marginEnd,
                           height: size.height - view.marginTop - view.marginBottom)
                )
                childrenSizes.append(
                    CGSize(width: childSize.width + view.marginStart + view.marginEnd,
                           height: childSize.height + view.marginTop + view.marginBottom)
                )
            }
        }
        return childrenSizes
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        if layoutParams.layoutSize != CGSize.zero {
            return layoutParams.layoutSize
        }
        let childrenSizes = measureChildren(CGSize(width: size.width - paddingStart - paddingEnd,
                                                   height: size.height - paddingTop - paddingBottom))
        let maxSize = childrenSizes.reduce((width: CGFloat(0), height: CGFloat(0))) { (result, size) -> (width: CGFloat, height: CGFloat) in
            (width: max(result.width, size.width),
             height: max(result.height, size.height))
        }
        return CGSize(width: maxSize.width + paddingStart + paddingEnd,
                      height: maxSize.height + paddingTop + paddingBottom)
    }

    open override func sizeToFit() {
        let size = sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                       height: CGFloat.greatestFiniteMagnitude))
        self.bounds = CGRect(origin: CGPoint.zero, size: size)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        let width = self.bounds.width
        let height = self.bounds.height
        let childrenSizes = measureChildren(CGSize(width: width - paddingStart - paddingEnd,
                                                   height: height - paddingTop - paddingBottom))
        zip(subviews, childrenSizes).forEach { (child, size) in
            if child.shouldSkip {
                return
            }
            let gravity = child.layoutGravity
            var size = size

            /* Match parent */
            if gravity.contains(.fillHorizontal) {
                size.width = width - paddingStart - paddingEnd
            }
            if gravity.contains(.fillVertical) {
                size.height = height - paddingTop - paddingBottom
            }

            /* By Default, top left corner */
            var viewX = paddingStart + child.marginStart
            var viewY = paddingTop + child.marginTop

            if child.layoutGravity.contains(.centerHorizontal) {
                viewX = (width - paddingStart - paddingEnd - size.width) / 2 + paddingStart + child.marginStart
            } else if child.layoutGravity.contains(.end) {
                viewX = width - size.width + child.marginStart - paddingEnd
            }

            if child.layoutGravity.contains(.centerVertical) {
                viewY = (height - paddingTop - paddingBottom - size.height) / 2 + paddingTop + child.marginTop
            } else if child.layoutGravity.contains(.bottom) {
                viewY = height - size.height + child.marginTop - paddingBottom
            }

            child.frame = CGRect(x: viewX,
                                 y: viewY,
                                 width: size.width - child.marginStart - child.marginEnd,
                                 height: size.height - child.marginTop - child.marginBottom)
        }
    }
}
