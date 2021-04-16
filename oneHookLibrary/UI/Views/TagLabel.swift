import UIKit

open class TagLabel: StackLayout {

    public enum IconPosition {
        case left, right, top, bottom
    }

    public var iconPosition: IconPosition = .left {
        didSet {
            switch iconPosition {
            case .top, .bottom:
                orientation = .vertical
                imageView.layoutGravity = .centerHorizontal
                titleLabel.layoutGravity = .centerHorizontal
            case .left, .right:
                orientation = .horizontal
                imageView.layoutGravity = .centerVertical
                titleLabel.layoutGravity = .centerVertical
            }
            switch iconPosition {
            case .left, .top:
                bringSubviewToFront(titleLabel)
            case .right, .bottom:
                bringSubviewToFront(imageView)
            }
        }
    }

    public lazy var imageView = EDImageView().apply {
        $0.contentMode = .center
        $0.layer.masksToBounds = true
        $0.layoutSize = CGSize(width: dp(14), height: dp(14))
    }

    public let titleLabel = EDLabel().apply {
        $0.textAlignment = .center
        $0.numberOfLines = 0
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
