import UIKit

open class TagLabel: StackLayout {

    public enum IconPosition {
        case left, right
    }

    public var iconPosition: IconPosition = .left {
        didSet {
            switch iconPosition {
            case .left:
                bringSubviewToFront(titleLabel)
            case .right:
                bringSubviewToFront(imageView)
            }
        }
    }

    public lazy var imageView = EDImageView().apply {
        $0.contentMode = .center
        $0.layer.masksToBounds = true
        $0.layoutSize = CGSize(width: dp(14), height: dp(14))
        $0.layoutGravity = .centerVertical
    }

    public let titleLabel = EDLabel().apply {
        $0.textAlignment = .center
        $0.textColor = SharedCustomization.defaultTextBlack
        $0.numberOfLines = 0
        $0.layoutGravity = .centerVertical
    }

    override open func commonInit() {
        super.commonInit()
        orientation = .horizontal
        spacing = dp(7.5)
        contentGravity = .center
        paddingStart = Dimens.marginSmall
        paddingEnd = Dimens.marginSmall
        paddingTop = dp(1.5)
        paddingBottom = dp(1.5)

        backgroundColor = UIColor.clear
        isAccessibilityElement = true
        layer.masksToBounds = true

        addSubview(imageView)
        addSubview(titleLabel)
    }

    public func bind(image: UIImage?, size: CGSize? = nil) {
        imageView.isHidden = image == nil
        imageView.image = image

        if let iconSize = size {
            imageView.layoutSize = iconSize
        } else {
            image.map {
                imageView.layoutSize = $0.size
            }
        }
        setNeedsLayout()
    }
}
