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

    public var snapToCenter: Bool = false

    /* For Horizontal */
    public var cellDefaultWidth: CGFloat?
    private var referenceCellCenterX: CGFloat = 0

    /* For Vertical */
    public var cellDefaultHeight: CGFloat?
    private var referenceCellCenterY: CGFloat = 0

    public var orientation: Orientation = .vertical {
        didSet {
            reload()
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    public override func commonInit() {
        super.commonInit()
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        delegate = self
        reload()
    }

    func reload() {
        cells.forEach {
            $0.removeFromSuperview()
            destroyCell($0)
        }
        cells.removeAll()
        if orientation == .horizontal {
            contentSize = CGSize(width: spread, height: 1)
            contentOffset = CGPoint(x: spread / 2, y: 0)
        } else {
            contentSize = CGSize(width: 1, height: spread)
            contentOffset = CGPoint(x: 0, y: spread / 2)
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        guard bounds.width > 0,
              bounds.height > 0 else {
            return
        }
        if orientation == .horizontal {
            fillContentHorizontal()
        } else {
            fillContentVertically()
        }
    }

    private func layoutCellHorizontally(
        cell: UIView,
        maxHeight: CGFloat,
        referenceX: CGFloat,
        direction: Direction
    ) {
        let cellSize = cell.sizeThatFits(
            CGSize(width: CGFloat.greatestFiniteMagnitude, height: maxHeight)
        )
        var cellY: CGFloat = 0
        let cellWidth = cellDefaultWidth ?? cellSize.width
        var cellHeight = maxHeight
        if cell.layoutGravity.contains(.top) {
            cellHeight = cellSize.height
        } else if cell.layoutGravity.contains(.bottom) {
            cellHeight = cellSize.height
            cellY = bounds.height - cellHeight
        } else if cell.layoutGravity.contains(.centerVertical) {
            cellHeight = cellSize.height
            cellY = (bounds.height - cellHeight) / 2
        }
        var minX = CGFloat(0)
        switch direction {
        case .before:
            minX = referenceX - cellWidth
        case .after:
            minX = referenceX
        case .center:
            minX = referenceX - cellWidth / 2
            referenceCellCenterX = referenceX
        }
        cell.frame = CGRect(
            x: minX,
            y:  cellY,
            width: cellWidth,
            height: cellHeight
        )
    }

    private func fillContentHorizontal() {
        let maxHeight = bounds.height - paddingTop - paddingBottom

        var leftMostView: T
        var rightMostView: T
        if cells.isEmpty {
            cells.append(getCell(direction: .center, referenceCell: nil).apply {
                addSubview($0)
                layoutCellHorizontally(
                    cell: $0,
                    maxHeight: maxHeight,
                    referenceX: contentOffset.x + bounds.width / 2,
                    direction: .center
                )
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
                layoutCellHorizontally(
                    cell: $0,
                    maxHeight: maxHeight,
                    referenceX: leftMostView.frame.minX,
                    direction: .center
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
                layoutCellHorizontally(
                    cell: $0,
                    maxHeight: maxHeight,
                    referenceX: rightMostView.frame.maxX,
                    direction: .center
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
        if let cellWidth = cellDefaultWidth {
            offset = round(offset / cellWidth) * cellWidth
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
            offset = round(offset / cellHeight) * cellHeight
        }
        if offset != 0 {
            contentOffset = CGPoint(x: 0, y: contentOffset.y + offset)
            for cell in cells {
                cell.frame = cell.frame.offsetBy(dx: 0, dy: offset)
            }
        }
    }

    open func dequeueCell() -> T {
        recycledCells.isEmpty ? T().apply {
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellTapped(tapRec:))))
        } : recycledCells.removeLast()
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

    @objc private func cellTapped(tapRec: UITapGestureRecognizer) {
        guard
            let cell = tapRec.view as? T,
            snapToCenter else {
            return
        }
        isInterationInProgress = true
        var targetOffset: CGPoint = .zero
        if orientation == .horizontal {
            targetOffset.x = cell.center.x - bounds.width / 2
        } else {
            targetOffset.y = cell.center.y - bounds.height / 2
        }
        UIView.animate(
            withDuration: .defaultAnimationSmall,
            animations: {
                self.setContentOffset(targetOffset, animated: false)
            },
            completion: { (_) in
                self.scrollViewDidEndInteraction(self)
            })
    }

    /* Child should override */

    open func getCell(direction: Direction, referenceCell: T?) -> T {
        fatalError()
    }

    open func scrollViewDidEndInteraction(_ scrollView: UIScrollView) {
        isInterationInProgress = false
    }

    /* UIScrollViewDelegate */

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }

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
