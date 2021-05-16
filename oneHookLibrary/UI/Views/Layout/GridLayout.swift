import UIKit

open class GridLayout: BaseView {

    public var verticalSpacing: CGFloat = dp(10)
    public var horizontalSpacing: CGFloat = dp(10)
    public var cellHeight: CGFloat = dp(85)
    public var dividerWidth: CGFloat = dp(1)
    public var horizontalDividerPadding: CGFloat = 0
    public var verticalDividerPadding: CGFloat = 0

    public var columnCount: Int = 2
    public var showDivider: Bool = false

    public var dividerColor: UIColor = .ed_dividerColor {
        didSet {
            for divider in dividers {
                divider.backgroundColor = self.dividerColor.cgColor
            }
        }
    }

    private var dividers = [CALayer]()

    private var totalRows: Int {
        subviews.count / columnCount + min(1, subviews.count % columnCount)
    }

    private func makeDividerLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.backgroundColor = dividerColor.cgColor
        return layer
    }

    /* Calculate total number of dividers needed
     and make sure we have just the right number of dividers */
    private func checkDividers() {
        let lastRowColumns = subviews.count % columnCount
        let horizontalDividers = max(0, totalRows - 1)
        let verticalDividersNotLastRow = max(0, (totalRows - 1) * (columnCount - 1))
        let verticalDividersLastRow = lastRowColumns == 0 ? max(0, columnCount - 1) : max(0, lastRowColumns - 1)
        let dividerCount = showDivider ? horizontalDividers + verticalDividersNotLastRow + verticalDividersLastRow : 0

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
        checkDividers()

        guard showDivider, subviews.isNotEmpty else {
            return
        }

        let columnCount = CGFloat(self.columnCount)
        let cellsWidth = bounds.width - (columnCount - 1) * horizontalSpacing
        let cellWidth = (cellsWidth - paddingStart - paddingEnd) / columnCount

        var dividerIndex = 0
        var row = 0
        var horizontalDividerY = paddingTop + cellHeight + verticalSpacing / 2 - dividerWidth / 2
        var verticalDividerY = paddingTop + verticalDividerPadding

        while row < totalRows && dividers.indices.contains(dividerIndex) {
            let isLastRow = row == totalRows - 1
            /* Horizontal dividers */
            if !isLastRow {
                dividers[dividerIndex].frame = CGRect(
                    x: paddingStart + horizontalDividerPadding,
                    y: horizontalDividerY,
                    width: bounds.width - paddingStart - paddingEnd - horizontalDividerPadding * 2,
                    height: dividerWidth
                )
                dividerIndex += 1
            }

            var currX = paddingStart + cellWidth + horizontalSpacing / 2

            /* Vertical dividers */
            var verticalDividerCount = self.columnCount - 1
            /* If at last line, calculate how many we need based on how many
               columns at last line */
            if isLastRow && subviews.count % self.columnCount > 0 {
                verticalDividerCount = subviews.count % self.columnCount - 1
            }
            for _ in 0..<verticalDividerCount where dividers.indices.contains(dividerIndex) {
                dividers[dividerIndex].frame = CGRect(
                    x: currX - dividerWidth / 2,
                    y: verticalDividerY,
                    width: dividerWidth,
                    height: cellHeight - verticalDividerPadding * 2
                )
                dividerIndex += 1
                currX += cellWidth + horizontalSpacing
            }
            row += 1
            horizontalDividerY += cellHeight + verticalSpacing
            verticalDividerY += cellHeight + verticalSpacing
        }
    }

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        guard subviews.isNotEmpty else {
            return .zero
        }
        let rows = CGFloat(totalRows)
        return CGSize(
            width: size.width,
            height: paddingTop +
                cellHeight * rows +
                verticalSpacing * (rows - 1) +
                paddingBottom
        )
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        guard subviews.isNotEmpty else {
            return
        }

        let columnCount = CGFloat(self.columnCount)
        let cellsWidth = bounds.width - (columnCount - 1) * horizontalSpacing
        let cellWidth = (cellsWidth - paddingStart - paddingEnd) / columnCount

        for (index, view) in subviews.enumerated() {
            let x = CGFloat(index % self.columnCount)
            let y = CGFloat(index / self.columnCount)
            view.frame = CGRect(
                x: paddingStart + x * (cellWidth + horizontalSpacing),
                y: paddingTop + y * (cellHeight + verticalSpacing),
                width: cellWidth,
                height: cellHeight
            )
        }
    }

    open override func invalidateAppearance() {
        let dividerColor = self.dividerColor
        self.dividerColor = dividerColor
    }
}
