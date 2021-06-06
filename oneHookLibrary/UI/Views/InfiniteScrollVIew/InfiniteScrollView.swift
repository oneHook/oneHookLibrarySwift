import UIKit

open class InfiniteScrollView<T: UIView>: EDScrollView, UIScrollViewDelegate {

    public enum Orientation {
        case vertical, horizontal
    }

    public enum Direction {
        case before, after, center
    }

    private let spread: CGFloat = 6000
    private let threshold: CGFloat = 100
    private(set) var cells = [T]()
    private var recycledCells = [T]()
    private(set) var isInterationInProgress: Bool = false

    /* For Vertical */
    public var cellDefaultHeight: CGFloat?
    public var snapToCenter: Bool = false
    private var referenceCellCenterY: CGFloat = 0

    public var orientation: Orientation = .vertical {
        didSet {
            onOrientationChange()
        }
    }

    public override func commonInit() {
        super.commonInit()
        delegate = self
        onOrientationChange()
    }

    private func onOrientationChange() {
        cells.forEach {
            $0.removeFromSuperview()
            destroyCell($0)
        }
        if orientation == .horizontal {
            contentSize = CGSize(width: spread, height: 1)
            contentOffset = CGPoint(x: spread / 2, y: 0)
        } else {
            contentSize = CGSize(width: 1, height: spread)
            contentOffset = CGPoint(x: 0, y: spread / 2)
        }
        setNeedsLayout()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        if orientation == .horizontal {
            fillContentHorizontal()
        } else {
            fillContentVertically()
        }
    }

    private func fillContentHorizontal() {
        let maxHeight = bounds.height - paddingTop - paddingBottom

        var leftMostView: T
        var rightMostView: T
        if cells.isEmpty {
            cells.append(getCell(direction: .center, referenceCell: nil).apply {
                addSubview($0)
                let cellSize = $0.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: maxHeight))
                $0.bounds = CGRect(origin: .zero, size: cellSize)
                $0.center = CGPoint(x: contentOffset.x + bounds.width / 2, y: bounds.height / 2)
            })
            leftMostView = cells[0]
            rightMostView = leftMostView
        } else {
            leftMostView = cells.first!
            rightMostView = cells.last!
        }

        let leftEdge = contentOffset.x
        let rightEdge = contentOffset.x + bounds.width

        /* Fill Before or remove extra */
        while leftMostView.frame.maxX < leftEdge - threshold && cells.count > 1 {
            cells.remove(at: 0).removeFromSuperview()
            destroyCell(leftMostView)
            leftMostView = cells[0]
        }

        while leftMostView.frame.minX > leftEdge {
            cells.insert(getCell(direction: .before, referenceCell: leftMostView).apply {
                addSubview($0)
                let cellSize = $0.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: maxHeight))
                $0.frame = CGRect(
                    x: leftMostView.frame.minX - cellSize.width,
                    y: (bounds.height - cellSize.height) / 2,
                    width: cellSize.width,
                    height: cellSize.height
                    )
                leftMostView = $0
            }, at: 0)
        }

        /* Fill After or remove extra */

        while rightMostView.frame.minX > rightEdge + threshold && cells.count > 1 {
            cells.removeLast().removeFromSuperview()
            destroyCell(rightMostView)
            rightMostView = cells.last!
        }

        while rightMostView.frame.minX < rightEdge {
            cells.append(getCell(direction: .after, referenceCell: rightMostView).apply {
                addSubview($0)
                let cellSize = $0.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: maxHeight))
                $0.frame = CGRect(
                    x: rightMostView.frame.maxX,
                    y: (bounds.height - cellSize.height) / 2,
                    width: cellSize.width,
                    height: cellSize.height
                    )
                rightMostView = $0
            })
        }

        /* Move content offset so we never reach the end */
        var offset = CGFloat(0)
        if contentOffset.x < spread / 3 {
            offset = spread / 2 - spread / 3
        } else if contentOffset.x > spread * 2 / 3 {
            offset = spread / 2 - spread * 2 / 3
        }
        if offset != 0 {
            contentOffset = CGPoint(x: contentOffset.x + offset, y: 0)
            for cell in cells {
                cell.frame = cell.frame.offsetBy(dx: offset, dy: 0)
            }
        }
    }

    private func layoutCellVertically(
        cell: UIView,
        maxWidth: CGFloat,
        referenceY: CGFloat,
        direction: Direction
    ) {
        let cellSize = cell.sizeThatFits(
            CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        )
        var cellX: CGFloat = 0
        var cellWidth: CGFloat = maxWidth
        let cellHeight = cellDefaultHeight ?? cellSize.height
        if cell.layoutGravity.contains(.start) {
            cellWidth = cellSize.width
        } else if cell.layoutGravity.contains(.end) {
            cellWidth = cellSize.width
            cellX = bounds.width - cellWidth
        } else if cell.layoutGravity.contains(.centerHorizontal) {
            cellWidth = cellSize.width
            cellX = (bounds.width - cellWidth) / 2
        }
        var minY = CGFloat(0)
        switch direction {
        case .before:
            minY = referenceY - cellHeight
        case .after:
            minY = referenceY
        case .center:
            minY = referenceY - cellHeight / 2
            referenceCellCenterY = referenceY
        }
        cell.frame = CGRect(
            x: cellX,
            y: minY,
            width: cellWidth,
            height: cellHeight
        )
    }

    private func fillContentVertically() {
        let maxWidth = bounds.width - paddingStart - paddingEnd

        var topMostView: T
        var bottomMostView: T
        if cells.isEmpty {
            cells.append(getCell(direction: .center, referenceCell: nil).apply {
                addSubview($0)
                layoutCellVertically(
                    cell: $0,
                    maxWidth: maxWidth,
                    referenceY: contentOffset.y + bounds.height / 2,
                    direction: .center
                )
            })
            topMostView = cells[0]
            bottomMostView = topMostView
        } else {
            topMostView = cells.first!
            bottomMostView = cells.last!
        }

        let topEdge = contentOffset.y
        let bottomEdge = contentOffset.y + bounds.height

        /* Fill Before or remove extra */

        while topMostView.frame.maxY < topEdge - threshold && cells.count > 1 {
            cells.remove(at: 0).removeFromSuperview()
            destroyCell(topMostView)
            topMostView = cells[0]
        }

        while topMostView.frame.minY > topEdge {
            cells.insert(getCell(direction: .before, referenceCell: topMostView).apply {
                addSubview($0)
                layoutCellVertically(
                    cell: $0,
                    maxWidth: maxWidth,
                    referenceY: topMostView.frame.minY,
                    direction: .before
                )
                topMostView = $0
            }, at: 0)
        }

        /* Fill After or remove extra */

        while bottomMostView.frame.minY > bottomEdge + threshold && cells.count > 1 {
            cells.removeLast().removeFromSuperview()
            destroyCell(bottomMostView)
            bottomMostView = cells.last!
        }

        while bottomMostView.frame.minY < bottomEdge {
            cells.append(getCell(direction: .after, referenceCell: bottomMostView).apply {
                addSubview($0)
                layoutCellVertically(
                    cell: $0,
                    maxWidth: maxWidth,
                    referenceY: bottomMostView.frame.maxY,
                    direction: .after
                )
                bottomMostView = $0
            })
        }

        /* Move content offset so we never reach the end */
        var offset = CGFloat(0)
        if contentOffset.y < spread / 3 {
            offset = spread / 2 - spread / 3
        } else if contentOffset.y > spread * 2 / 3 {
            offset = spread / 2 - spread * 2 / 3
        }
        if let cellHeight = cellDefaultHeight {
            offset = round((offset / cellHeight)) * cellHeight
        }
        if offset != 0 {
            contentOffset = CGPoint(x: 0, y: contentOffset.y + offset)
            for cell in cells {
                cell.frame = cell.frame.offsetBy(dx: 0, dy: offset)
            }
        }
    }

    open func dequeueCell() -> T {
        recycledCells.isEmpty ? T() : recycledCells.removeLast()
    }

    open func destroyCell(_ cell: T) {
        recycledCells.append(cell)
    }

    public var centerCell: T? {
        cells.first(where: {
            let cellFrame = $0.frame.offsetBy(dx: 0, dy: -contentOffset.y)
            return cellFrame.contains(
                CGPoint(x: bounds.width / 2,
                        y: bounds.height / 2)
            )
        })
    }

    /* Child should override */

    open func getCell(direction: Direction, referenceCell: T?) -> T {
        return T.init().apply {
            $0.layoutSize = CGSize(width: dp(100), height: bounds.height)
            $0.backgroundColor = UIColor.random()
        }
    }

    open func scrollViewDidEndInteraction(_ scrollView: UIScrollView) {
        isInterationInProgress = false
        if let centerCell = centerCell {
            scrollViewDidStopAtCenterCell(scrollView, centerCell: centerCell)
        }
    }

    open func scrollViewDidStopAtCenterCell(_ scrollView: UIScrollView, centerCell: T) {

    }

    /* UIScrollViewDelegate */

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isInterationInProgress = true
    }

    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        isInterationInProgress = true
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard
            let cellHeight = cellDefaultHeight,
            snapToCenter else {
            return
        }
        let referenceY = referenceCellCenterY - bounds.height / 2
        let offset = (targetContentOffset.pointee.y - referenceY) / cellHeight
        let targetY = referenceY + round(offset) * cellHeight
        targetContentOffset.pointee = CGPoint(x: 0, y: targetY)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndInteraction(scrollView)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidEndInteraction(scrollView)
        }
    }
}
