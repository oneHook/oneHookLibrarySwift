import UIKit

open class EDButton: UIButton {

    public enum IconPosition {
        case top
        case bottom
        case left
        case right
        case fill
        case none
    }

    public var iconSize: CGSize?

    public var iconPosition: IconPosition = .none {
        didSet {
            setNeedsLayout()
        }
    }

    public var iconOffset: CGPoint = CGPoint.zero {
        didSet {
            setNeedsLayout()
        }
    }

    public var iconPadding: CGFloat = Dimens.marginMedium {
        didSet {
            setNeedsLayout()
        }
    }

    public var titleYOffset: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    /// Expand the tap area of a view. Negative edge insets enlarge the tap area.
    public var hitTestEdgeInsets: UIEdgeInsets = .zero

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    open func commonInit() {

    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        /* Only do custom layout if both image view and title label present */
        guard
            let imageView = self.imageView,
            let titleLabel = self.titleLabel,
            iconPosition != .none else {
                return
        }
        let width = self.bounds.width
        let height = self.bounds.height
        if width == 0 || height == 0 {
            return
        }
        titleLabel.sizeToFit()
        if let iconSize = iconSize {
            imageView.bounds = CGRect(origin: .zero, size: iconSize)
        } else {
            imageView.sizeToFit()
        }

        let imageWidth = imageView.bounds.width
        let imageHeight = imageView.bounds.height
        var textWidth = titleLabel.bounds.width
        let textHeight = titleLabel.bounds.height
        let centerX: CGFloat = width / 2
        let centerY: CGFloat = height / 2

        /* Do not have icon padding if no title or no image */
        let iconPadding = (textWidth > 0 && textHeight > 0 && imageWidth > 0 && imageHeight > 0) ? self.iconPadding : 0

        if self.iconPosition == .left {
            textWidth = min(bounds.width - imageWidth - iconPadding - paddingStart - paddingEnd, textWidth)
            titleLabel.bounds = CGRect(origin: .zero, size: CGSize(width: textWidth, height: textHeight))
            titleLabel.center = CGPoint(x: centerX + (imageWidth + iconPadding) / 2,
                                        y: centerY + self.titleYOffset)
            imageView.center = CGPoint(x: centerX - (textWidth + iconPadding) / 2 + iconOffset.x,
                                       y: centerY + iconOffset.y)
        } else if self.iconPosition == .right {
            textWidth = min(bounds.width - imageWidth - iconPadding - paddingStart - paddingEnd, textWidth)
            titleLabel.bounds = CGRect(origin: .zero, size: CGSize(width: textWidth, height: textHeight))
            titleLabel.center = CGPoint(x: centerX - (imageWidth + iconPadding) / 2,
                                        y: centerY + self.titleYOffset)
            imageView.center = CGPoint(x: centerX + (textWidth + iconPadding) / 2 + iconOffset.x,
                                       y: centerY + iconOffset.y)
        } else if self.iconPosition == .top {
            titleLabel.center = CGPoint(x: centerX,
                                        y: centerY + (imageHeight + iconPadding) / 2 + self.titleYOffset)
            imageView.center = CGPoint(x: centerX + iconOffset.x,
                                       y: centerY - (textHeight + iconPadding) / 2 + iconOffset.y)
        } else if self.iconPosition == .bottom {
            titleLabel.center = CGPoint(x: centerX,
                                        y: centerY - (imageHeight + iconPadding) / 2 + self.titleYOffset)
            imageView.center = CGPoint(x: centerX + iconOffset.x,
                                       y: centerY + (textHeight + iconPadding) / 2 + iconOffset.y)
        } else if self.iconPosition == .fill {
            titleLabel.matchParent()
            imageView.matchParent()
        }
    }

    private var _layoutParams: LayoutParams = LayoutParams()
    override open var layoutParams: LayoutParams {
        _layoutParams
    }

    open override func sizeToFit() {
        let size = sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                       height: CGFloat.greatestFiniteMagnitude))
        self.bounds = CGRect(origin: .zero, size: size)
    }

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        guard layoutSize == CGSize.zero else {
            return layoutSize
        }
        /* let super class measure it first, UILabel by default
         will measure the button size as if the image is put on horizontal */
        var superSize = super.sizeThatFits(size)
        /* If we know we have an image for this button, we need modify the
         measured size based on our actual position of the image */
        if let imageSize = image(for: state)?.size,
            imageSize.width > 0,
            imageSize.height > 0,
            !(titleLabel?.text ?? "").isEmpty {
            switch iconPosition {
            case .bottom, .top:
                /* If put on top/bottom, we should reduce super width */
                superSize.width -= imageSize.width
                superSize.height += iconPadding + imageSize.height
            case .left, .right:
                /* if put on left/right, we only need to add in additional icon padding */
                superSize.width += iconPadding
            default:
                break
            }
        }
        /* Also add in padding */
        superSize.width += paddingStart + paddingEnd
        superSize.height += paddingTop + paddingBottom
        return superSize
    }

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard
            hitTestEdgeInsets != .zero,
            !isHidden else {
            return super.point(inside: point, with: event)
        }

        return bounds.inset(by: hitTestEdgeInsets).contains(point)
    }
}

public extension UIButton {
    func imageInsets(for state: UIControl.State) -> UIEdgeInsets {
        guard let image = image(for: state) else {
            return .zero
        }

        return UIEdgeInsets(top: (frame.height - image.size.height) / 2,
                            left: (frame.width - image.size.width) / 2,
                            bottom: (frame.height - image.size.height) / 2,
                            right: (frame.width - image.size.width) / 2)
    }
}
