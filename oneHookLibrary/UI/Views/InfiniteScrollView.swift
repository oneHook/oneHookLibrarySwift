import UIKit

open class InfiniteScrollView<T: UIView>: EDScrollView {

    private let spread: CGFloat = 6000
    private let threshold: CGFloat = 100
    private var cells = [T]()

    public enum Orientation {
        case vertical, horizontal
    }

    public enum Direction {
        case before, after, center
    }

    public var orientation: Orientation = .vertical {
        didSet {
            onOrientationChange()
        }
    }

    public override func commonInit() {
        super.commonInit()
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

    private func fillContentVertically() {
        let maxWidth = bounds.width - paddingStart - paddingEnd

        var topMostView: T
        var bottomMostView: T
        if cells.isEmpty {
            cells.append(getCell(direction: .center, referenceCell: nil).apply {
                addSubview($0)
                let cellSize = $0.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
                $0.bounds = CGRect(origin: .zero, size: cellSize)
                $0.center = CGPoint(x: bounds.width / 2, y: contentOffset.y + bounds.height / 2)
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
                let cellSize = $0.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
                $0.frame = CGRect(
                    x: (bounds.width - cellSize.width) / 2,
                    y: topMostView.frame.minY - cellSize.height,
                    width: cellSize.width,
                    height: cellSize.height
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
                let cellSize = $0.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
                $0.frame = CGRect(
                    x: (bounds.width - cellSize.width) / 2,
                    y: bottomMostView.frame.maxY,
                    width: cellSize.width,
                    height: cellSize.height
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
        if offset != 0 {
            contentOffset = CGPoint(x: 0, y: contentOffset.y + offset)
            for cell in cells {
                cell.frame = cell.frame.offsetBy(dx: 0, dy: offset)
            }
        }
    }

    /* Child should override */

    open func getCell(direction: Direction, referenceCell: T?) -> T {
        return T.init().apply {
            $0.layoutSize = CGSize(width: dp(100), height: bounds.height)
            $0.backgroundColor = UIColor.random()
        }
    }

    open func destroyCell(_ cell: T) {

    }
}
