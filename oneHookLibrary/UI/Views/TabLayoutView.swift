import UIKit


public struct TabItemUIModel {
    let image: UIImage?
    let text: NSAttributedString?
    let spacing: CGFloat
    let orientation: StackLayout.Orientation

    public init(image: UIImage? = nil,
                text: NSAttributedString? = nil,
                spacing: CGFloat = dp(8),
                orientation: StackLayout.Orientation = .vertical) {
        self.image = image
        self.text = text
        self.spacing = spacing
        self.orientation = orientation
    }
}

public class TabItemView: FrameLayout {

    private let stackLayout = StackLayout().apply {
        $0.layoutGravity = .center
    }

    public lazy var titleLabel = optionalBuilder {
        EDLabel().apply {
            $0.layoutGravity = [.centerHorizontal, .centerVertical]
            self.stackLayout.addSubview($0)
        }
    }

    public lazy var imageView = optionalBuilder {
        EDImageView().apply {
            $0.layoutGravity = [.centerHorizontal, .centerVertical]
            self.stackLayout.insertSubview($0, at: 0)
        }
    }

    public convenience init(uiModel: TabItemUIModel) {
        self.init(frame: .zero)
        bind(uiModel)
    }

    public override func commonInit() {
        super.commonInit()
        addSubview(stackLayout)
    }

    public func bind(_ uiModel: TabItemUIModel) {
        stackLayout.orientation = uiModel.orientation
        stackLayout.spacing = uiModel.spacing
        if let image = uiModel.image {
            imageView.getOrMake().image = image
        } else {
            imageView.value?.removeFromSuperview()
        }
        if let text = uiModel.text {
            titleLabel.getOrMake().attributedText = text
        } else {
            titleLabel.value?.removeFromSuperview()
        }
    }

    public func setColor(_ color: UIColor, progress: CGFloat) {
        titleLabel.value?.textColor = color
        imageView.value?.tintColor = color
    }
}

public class TabLayoutView: BaseControl {

    public var tabHeight = CGFloat(50)

    public var tintColorNormal = UIColor.lightGray {
        didSet {
            invalidateTabTintColors()
        }
    }

    public var tintColorHighlight = UIColor.darkGray {
        didSet {
            invalidateTabTintColors()
        }
    }

    public var indicatorColor: UIColor? {
        didSet {
            invalidateTabTintColors()
        }
    }

    public var indicatorHeight = dp(4) {
        didSet {
            setSelectedIndex(_selectedIndex, animated: false)
        }
    }

    private let indicatorView = BaseView()

    private var _selectedIndex: CGFloat = 0
    public var selectedIndex: CGFloat {
        _selectedIndex
    }

    private var _tabViews = [TabItemView]()
    public var tabViews: [TabItemView] {
        _tabViews
    }


    public override func commonInit() {
        super.commonInit()
        addSubview(indicatorView)
    }

    public func addTab(_ tabView: TabItemView) {
        _tabViews.append(tabView)
        addSubview(tabView)
        bringSubviewToFront(indicatorView)
        invalidateTabTintColors()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        let tabCount = CGFloat(_tabViews.count)
        let tabWidth = bounds.width / tabCount
        _tabViews.enumerated().forEach { (index, view) in
            view.frame = CGRect(x: CGFloat(index) * tabWidth, y: 0, width: tabWidth, height: tabHeight)
        }
        setSelectedIndex(_selectedIndex, animated: false)
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        if layoutSize != CGSize.zero {
            return layoutSize
        }
        return CGSize(
            width: size.width,
            height: tabHeight
        )
    }

    public func setSelectedIndex(_ index: CGFloat, animated: Bool) {
        let tabCount = CGFloat(_tabViews.count)
        let tabWidth = bounds.width / tabCount
        indicatorView.bounds = CGRect(origin: .zero, size: CGSize(width: tabWidth, height: indicatorHeight))
        indicatorView.center = CGPoint(x: (index + 0.5) * tabWidth, y: bounds.height - indicatorHeight / 2)

        _tabViews.enumerated().forEach { (viewIndex, view) in
            let offset = CGFloat(viewIndex) - index
            if offset < -1 || offset > 1 {
                view.setColor(tintColorNormal, progress: 0)
            } else {
                view.setColor(UIColor.blend(fromColor: tintColorNormal, toColor: tintColorHighlight, step: abs(offset)), progress: abs(offset))
            }

        }
    }

    private func invalidateTabTintColors() {
        indicatorView.backgroundColor = indicatorColor ?? tintColorHighlight
    }
}
