import UIKit

open class InfiniteScrollerView<T>: EDScrollView, UIScrollViewDelegate where T: Comparable {

    /* Spacing between items */
    public var horizontalSpacing: CGFloat = 0
    public var shouldSnap: Bool = true
    public var shouldSelect: Bool = true
    public var threshold = dp(10)

    private var spread = dp(500000)
    private var lastWidth: CGFloat = 0
    private var lastHeight: CGFloat = 0
    private var centerIndex = 0

    private var cells = [UIView]()
    private var items = [T]()
    private var removedCells = [UIView]()

    public var visibleCells: [UIView] {
        cells
    }

    public var selectedCell: UIView? {
        guard cells.isNotEmpty else {
            return nil
        }
        return cells[cells.count / 2]
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        showsHorizontalScrollIndicator = false
        delegate = self
        commonInit()
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        if lastWidth != bounds.width || lastHeight != bounds.height {
            lastWidth = bounds.width
            lastHeight = bounds.height

            /* this magic number here must be a multiple of 3 */
            spread = bounds.width * 999
            contentSize = CGSize(width: spread, height: 0)
            contentOffset = CGPoint(x: spread / 2 - bounds.width / 2, y: 0)
            populate()
        }
    }

    open func startingItem() -> T {
        fatalErrorNotImplementedBySubclass()
    }

    open func previousItem(of item: T) -> T {
        fatalErrorNotImplementedBySubclass()
    }

    open func nextItem(of item: T) -> T {
        fatalErrorNotImplementedBySubclass()
    }

    open func createCell() -> UIView {
        fatalErrorNotImplementedBySubclass()
    }

    open func cellWillAppear(cell: UIView) {

    }

    open func bind(cell: UIView, item: T) {
        fatalErrorNotImplementedBySubclass()
    }

    open func setProgress(cell: UIView, progress: CGFloat) {

    }

    open func onItemSelected(item: T) {

    }

    open func measure(cell: UIView) -> CGSize {
        cell.sizeThatFits(CGSize(
            width: bounds.size.width,
            height: bounds.size.height - paddingTop - paddingBottom
        ))
    }

    private func obtainCell() -> UIView {
        if let last = removedCells.popLast() {
            cellWillAppear(cell: last)
            return last
        }
        return createCell().apply {
            cellWillAppear(cell: $0)
            if shouldSelect {
                $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellPressed(tapRec:))))
            }
        }
    }

    private var leftEdge: CGFloat {
        contentOffset.x
    }

    private var rightEdge: CGFloat {
        contentOffset.x + bounds.width
    }

    private func populate() {

        /* If starting with nothing, populate the center item */
        if cells.isEmpty {
            obtainCell().also {
                let item = startingItem()
                bind(cell: $0, item: item)
                cells.append($0)
                items.append(item)
                addSubview($0)

                CATransaction.begin()
                CATransaction.setDisableActions(true)
                $0.bounds = CGRect(origin: .zero, size: measure(cell: $0))
                $0.center = CGPoint(x: spread / 2, y: bounds.height / 2)
                CATransaction.commit()
            }
        }

        var leftMostCell = cells.first!
        var rightMostCell = cells.last!

        /* Remove/recycle off-screen ones */

        while leftMostCell.frame.maxX < leftEdge - threshold && cells.count > 1 {
            cells.remove(at: 0).also {
                items.remove(at: 0)
                removedCells.append($0)
                $0.removeFromSuperview()
                leftMostCell = cells.first!
            }
        }

        while rightMostCell.frame.minX > rightEdge + threshold && cells.count > 1 {
            cells.remove(at: cells.count - 1).also {
                items.remove(at: items.count - 1)
                removedCells.append($0)
                $0.removeFromSuperview()
                rightMostCell = cells.last!
            }
        }

        /* populate newly visible ones */

        while leftMostCell.frame.minX >= leftEdge - threshold {
            obtainCell().also {
                let newItem = previousItem(of: items[0])
                cells.insert($0, at: 0)
                items.insert(newItem, at: 0)
                insertSubview($0, at: 0)

                CATransaction.begin()
                CATransaction.setDisableActions(true)
                $0.bounds = CGRect(origin: .zero, size: measure(cell: $0))
                $0.center = CGPoint(
                    x: leftMostCell.frame.minX - horizontalSpacing - $0.bounds.width / 2,
                    y: bounds.height / 2
                )
                CATransaction.commit()

                bind(cell: $0, item: newItem)
                leftMostCell = $0
            }
        }

        while rightMostCell.frame.maxX <= rightEdge + threshold {
            obtainCell().also {
                let newItem = nextItem(of: items.last!)
                cells.append($0)
                items.append(newItem)
                addSubview($0)

                CATransaction.begin()
                CATransaction.setDisableActions(true)
                $0.bounds = CGRect(origin: .zero, size: measure(cell: $0))
                $0.center = CGPoint(
                    x: rightMostCell.frame.maxX + horizontalSpacing + $0.bounds.width / 2,
                    y: bounds.height / 2
                )
                CATransaction.commit()

                bind(cell: $0, item: newItem)
                rightMostCell = $0
            }
        }
    }

    @objc private func cellPressed(tapRec: UITapGestureRecognizer) {
        if
            let cell = tapRec.view,
            let index = cells.firstIndex(of: cell) {
            scrollViewDidEndAnimation(index: index)
        }
    }

    private func scrollViewDidEndAnimation(index: Int? = nil) {
        let centerItem = items[index ?? items.count / 2]
        if shouldSnap {
            snapTo(index: index ?? cells.count / 2)
        } else {
            recenter()
        }
        onItemSelected(item: centerItem)
    }

    private func snapTo(index: Int) {
        guard cells.isNotEmpty else {
            return
        }
        let centerCell = cells[index]
        UIView.animate(withDuration: .defaultAnimationSmall,
                       animations: {
                        self.setContentOffset(CGPoint(
                            x: centerCell.center.x - self.bounds.width / 2,
                            y: 0
                        ), animated: false)
        }, completion: { (_) in
            self.recenter()
        })
    }

    public func snapTo(item: T) {
        guard let index = items.firstIndex(of: item) else {
            return
        }
        snapTo(index: index)

    }

    private func recenter() {
        /* Center all the cells in the middle of the UIScrollView
           make it an illusion of infinite scroll */

        guard cells.isNotEmpty else {
            return
        }
        let centerIndex  = cells.count / 2
        let offset = cells[centerIndex].center.x - spread / 2
        cells.forEach {
            $0.center = CGPoint(x: $0.center.x - offset, y: $0.center.y)
        }
        contentOffset = CGPoint(x: spread / 2 - bounds.width / 2, y: 0)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        populate()

        cells.forEach {
            let offset = $0.center.x - scrollView.contentOffset.x - bounds.width / 2
            let progress = abs(offset) / $0.bounds.width
            setProgress(cell: $0, progress: min(1, progress))
        }
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidEndAnimation()
        }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndAnimation()
    }
}
