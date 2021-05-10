import UIKit

open class LinearLayout: BaseView {

    public enum Orientation {
        case horizontal
        case vertical
    }

    public var orientation: Orientation = .vertical
    public var contentGravity: Gravity = [.top, .start]

    // swiftlint:disable cyclomatic_complexity
    private func measureChildren(_ size: CGSize) -> [CGSize] {
        var childrenSizes: [CGSize] = []
        var remainWidth = size.width - paddingStart - paddingEnd
        var remainHeight = size.height - paddingTop - paddingBottom
        var totalWeight: CGFloat = 0

        for view in self.subviews {
            if view.isHidden || view.shouldSkip {
                childrenSizes.append(CGSize.zero)
            } else if view.layoutWeight == 0 {
                /* Child wrap content */
                let childSize = view.sizeThatFits(CGSize(width: remainWidth - view.marginStart - view.marginEnd,
                                                         height: remainHeight - view.marginTop - view.marginBottom))
                let childActualSize = CGSize(width: childSize.width + view.marginStart + view.marginEnd,
                                             height: childSize.height + view.marginTop + view.marginBottom)
                childrenSizes.append(childActualSize)
                if orientation == .vertical {
                    remainHeight -= childActualSize.height
                } else {
                    remainWidth -= childActualSize.width
                }
            } else {
                totalWeight += view.layoutWeight
                /* Child use weight, use a empty one for now */
                childrenSizes.append(CGSize.zero)

                /* Remain Width/Height should not include margins child needed */
                if orientation == .vertical {
                    remainHeight -= (view.marginTop + view.marginBottom)
                } else {
                    remainWidth -= (view.marginStart + view.marginEnd)
                }
            }
        }

        guard totalWeight > 0 else {
            return childrenSizes
        }

        /* measure those with weight */
        for (index, view) in self.subviews.enumerated() where !view.shouldSkip  && view.layoutWeight > 0 {
            if view.isHidden {
                continue
            }
            if orientation == .vertical {
                let fillHeight = max(0, (view.layoutWeight / totalWeight) * remainHeight)
                let childSize = view.sizeThatFits(CGSize(width: remainWidth - view.marginStart - view.marginEnd,
                                                         height: fillHeight))
                if fillHeight > 0 {
                    childrenSizes[index].height = fillHeight + view.marginTop + view.marginBottom
                } else {
                    childrenSizes[index].height = 0
                }
                childrenSizes[index].width = min(remainWidth,
                                                 childSize.width + view.marginStart + view.marginEnd)
            } else {
                let fillWidth = max(0, (view.layoutWeight / totalWeight) * remainWidth)
                let childSize = view.sizeThatFits(CGSize(width: fillWidth,
                                                         height: remainHeight - view.marginTop - view.marginBottom))
                if fillWidth > 0 {
                    childrenSizes[index].width = fillWidth + view.marginStart + view.marginEnd
                } else {
                    childrenSizes[index].width = 0
                }
                childrenSizes[index].height = min(remainHeight, childSize.height + view.marginTop + view.marginBottom)
            }
        }
        return childrenSizes
    }
    // swiftlint:enable cyclomatic_complexity

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        if layoutParams.layoutSize != CGSize.zero {
            return layoutParams.layoutSize
        }
        var size = size
        if size.width == 0 {
            size.width = CGFloat.greatestFiniteMagnitude
        }
        if size.height == 0 {
            size.height = CGFloat.greatestFiniteMagnitude
        }
        let childrenSizes = measureChildren(size)
        return sizeThatFits(childrenSizes)
    }

    private func sizeThatFits(_ childrenSizes: [CGSize]) -> CGSize {
        if orientation == .vertical {
            let measured = childrenSizes.reduce(CGSize.zero, { (result, size) -> CGSize in
                CGSize(width: max(result.width, size.width), height: result.height + size.height)
            })
            return CGSize(width: measured.width + paddingStart + paddingEnd,
                          height: measured.height + paddingTop + paddingBottom)
        } else {
            let measured = childrenSizes.reduce(CGSize.zero, { (result, size) -> CGSize in
                CGSize(width: result.width + size.width, height: max(result.height, size.height))
            })
            return CGSize(width: measured.width + paddingStart + paddingEnd,
                          height: measured.height + paddingTop + paddingBottom)
        }
    }

    open override func sizeToFit() {
        let size = sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                       height: CGFloat.greatestFiniteMagnitude))
        self.bounds = CGRect(origin: CGPoint.zero, size: size)
    }

    // swiftlint:disable cyclomatic_complexity
    open override func layoutSubviews() {
        super.layoutSubviews()
        let width = self.bounds.width
        let height = self.bounds.height
        let childrenSizes = measureChildren(CGSize(width: width, height: height))
        let sizeThatFit = sizeThatFits(childrenSizes)

        var currX = paddingStart
        var currY = paddingTop

        if contentGravity.contains(.centerHorizontal) && orientation == .horizontal {
            currX = (width - sizeThatFit.width) / 2 + paddingStart
        }
        if contentGravity.contains(.centerVertical) && orientation == .vertical {
            currY = (height - sizeThatFit.height) / 2 + paddingTop
        }
        if contentGravity.contains(.end) && orientation == .horizontal {
            currX = width - sizeThatFit.width + paddingStart
        }
        if contentGravity.contains(.bottom) && orientation == .vertical {
            currY = height - sizeThatFit.height + paddingTop
        }

        for (view, childSize) in zip(subviews, childrenSizes) where !view.shouldSkip {
            var viewX = currX + view.marginStart
            var viewY = currY + view.marginTop
            var viewWidth = max(0, childSize.width - view.marginStart - view.marginEnd)
            var viewHeight = max(0, childSize.height - view.marginTop - view.marginBottom)

            if orientation == .horizontal {
                if view.layoutGravity.contains(.fillVertical) {
                    viewHeight = height - view.marginTop - view.marginBottom - paddingTop - paddingBottom
                }
                if view.layoutGravity.contains(.centerVertical) {
                    viewY = paddingTop + (height - paddingTop - paddingBottom - childSize.height + view.marginTop + view.marginBottom) / 2
                } else if view.layoutGravity.contains(.bottom) {
                    viewY = height - (childSize.height - view.marginTop) - paddingBottom
                }
            } else {
                if view.layoutGravity.contains(.fillHorizontal) {
                    viewWidth = width - view.marginStart - view.marginEnd - paddingStart - paddingEnd
                }
                if view.layoutGravity.contains(.centerHorizontal) {
                    viewX = paddingStart + (width - paddingStart - paddingEnd - childSize.width + view.marginStart + view.marginEnd) / 2
                } else if view.layoutGravity.contains(.end) {
                    viewX = width - (childSize.width - view.marginStart) - paddingEnd
                }
            }
            view.frame = CGRect(x: viewX,
                                y: viewY,
                                width: viewWidth,
                                height: viewHeight)
            if orientation == .horizontal {
                currX += childSize.width
            } else {
                currY += childSize.height
            }
        }
    }
    // swiftlint:enable cyclomatic_complexity
}
