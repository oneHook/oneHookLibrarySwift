import UIKit

public class RadioButtonView: BaseControl {

    public var borderWidth = dp(2) {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    public var borderSpacing = dp(2) {
        didSet {
            setNeedsLayout()
        }
    }

    public var borderColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    private var _isOn = false
    public var isOn: Bool {
        _isOn
    }

    private lazy var toggleImageView = EDImageView().apply {
        $0.layer.masksToBounds = true
        $0.backgroundColor = borderColor
        $0.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }

    public override func commonInit() {
        super.commonInit()
        layoutSize = CGSize(width: dp(24), height: dp(24))
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapped)))

        addSubview(toggleImageView)
    }

    private var lastWidth: CGFloat = 0
    private var lastHeight: CGFloat = 0
    public override func layoutSubviews() {
        super.layoutSubviews()
        guard bounds.width != lastWidth || bounds.height != lastHeight else {
            return
        }
        layer.cornerRadius = bounds.width / 2
        toggleImageView.frame = bounds.insetBy(dx: borderWidth + borderSpacing, dy: borderWidth + borderSpacing)
        toggleImageView.layer.cornerRadius = toggleImageView.bounds.width / 2
        lastWidth = bounds.width
        lastHeight = bounds.height
        _isOn = !_isOn
        setIsOn(!_isOn, animated: false)
    }

    private func setIsOn(_ value: Bool, animated: Bool) {
        guard _isOn != value else {
            return
        }
        _isOn = value
        sendActions(for: .valueChanged)

        UIView.animate(withDuration: animated ? .defaultAnimationSmall : 0,
                       animations: {
                        let transform: CATransform3D
                        if self._isOn {
                            transform = CATransform3DIdentity
                        } else {
                            transform = CATransform3DMakeScale(0.01, 0.01, 1)
                        }
                        self.toggleImageView.layer.transform = transform
        })
    }

    @objc private func onTapped() {
        setIsOn(!_isOn, animated: true)
    }

    public func setImage(_ image: UIImage?) {
        toggleImageView.image = image
        toggleImageView.contentMode = .center
    }
}
