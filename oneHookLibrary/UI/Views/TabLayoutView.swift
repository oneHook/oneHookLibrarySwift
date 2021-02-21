import UIKit


public struct TabItemUIModel {
    let image: UIImage?
    let imageSelected: UIImage?
    let text: NSAttributedString?
    let spacing: CGFloat
    let orientation: StackLayout.Orientation

    public init(image: UIImage? = nil,
                imageSelected: UIImage? = nil,
                text: NSAttributedString? = nil,
                spacing: CGFloat = dp(8),
                orientation: StackLayout.Orientation = .vertical) {
        self.image = image
        self.imageSelected = imageSelected
        self.text = text
        self.spacing = spacing
        self.orientation = orientation
    }
}

open class TabItemView: FrameLayout {

    public let stackLayout = StackLayout().apply {
        $0.layoutGravity = .center
    }

    public lazy var titleLabel = optionalBuilder {
        EDLabel().apply {
            $0.layoutGravity = [.centerHorizontal, .centerVertical]
            self.stackLayout.addSubview($0)
        }
    }

    private lazy var imageContainer = optionalBuilder {
        FrameLayout().apply {
            $0.layoutGravity = [.centerHorizontal, .centerVertical]
            self.stackLayout.insertSubview($0, at: 0)
        }
    }

    public lazy var imageView = optionalBuilder {
        EDImageView().apply {
            $0.layoutGravity = [.center]
            self.imageContainer.getOrMake().addSubview($0)
        }
    }

    public lazy var imageViewSelected = optionalBuilder {
        EDImageView().apply {
            $0.layoutGravity = [.center]
            self.imageContainer.getOrMake().addSubview($0)
        }
    }

    public convenience init(uiModel: TabItemUIModel) {
        self.init(frame: .zero)
        bind(uiModel)
    }

    open override func commonInit() {
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
            imageView.clear()
        }
        if let imageSelected = uiModel.imageSelected {
            imageViewSelected.getOrMake().image = imageSelected
        } else {
            imageViewSelected.value?.removeFromSuperview()
            imageViewSelected.clear()
        }
        if imageContainer.value?.subviews.count == 0 {
            imageContainer.value?.removeFromSuperview()
            imageContainer.clear()
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
        imageViewSelected.value?.tintColor = color
        if imageViewSelected.value != nil {
            imageView.value?.alpha = progress
            imageViewSelected.value?.alpha = 1 - progress
        }
    }
}

open class TabLayoutView: BaseControl {

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
            _setSelectedIndex(_selectedIndex)
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
        tabView.also {
            _tabViews.append($0)
            addSubview($0)
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tabItemViewTapped(tapRec:))))
        }
        bringSubviewToFront(indicatorView)
        invalidateTabTintColors()
    }

    private var lastWidth: CGFloat = 0
    private var lastHeight: CGFloat = 0
    public override func layoutSubviews() {
        super.layoutSubviews()

        guard lastWidth != bounds.width || lastHeight != bounds.height else {
            return
        }
        let tabCount = CGFloat(_tabViews.count)
        let tabWidth = bounds.width / tabCount
        _tabViews.enumerated().forEach { (index, view) in
            view.frame = CGRect(x: CGFloat(index) * tabWidth, y: 0, width: tabWidth, height: tabHeight)
        }
        _setSelectedIndex(_selectedIndex)
        lastWidth = bounds.width
        lastHeight = bounds.height
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        if layoutSize != CGSize.zero {
            return layoutSize
        }
        return CGSize(
            width: size.width,
            height: tabHeight + paddingBottom
        )
    }

    public func setSelectedIndex(_ index: CGFloat, animated: Bool) {
        _selectedIndex = index
        if animated {
            UIView.animate(withDuration: .defaultAnimation, animations: {
                self._setSelectedIndex(index)
            })
        } else {
            _setSelectedIndex(index)
        }
    }

    private func _setSelectedIndex(_ index: CGFloat) {
        let tabCount = CGFloat(_tabViews.count)
        let tabWidth = bounds.width / tabCount
        indicatorView.bounds = CGRect(origin: .zero, size: CGSize(width: tabWidth, height: indicatorHeight))
        indicatorView.center = CGPoint(x: (index + 0.5) * tabWidth, y: tabHeight - indicatorHeight / 2)

        _tabViews.enumerated().forEach { (viewIndex, view) in
            let offset = CGFloat(viewIndex) - index
            if offset < -1 || offset > 1 {
                view.setColor(tintColorNormal, progress: 1)
            } else {
                view.setColor(
                    UIColor.blend(fromColor: tintColorNormal,
                                  toColor: tintColorHighlight, step: abs(offset)),
                    progress: abs(offset)
                )
            }
        }
    }

    private func invalidateTabTintColors() {
        indicatorView.backgroundColor = indicatorColor ?? tintColorHighlight
    }

    @objc private func tabItemViewTapped(tapRec: UITapGestureRecognizer) {
        guard
            let tabItemView = tapRec.view as? TabItemView,
            let index = tabViews.firstIndex(of: tabItemView) else {
            return
        }
        setSelectedIndex(CGFloat(index), animated: false)
        sendActions(for: .valueChanged)
    }
}
