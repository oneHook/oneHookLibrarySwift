import UIKit

public protocol BaseViewPagerDatasource: class {
    func numberOfItems() -> Int
    func viewForItemAt(index: Int) -> UIView
}

open class ViewPager<ViewType: UIView>: BaseView, UIScrollViewDelegate {

    public var isScrollEnabled: Bool = true {
        didSet {
            scrollView.isScrollEnabled = isScrollEnabled
        }
    }

    private let scrollView = EDScrollView().apply {
        $0.isPagingEnabled = true
    }
    private var _visibleViews = [Int: UIView]()
    private var _currentIndex: Int = 0

    public var onScroll: ((CGFloat) -> Void)?
    public var onPageSelected: ((Int) -> Void)?
    public var horizontalSpacing = CGFloat(10)

    public weak var datasource: BaseViewPagerDatasource? {
        didSet {
            reloadData()
            layoutIfNeeded()
        }
    }

    public var visibleViews: [Int: UIView] {
        _visibleViews
    }

    public var currentIndex: Int {
        _currentIndex
    }

    open override func commonInit() {
        super.commonInit()
        clipsToBounds = true
        scrollView.delegate = self
        addSubview(scrollView)
    }

    open func reloadData() {
        for view in scrollView.subviews {
            view.removeFromSuperview()
        }
        _visibleViews.removeAll()
        setNeedsLayout()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.matchParent(right: -horizontalSpacing)

        guard
            bounds.width > 0,
            bounds.height > 0,
            let datasource = datasource,
            _visibleViews.isEmpty else {
            return
        }
        let itemCount = datasource.numberOfItems()
        scrollView.contentSize = CGSize(
            width: scrollView.bounds.width * CGFloat(itemCount),
            height: scrollView.bounds.height
        )
        if _currentIndex >= itemCount {
            _currentIndex = itemCount - 1
        }

        fill()
    }

    private func fill() {
        guard let datasource = datasource else {
            return
        }
        let itemCount = datasource.numberOfItems()
        createAndLayoutPageAt(index: _currentIndex)
        if _currentIndex + 1 < itemCount {
            createAndLayoutPageAt(index: _currentIndex + 1)
        }
        if _currentIndex - 1 >= 0 {
            createAndLayoutPageAt(index: _currentIndex - 1)
        }
    }

    private func createAndLayoutPageAt(index: Int) {
        guard
            let datasource = datasource,
            _visibleViews[index] == nil else {
            return
        }

        let width = scrollView.bounds.width
        let height = scrollView.bounds.height
        datasource.viewForItemAt(index: index).also {
            scrollView.addSubview($0)
            $0.frame = CGRect(
                x: CGFloat(index) * width,
                y: 0,
                width: width - horizontalSpacing,
                height: height
            )
            _visibleViews[index] = $0
        }
    }

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        if layoutSize == CGSize.zero {
            return super.sizeThatFits(size)
        }
        return CGSize(width: min(size.width, layoutSize.width),
                      height: min(size.height, layoutSize.height))
    }

    private func checkScrollViewContentOffset() {
        let newIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        guard newIndex != _currentIndex else {
            return
        }
        _currentIndex = newIndex
        for (index, view) in _visibleViews {
            if index < _currentIndex - 1 || index > _currentIndex + 1 {
                view.removeFromSuperview()
                _visibleViews.removeValue(forKey: index)
            }
        }
        fill()
        onPageSelected?(newIndex)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        checkScrollViewContentOffset()
        onScroll?(scrollView.contentOffset.x / scrollView.bounds.width)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        checkScrollViewContentOffset()
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            checkScrollViewContentOffset()
        }
    }

    public func setSelectedIndex(_ index: Int, animated: Bool) {
        let offsetX = CGFloat(index) * scrollView.bounds.width
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: animated)
    }
}
