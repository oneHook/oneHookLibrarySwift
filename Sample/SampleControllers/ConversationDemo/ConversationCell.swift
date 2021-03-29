import UIKit
import oneHookLibrary

class ConversationCell: SelectableTableViewCell {

    private var direction: ConversationItemUIModel.Direction = .left {
        didSet {
            if direction == .left {
                linearLayout.layer.transform = CATransform3DIdentity
                avatarImageView.layer.transform = CATransform3DIdentity
                conversationTextLabel.layer.transform = CATransform3DIdentity
            } else {
                linearLayout.layer.transform = CATransform3DMakeScale(-1, 1, 1)
                avatarImageView.layer.transform = CATransform3DMakeScale(-1, 1, 1)
                conversationTextLabel.layer.transform = CATransform3DMakeScale(-1, 1, 1)
            }
        }
    }

    private let linearLayout = LinearLayout().apply {
        $0.padding = Dimens.marginMedium
        $0.paddingBottom = 0
        $0.orientation = .horizontal
    }

    private let avatarImageView = EDImageView().apply {
        $0.layoutSize = CGSize(width: dp(32), height: dp(32))
        $0.layoutGravity = [.bottom]
        $0.marginEnd = Dimens.marginMedium
        $0.image = UIImage.circle(.red, diameter: dp(12))
        $0.layer.cornerRadius = dp(16)
        $0.layer.masksToBounds = true
    }

    private let conversationTextLabel = EDTextView().apply {
        $0.layoutGravity = [.bottom]
        $0.font = Fonts.regular(Fonts.fontSizeLarge)
        $0.layer.cornerRadius = Dimens.standardCornerRadius
        $0.layer.cornerRadius = dp(6)
        $0.layer.masksToBounds = true
        $0.backgroundColor = .darkGray
        $0.isEditable = false
        $0.textContainerInset = UIEdgeInsets(top: dp(10), left: dp(10), bottom: dp(10), right: dp(10))
        $0.textContainer.lineFragmentPadding = 0
        $0.dataDetectorTypes = .all
        $0.isScrollEnabled = false
    }

    override func commonInit() {
        super.commonInit()
        layer.transform = CATransform3DMakeScale(-1, -1, 1)
        contentView.addSubview(linearLayout.apply {
            $0.addSubview(avatarImageView)
            $0.addSubview(conversationTextLabel)
        })
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        CGSize(
            width: size.width,
            height: linearLayout.sizeThatFits(
                CGSize(width: bounds.width - Dimens.marginXXXLarge,
                       height: CGFloat.greatestFiniteMagnitude
                )
            ).height
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        linearLayout.frame = CGRect(
            origin: direction == .left ? .zero : CGPoint(x: Dimens.marginXXXLarge, y: 0),
            size: CGSize(
                width: bounds.width - Dimens.marginXXXLarge,
                height: bounds.height
            )
        )
    }

    func bind(_ uiModel: ConversationItemUIModel) {
        backgroundColor = UIColor.random()
        direction = uiModel.direction
        conversationTextLabel.text = uiModel.text
        setNeedsLayout()
    }
}
