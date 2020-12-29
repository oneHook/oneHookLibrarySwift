import UIKit

public class EDToolbar: BaseView {

    public var contentContainerOffset = UIScreen.statusBarHeight
    public var toolbarHeight = Dimens.toolbarHeightDefault

    public var contentContainer = FrameLayout().apply { (layout) in
        layout.backgroundColor = .clear
    }

    private var labelContainer = LinearLayout().apply { (layout) in
        layout.orientation = .vertical
        layout.layoutGravity = .center
        layout.marginStart = dp(64)
        layout.marginEnd = dp(64)
    }

    public lazy var centerLabel = optionalBuilder {
        EDLabel().apply({ (label) in
            label.font = SharedCustomization.boldFont(size: SharedCustomization.fontSizeMedium)
            label.textColor = SharedCustomization.defaultTextBlack
            label.textAlignment = .center
            self.labelContainer.addSubview(label)
        })
    }

    public lazy var leftLabel = optionalBuilder {
        EDLabel().apply({ (label) in
            label.font = SharedCustomization.boldFont(size: SharedCustomization.fontSizeMedium)
            label.textColor = SharedCustomization.defaultTextBlack
            label.layoutGravity = [.centerVertical, .start]
            label.marginStart = Dimens.marginMedium
            label.textAlignment = .left
            self.contentContainer.addSubview(label)
        })
    }

    public lazy var centerSubtitleLabel = optionalBuilder {
        EDLabel().apply({ (label) in
            label.font = SharedCustomization.regularFont(size: SharedCustomization.fontSizeMedium)
            label.textAlignment = .center
            label.textColor = UIColor.black
            label.marginTop = dp(4)
            self.labelContainer.addSubview(label)
        })
    }

    public lazy var leftNavigationButton = optionalBuilder({
            ButtonGenerator.navigationButton().apply({ (button) in
                button.marginStart = dp(9)
                button.layoutGravity = [.centerVertical, .start]
                self.contentContainer.addSubview(button)
            })
        }, clearer: { (button) in
            button.removeFromSuperview()
        })

    public lazy var rightNavigationButton = optionalBuilder {
        ButtonGenerator.navigationButton().apply({ (button) in
            button.marginEnd = Dimens.marginMedium
            button.layoutGravity = [.centerVertical, .end]
            self.contentContainer.addSubview(button)
        })
    }

    public lazy var divider = optionalBuilder {
        ViewGenerator.divider().apply({ (divider) in
            divider.layoutGravity = [.bottom, .fillHorizontal]
            divider.layoutSize = CGSize(width: dp(1), height: dp(1))
            self.contentContainer.addSubview(divider)
        })
    }

    open override func commonInit() {
        super.commonInit()
        backgroundColor = SharedCustomization.defaultBackgroundWhite
        addSubview(contentContainer)
        contentContainer.addSubview(labelContainer)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        contentContainer.matchParent(top: contentContainerOffset)
    }

    public override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: contentContainerOffset + toolbarHeight)
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        CGSize(width: size.width,
               height: contentContainerOffset + toolbarHeight)
    }
}
