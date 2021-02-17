import UIKit

open class EGSegmentedControl: BaseView {

    public struct SegmentInfo {
        var title: String
        var normalTextColor: UIColor
        var highlightTextColor: UIColor

        public init(title: String,
                    normalTextColor: UIColor = .darkGray,
                    highlightTextColor: UIColor = .white) {
            self.title = title
            self.normalTextColor = normalTextColor
            self.highlightTextColor = highlightTextColor
        }
    }

    public var defaultHeight: CGFloat = dp(40)
    public var cornerRadius: CGFloat = dp(0) {
        didSet {
            layer.cornerRadius = cornerRadius
            tabCoverView.layer.cornerRadius = cornerRadius
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

    private let tabCoverView = BaseView().apply {
        $0.backgroundColor = .darkGray
    }

    private let bottomLinearLayout = LinearLayout().apply {
        $0.orientation = .horizontal
    }

    private var _tabOffset: CGFloat = 0
    public var selectedIndex: Int {
        let tabWidth = bounds.width / CGFloat(tabCount)
        return Int(_tabOffset / tabWidth)
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
        CGSize(width: size.width, height: defaultHeight)
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
        setSelectedIndex(selectedIndex, animated: false)
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
            x: tabWidth * progress,
            y: 0
        )
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        tabMaskLayer.position = targetPosition
        CATransaction.commit()
        tabCoverView.frame = CGRect(
            origin: targetPosition,
            size: CGSize(width: tabWidth, height: bounds.height)
        )
    }

    public func setSelectedIndex(_ index: Int, animated: Bool) {
        if animated {
            let tabWidth = bounds.width / CGFloat(tabCount)
            let targetPosition = CGPoint(
                x: tabWidth * CGFloat(index),
                y: 0
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
                animations: {
                    self.tabCoverView.frame = CGRect(
                        origin: targetPosition,
                        size: CGSize(width: tabWidth, height: self.bounds.height)
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
}

