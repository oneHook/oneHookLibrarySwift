import UIKit

public class SwitchView: BaseControl {

    public var strokeHighlightColor = UIColor.black {
        didSet {
            invalidate()
        }
    }

    public var backgroundHighlightColor = UIColor.white {
        didSet {
            invalidate()
        }
    }

    public var circleHighlightColor = UIColor.black {
        didSet {
            invalidate()
        }
    }

    public var strokeNormalColor = UIColor.gray {
        didSet {
            invalidate()
        }
    }

    public var backgroundNormalColor = UIColor.white {
        didSet {
            invalidate()
        }
    }

    public var circleNormalColor = UIColor.gray {
        didSet {
            invalidate()
        }
    }

    private var isOnInternal: Bool = false
    public var isOn: Bool {
        get {
            isOnInternal
        }
        set {
            if isOnInternal != newValue {
                isOnInternal = newValue
                invalidate()
                sendActions(for: .valueChanged)
            }
        }
    }

    public var spacing: CGFloat = dp(3)

    private let toggleLayer = CAShapeLayer()

    override public func commonInit() {
        super.commonInit()

        layer.borderWidth = dp(1)
        isOn = false
        layoutSize = CGSize(width: dp(56), height: dp(26))
        layer.addSublayer(toggleLayer)

        addTarget(self, action: #selector(onTap), for: .touchUpInside)
    }

    @objc func onTap() {
        isOn = !isOn
    }

    private func invalidate() {
        if isOn {
            layer.borderColor = strokeHighlightColor.cgColor
            toggleLayer.backgroundColor = circleHighlightColor.cgColor
            backgroundColor = backgroundHighlightColor
        } else {
            layer.borderColor = strokeNormalColor.cgColor
            toggleLayer.backgroundColor = circleNormalColor.cgColor
            backgroundColor = backgroundNormalColor
        }
        moveToggle()
    }

    public override func invalidateAppearance() {
        invalidate()
    }

    public override func sizeToFit() {
        bounds = CGRect(origin: .zero, size: layoutSize)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        let length = bounds.height - spacing * 2
        CATransaction.setDisableActions(true)
        toggleLayer.bounds = CGRect(origin: .zero, size: CGSize(width: length, height: length))
        toggleLayer.cornerRadius = length / 2
        CATransaction.setDisableActions(false)
    }

    public override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        CATransaction.setDisableActions(true)
        moveToggle()
        CATransaction.setDisableActions(false)
    }

    private func moveToggle() {
        if isOnInternal {
            toggleLayer.position = CGPoint(x: bounds.width - spacing - toggleLayer.bounds.width / 2 - dp(1),
                                           y: spacing + toggleLayer.bounds.height / 2)
        } else {
            toggleLayer.position = CGPoint(x: spacing + toggleLayer.bounds.width / 2 + dp(1),
                                           y: spacing + toggleLayer.bounds.height / 2)
        }
    }
}
