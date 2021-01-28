import UIKit

open class FlowLayout: BaseView {

    public var verticalSpacing: CGFloat = 5
    public var horizontalSpacing: CGFloat = 5

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        measure(size: size, shouldLayout: false)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        _ = measure(size: self.bounds.size, shouldLayout: true)
    }

    public func layout(width: CGFloat) -> CGSize {
        measure(size: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                shouldLayout: true)
    }

    private func measure(size: CGSize, shouldLayout: Bool) -> CGSize {
        let width = size.width - paddingStart - paddingEnd
        var currY: CGFloat = paddingTop
        var currX: CGFloat = paddingStart

        var maxX: CGFloat = 0
        var maxY: CGFloat = 0

        var currentLineViews = [UIView]()
        var lineMaxHeight: CGFloat = 0

        func measureLine() {
            /* Now we have info about the highest child among this line
             we can layout each child according to its gravity */
            currX = paddingStart
            for view in currentLineViews {
                let viewSize = view.sizeThatFits(CGSize(width: width - view.marginStart - view.marginEnd,
                                                        height: CGFloat.greatestFiniteMagnitude))
                let minX = currX + view.marginStart
                if shouldLayout {
                    var targetY = currY
                    var targetHeight = viewSize.height
                    if view.layoutGravity.contains(.center) {
                        targetY += (lineMaxHeight - viewSize.height) / 2
                    } else if view.layoutGravity.contains(.bottom) {
                        targetY += lineMaxHeight - viewSize.height - view.marginBottom
                    } else if view.layoutGravity.contains(.fillVertical) {
                        targetY += view.marginTop
                        targetHeight = lineMaxHeight - view.marginTop - view.marginBottom
                    } else {
                        /* By default treat as top */
                        targetY += view.marginTop
                    }
                    view.frame = CGRect(x: minX,
                                        y: targetY,
                                        width: viewSize.width,
                                        height: targetHeight)
                }
                /* update the right most value */
                maxX = max(maxX, minX + viewSize.width + view.marginEnd)
                currX += viewSize.width + view.marginStart + view.marginEnd + horizontalSpacing
            }

            /* flow to new line, need reset x, increase y, and clear current line info */
            currX = paddingStart
            currY += lineMaxHeight + verticalSpacing
            currentLineViews.removeAll()
            lineMaxHeight = 0

            /* update bottom most value */
            maxY = max(maxY, currY - verticalSpacing)
        }

        /* Track when skipping to a new line, not enough space. Limit once per view. */
        var index: Int = 0
        while index < self.subviews.count {
            let view = self.subviews[index]
            if view.shouldSkip {
                index += 1
                continue
            }
            let viewSize = view.sizeThatFits(CGSize(width: width - view.marginStart - view.marginEnd,
                                                    height: CGFloat.greatestFiniteMagnitude))
            let actualViewWidth = viewSize.width + view.marginStart + view.marginEnd
            let actualViewHeight = viewSize.height + view.marginTop + view.marginBottom

            if currentLineViews.isEmpty && actualViewWidth >= paddingStart + width {
                /* New line, edge case, view width already exceed the whole line */
                if shouldLayout {
                    view.frame = CGRect(x: paddingStart + view.marginStart,
                                        y: currY + view.marginTop,
                                        width: viewSize.width,
                                        height: viewSize.height)
                }

                /* treat as flowing to a new line */
                currX = paddingStart
                currY += viewSize.height + verticalSpacing + view.marginTop + view.marginBottom
                maxX = max(maxX, paddingStart + view.marginStart + view.marginEnd + viewSize.width)
                maxY = max(maxY, currY - verticalSpacing)
                index += 1
            } else if currentLineViews.isNotEmpty && currX + actualViewWidth > paddingStart + width {
                /* Not enough space for current view, should go to new line */
                measureLine()
            } else {
                /* if at same line, just add view into current line, will layout when change to new line */
                currentLineViews.append(view)
                currX += actualViewWidth + horizontalSpacing
                lineMaxHeight = max(lineMaxHeight, actualViewHeight)
                index += 1
            }
        }

        if currentLineViews.isNotEmpty {
            measureLine()
        }
        return CGSize(width: min(size.width, maxX + paddingEnd),
                      height: min(size.height, maxY + paddingBottom))
    }
}
