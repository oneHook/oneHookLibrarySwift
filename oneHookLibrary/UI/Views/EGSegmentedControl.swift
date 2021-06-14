import UIKit

open class EGSegmentedControl: BaseView {

    public struct SegmentInfo {
        var title: NSAttributedString
        var normalTextColor: UIColor
        var highlightTextColor: UIColor

        public init(title: String? = nil,
                    attributedTitle: NSAttributedString? = nil,
                    normalTextColor: UIColor = .ed_toolbarTextColor,
                    highlightTextColor: UIColor = .ed_toolbarBackgroundColor) {
            self.title = attributedTitle ?? title?.attributedString() ?? "".attributedString()
            self.normalTextColor = normalTextColor
            self.highlightTextColor = highlightTextColor
        }
    }

    public var defaultWidth: CGFloat = dp(0)
    public var defaultHeight: CGFloat = dp(40)
    public var cornerRadius: CGFloat = dp(0) {
        didSet {
            layer.cornerRadius = cornerRadius
            tabCoverView.layer.cornerRadius = cornerRadius - maskPadding
        }
    }
    public var maskPadding: CGFloat = dp(0) {
        didSet {
            tabCoverView.layer.cornerRadius = cornerRadius - maskPadding
        }
    }
    public var selectedTabColor: UIColor = .ed_toolbarTextColor {
        didSet {
            tabCoverView.backgroundColor = selectedTabColor
        }
    }

    public var onSegmentSelected: ((Int) -> Bool)?

    private let topLinearLayout = LinearLayout().apply {
        $0.orientation = .horizontal
    }
    private let tabMaskLayer = CALayer().apply {
        $0.backgroundColor = UIColor.white.cgColor
        $0.anchorPoint = .zero
    }

    private lazy var tabCoverView = BaseView().apply {
        $0.backgroundColor = selectedTabColor
    }

    private let bottomLinearLayout = LinearLayout().apply {
        $0.orientation = .horizontal
    }

    private var _tabOffset: CGFloat = 0
    private var _selectedIndex: Int = 0
    public var selectedIndex: Int {
        let tabWidth = bounds.width / CGFloat(tabCount)
        return Int(_tabOffset / max(1, tabWidth))
    }

    var tabCount: Int {
        max(1, topLinearLayout.subviews.count)
    }

    open override func commonInit() {
        super.commonInit()
        backgroundColor = .lightGray
        addSubview(bottomLinearLayout)
        addSubview(tabCoverView)
        addSubview(topLinearLayout)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap(tapRec:))))
        topLinearLayout.layer.mask = tabMaskLayer
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        if defaultWidth == 0 {
            return CGSize(width: size.width, height: defaultHeight)
        } else {
            return CGSize(width: defaultWidth, height: defaultHeight)
        }
    }

    @objc private func onTap(tapRec: UITapGestureRecognizer) {
        let tabWidth = bounds.width / CGFloat(tabCount)
        let location = tapRec.location(in: self)
        let tabIndex = Int(location.x / tabWidth)
        if onSegmentSelected?(tabIndex) ?? true {
            setSelectedIndex(tabIndex, animated: true)
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        topLinearLayout.matchParent()
        bottomLinearLayout.matchParent()
        let tabWidth = bounds.width / CGFloat(tabCount)
        tabMaskLayer.bounds = CGRect(
            origin: .zero,
            size: CGSize(width: tabWidth, height: bounds.height)
        )
        setSelectedIndex(_selectedIndex, animated: false)
    }

    private func makeTab() -> EDLabel {
        EDLabel().apply {
            $0.font = Fonts.bold(Fonts.fontSizeSmall)
            $0.textAlignment = .center
            $0.layoutGravity = [.fillVertical]
            $0.layoutWeight = 1
        }
    }

    public func setProgress(_ progress: CGFloat) {
        let tabWidth = bounds.width / CGFloat(tabCount)
        let targetPosition = CGPoint(
            x: tabWidth * progress + maskPadding,
            y: maskPadding
        )
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        tabMaskLayer.position = targetPosition
        CATransaction.commit()
        tabCoverView.frame = CGRect(
            origin: targetPosition,
            size: CGSize(width: tabWidth - 2 * maskPadding,
                         height: bounds.height - 2 * maskPadding)
        )
    }

    public func setSelectedIndex(_ index: Int, animated: Bool) {
        _selectedIndex = index
        if animated {
            let tabWidth = bounds.width / CGFloat(tabCount)
            let targetPosition = CGPoint(
                x: tabWidth * CGFloat(index) + maskPadding,
                y: maskPadding
            )

            CATransaction.begin()
            CATransaction.setCompletionBlock { [weak self] in
                self?.tabMaskLayer.position = targetPosition
            }
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))

            let animation = CABasicAnimation(keyPath: #keyPath(CALayer.position))
            animation.toValue = targetPosition
            animation.duration = .defaultAnimation
            animation.fillMode = CAMediaTimingFillMode.forwards
            animation.isRemovedOnCompletion = false
            tabMaskLayer.add(animation, forKey: #keyPath(CALayer.position))

            UIView.animate(
                withDuration: .defaultAnimation,
                animations: { [self] in
                    self.tabCoverView.frame = CGRect(
                        origin: targetPosition,
                        size: CGSize(width: tabWidth - 2 * maskPadding,
                                     height: bounds.height - 2 * maskPadding)
                    )
                }
            )

            CATransaction.commit()
        } else {
            setProgress(CGFloat(index))
        }
    }

    public func updateTabTitle(_ title: String, index: Int) {
        if
            let tabViewTop = topLinearLayout.subviews[safe: index] as? EDLabel,
            let tabViewBottom = bottomLinearLayout.subviews[safe: index] as? EDLabel {
            let attributedTitle = title.attributedString(letterSpacing: Fonts.kernLarge, textAlignment: .center)
            tabViewTop.attributedText = attributedTitle
            tabViewBottom.attributedText = attributedTitle
        }
    }

    public func setTabs(_ tabs: [SegmentInfo]) {
        makeOrRemove(
            toTargetCount: tabs.count,
            from: topLinearLayout.subviews.count,
            make: {
                topLinearLayout.addSubview(makeTab())
                bottomLinearLayout.addSubview(makeTab())
            }, remove: {
                topLinearLayout.subviews.last?.removeFromSuperview()
                bottomLinearLayout.subviews.last?.removeFromSuperview()
            })

        for index in tabs.indices {
            let tab = tabs[index]
            if
                let tab1 = topLinearLayout.subviews[index] as? EDLabel,
                let tab2 = bottomLinearLayout.subviews[index] as? EDLabel {
                tab1.attributedText = tab.title.attributedString(letterSpacing: Fonts.kernLarge, textAlignment: .center)
                tab2.attributedText = tab.title.attributedString(letterSpacing: Fonts.kernLarge, textAlignment: .center)
                tab1.textColor = tab.highlightTextColor
                tab2.textColor = tab.normalTextColor
            }
        }
        setNeedsLayout()
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *), UITraitCollection.current.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {

            for view in topLinearLayout.subviews {
                if let tab = view as? EDLabel {
                    tab.textColor = tab.textColor
                }
            }
            for view in bottomLinearLayout.subviews {
                if let tab = view as? EDLabel {
                    tab.textColor = tab.textColor
                }
            }
        }
    }
}

