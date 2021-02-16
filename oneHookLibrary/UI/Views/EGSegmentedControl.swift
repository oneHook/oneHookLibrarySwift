import UIKit

open class EGSegmentedControl: BaseControl {

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

    private let topLinearLayout = LinearLayout().apply {
        $0.orientation = .horizontal
    }

    private let tabMaskLayer = CALayer().apply {
        $0.backgroundColor = UIColor.white.cgColor
    }

    private let tabCoverView = BaseView().apply {
        $0.backgroundColor = .darkGray
    }

    private let bottomLinearLayout = LinearLayout().apply {
        $0.orientation = .horizontal
    }

    var tabOffset: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
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
        tabOffset = CGFloat(tabIndex)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        topLinearLayout.matchParent()
        bottomLinearLayout.matchParent()
        let tabWidth = bounds.width / CGFloat(tabCount)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        tabMaskLayer.frame = CGRect(x: tabOffset * tabWidth,
                                    y: 0,
                                    width: tabWidth,
                                    height: bounds.height)
        CATransaction.commit()
        tabCoverView.frame = tabMaskLayer.frame
    }

    private func makeTab() -> EDLabel {
        EDLabel().apply {
            $0.font = Fonts.bold(Fonts.fontSizeSmall)
            $0.textAlignment = .center
            $0.layoutGravity = [.fillVertical]
            $0.layoutWeight = 1
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

