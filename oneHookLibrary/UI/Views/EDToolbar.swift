import UIKit

public class EDToolbar: BaseView {

    public var contentContainerOffset = UIScreen.statusBarHeight
    public var toolbarHeight = Dimens.toolbarHeightDefaultFixed

    public lazy var backgroundView = optionalBuilder { [weak self] in
        BaseView().apply {
            self?.addSubview($0)
            self?.sendSubviewToBack($0)
        }
    }

    public var contentContainer = FrameLayout().apply { (layout) in
        layout.backgroundColor = .clear
    }

    private lazy var centerContainer = optionalBuilder { [weak self] in
        LinearLayout().apply {
            $0.orientation = .horizontal
            $0.layoutGravity = .center
            $0.marginStart = dp(64)
            $0.marginEnd = dp(64)
            self?.contentContainer.addSubview($0)
        }
    }

    private lazy var labelContainer = optionalBuilder { [weak self] in
        LinearLayout().apply {
            $0.orientation = .vertical
            $0.layoutGravity = .centerVertical
            self?.centerContainer.getOrMake().addSubview($0)
        }
    }

    public lazy var centerImageView = optionalBuilder { [weak self] in
        EDImageView().apply {
            $0.layoutGravity = .centerVertical
            self?.centerContainer.getOrMake().insertSubview($0, at: 0)
            $0.marginEnd = Dimens.marginMedium
        }
    }

    public lazy var centerLabel = optionalBuilder { [weak self] in
        EDLabel().apply {
            $0.layoutGravity = .centerHorizontal
            $0.font = Fonts.bold(Fonts.fontSizeMedium)
            $0.textAlignment = .center
            $0.textColor = .ed_toolbarTextColor
            self?.labelContainer.getOrMake().insertSubview($0, at: 0)
        }
    }

    public lazy var centerSubtitleLabel = optionalBuilder { [weak self] in
        EDLabel().apply {
            $0.layoutGravity = .centerHorizontal
            $0.font = Fonts.regular(Fonts.fontSizeSmall)
            $0.textAlignment = .center
            $0.textColor = .ed_toolbarTextColor
            $0.marginTop = dp(2)
            self?.labelContainer.getOrMake().addSubview($0)
        }
    }

    public lazy var leftLabel = optionalBuilder { [weak self] in
        EDLabel().apply({ (label) in
            label.font = Fonts.bold(Fonts.fontSizeMedium)
            label.textColor = .ed_toolbarTextColor
            label.layoutGravity = [.centerVertical, .start]
            label.marginStart = Dimens.marginMedium
            label.textAlignment = .left
            self?.contentContainer.addSubview(label)
        })
    }

    public lazy var leftNavigationButton = optionalBuilder({  [weak self] in
            ButtonGenerator.navigationButton().apply({ (button) in
                button.marginStart = Dimens.marginMedium
                button.layoutGravity = [.centerVertical, .start]
                self?.contentContainer.addSubview(button)
            })
        }, clearer: { (button) in
            button.removeFromSuperview()
        })

    public lazy var rightNavigationButton = optionalBuilder {  [weak self] in
        ButtonGenerator.navigationButton().apply({ (button) in
            button.marginEnd = Dimens.marginMedium
            button.layoutGravity = [.centerVertical, .end]
            self?.contentContainer.addSubview(button)
        })
    }

    public lazy var divider = optionalBuilder {  [weak self] in
        ViewGenerator.divider().apply({ (divider) in
            divider.layoutGravity = [.bottom, .fillHorizontal]
            divider.layoutSize = CGSize(width: dp(1), height: dp(1))
            self?.contentContainer.addSubview(divider)
        })
    }

    open override func commonInit() {
        super.commonInit()
        backgroundColor = .ed_toolbarBackgroundColor
        addSubview(contentContainer)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.value?.matchParent()
        contentContainer.matchParent(top: contentContainerOffset)
    }

    public override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: contentContainerOffset + toolbarHeight)
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        CGSize(width: size.width,
               height: contentContainerOffset + toolbarHeight)
    }

    public override func setNeedsLayout() {
        centerContainer.value?.setNeedsLayout()
        contentContainer.setNeedsLayout()
        super.setNeedsLayout()
    }
}
