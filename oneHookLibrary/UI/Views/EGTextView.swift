import UIKit

open class EGTextView: BaseControl {

    public let textView = EDTextView()
    private lazy var borderLayer = CAShapeLayer().apply {
        $0.fillColor = nil
        $0.strokeColor = colorNormal?.cgColor
        $0.lineWidth = borderWidth
    }

    public var cornerRadius: CGFloat = dp(8) {
        didSet {
            if bounds.size != .zero {
                invalidateBorder()
                invalidateBorderProgress()
            }
        }
    }

    public var borderWidth: CGFloat = dp(1) {
        didSet {
            borderLayer.lineWidth = borderWidth
        }
    }

    public var colorNormal: UIColor? {
        didSet {
            invalidate()
        }
    }

    public var colorActive: UIColor? {
        didSet {
            invalidate()
        }
    }

    public var floatingPlaceholderTitle: String? {
        didSet {
            invalidateFloatingPlaceholder()
        }
    }

    public lazy var floatingPlaceholder = optionalBuilder {
        EDLabel().apply {
            $0.font = Fonts.semiBold(Fonts.fontSizeSmall)
            $0.textColor = self.colorActive ?? self.colorNormal
            self.addSubview($0)
        }
    }

    public var onFirstResponderStateChanged: ((Bool) -> Void)?

    open override func commonInit() {
        super.commonInit()
        addSubview(textView)
        padding = dp(10)
        textView.font = Fonts.regular(Fonts.fontSizeMedium)
        layer.addSublayer(borderLayer)
        textView.onFirstResponderStateChanged = { [weak self] (_) in
            self?.invalidate()
        }
        textView.textDidChange = { [weak self] (_) in
            self?.textViewDidChange()
            self?.invalidate()
            self?.sendActions(for: .editingChanged)
        }
        textView.editingDidBegin = { [weak self] in
            self?.sendActions(for: .editingDidBegin)
        }
    }

    private func invalidate() {
        if textView.isFirstResponder {
            floatingPlaceholder.value?.textColor = colorActive ?? colorNormal
            borderLayer.strokeColor = (colorActive ?? colorNormal)?.cgColor
        } else {
            floatingPlaceholder.value?.textColor = colorNormal
            borderLayer.strokeColor = colorNormal?.cgColor
        }
    }

    open func textViewDidChange() {
        if textView.text.isNilOrEmpty {
            UIView.animate(withDuration: .defaultAnimationSmall, animations: {
                self.floatingPlaceholder.value?.alpha = 0
            })
        } else {
            floatingPlaceholder.getOrMake()
            invalidateFloatingPlaceholder()
            UIView.animate(withDuration: .defaultAnimationSmall, animations: {
                self.floatingPlaceholder.value?.alpha = 1
            })
            layoutFloatinPlaceholder()
        }
        invalidateBorderProgress()
    }

    private var lastWidth: CGFloat = 0
    private var lastHeight: CGFloat = 0
    open override func layoutSubviews() {
        super.layoutSubviews()
        textView.matchParent(
            top: paddingTop,
            left: paddingStart,
            bottom: paddingBottom,
            right: paddingEnd
        )
        guard lastWidth != bounds.width || lastHeight != bounds.height else {
            return
        }
        lastWidth = bounds.width
        lastHeight = bounds.height
        invalidateBorder()
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        if layoutSize != .zero {
            return layoutSize
        }
        let size = textView.sizeThatFits(
            CGSize(
                width: size.width - paddingStart - paddingEnd,
                height: size.height - paddingTop - paddingBottom
            )
        )
        return CGSize(
            width: size.width + paddingStart + paddingEnd,
            height: size.height + paddingTop + paddingBottom
        )
    }

    private func layoutFloatinPlaceholder() {
        floatingPlaceholder.value?.also {
            $0.sizeToFit()
            $0.frame = CGRect(origin: CGPoint(x: paddingStart,
                                              y: -$0.bounds.size.height / 2),
                              size: $0.bounds.size)
        }
    }

    private func invalidateBorder() {
        let path = CGMutablePath()
        path.move(to: .init(x: paddingStart, y: 0))
        path.addLine(to: .init(x: bounds.width - cornerRadius, y: 0))
        path.addArc(center: .init(x: bounds.width - cornerRadius, y: cornerRadius),
                    radius: cornerRadius,
                    startAngle: -CGFloat.pi / 2,
                    endAngle: 0,
                    clockwise: false)
        path.addLine(to: .init(x: bounds.width, y: bounds.height - cornerRadius))
        path.addArc(center: .init(x: bounds.width - cornerRadius, y: bounds.height - cornerRadius),
                    radius: cornerRadius,
                    startAngle: 0,
                    endAngle: CGFloat.pi / 2,
                    clockwise: false)
        path.addLine(to: .init(x: cornerRadius, y: bounds.height))
        path.addArc(center: .init(x: cornerRadius, y: bounds.height - cornerRadius),
                    radius: cornerRadius,
                    startAngle: CGFloat.pi / 2,
                    endAngle: CGFloat.pi,
                    clockwise: false)
        path.addLine(to: .init(x: 0, y: cornerRadius))
        path.addArc(center: .init(x: cornerRadius, y: cornerRadius),
                    radius: cornerRadius,
                    startAngle: CGFloat.pi,
                    endAngle: -CGFloat.pi / 2,
                    clockwise: false
        )
        path.addLine(to: .init(x: paddingStart, y: 0))

        borderLayer.path = path
        invalidateBorderProgress()
    }

    private func invalidateBorderProgress() {
        guard
            let placeholderLabel = floatingPlaceholder.value,
            placeholderLabel.alpha > 0  else {
            borderLayer.strokeStart = 0
            borderLayer.strokeEnd = 1
            return
        }
        let perimeter = bounds.width * 2 + bounds.height * 2 - 8 * cornerRadius + CGFloat.pi * cornerRadius * 2
        borderLayer.strokeStart = (placeholderLabel.bounds.width + Dimens.marginSmall) / perimeter
        borderLayer.strokeEnd = 1 - Dimens.marginSmall / perimeter
    }

    private func invalidateFloatingPlaceholder() {
        floatingPlaceholder.value?.text = floatingPlaceholderTitle ?? textView.placeholder
    }
}
