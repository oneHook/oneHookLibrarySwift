import UIKit

public protocol DigitInputViewDelegate: AnyObject {
    func digitInputView(_: DigitInputView, numberDidChange number: String)
}

open class DigitInputView: BaseControl {

    public struct UIModel {
        let pattern: String
        let patternNoDash: String
        let font: UIFont
        let textColorPlaceholder: UIColor
        let textColorNormal: UIColor
        let textBackgroundColor: UIColor
        let borderWidth: CGFloat
        let borderColorNormal: UIColor
        let borderColorHighlight: UIColor
        let cornerRadius: CGFloat
        let spacing: CGFloat
        let dashWidth: CGFloat

        public init(pattern: String,
                    font: UIFont = Fonts.semiBold(dp(24)),
                    textColorPlaceholder: UIColor = .ed_placeholderTextColor,
                    textColorNormal: UIColor = .ed_placeholderTextColor,
                    textBackgroundColor: UIColor = .clear,
                    borderWidth: CGFloat = dp(1),
                    borderColorNormal: UIColor = .ed_cellBackgroundColor,
                    borderColorHighlight: UIColor = .ed_cellBackgroundColorHighlight,
                    cornerRadius: CGFloat = dp(4),
                    spacing: CGFloat = dp(8),
                    dashWidth: CGFloat = dp(10)) {
            self.pattern = pattern
            self.patternNoDash = String(pattern.filter { $0 != "-" })
            self.font = font
            self.textColorPlaceholder = textColorPlaceholder
            self.textColorNormal = textColorNormal
            self.textBackgroundColor = textBackgroundColor
            self.borderWidth = borderWidth
            self.borderColorNormal = borderColorNormal
            self.borderColorHighlight = borderColorHighlight
            self.cornerRadius = cornerRadius
            self.spacing = spacing
            self.dashWidth = dashWidth
        }
    }

    public let uiModel: UIModel

    open weak var delegate: DigitInputViewDelegate? {
        didSet {
            delegate?.digitInputView(self, numberDidChange: rawText)
        }
    }

    private var numberLabels: [EDLabel] = [EDLabel]()
    private var dashes: [BaseView] = [BaseView]()
    private var rawText: String
    private var maxCount: Int = 0
    private var _currentIndex = 0
    private var currentIndex: Int {
        get {
            _currentIndex
        }
        set {
            if _currentIndex >= maxCount {
                _currentIndex = maxCount - 1
            } else {
                _currentIndex = min(newValue, rawText.count)
            }
            invalidate()
        }
    }

    public required init(uiModel: UIModel) {
        self.rawText = ""
        self.uiModel = uiModel
        super.init(frame: .zero)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func commonInit() {
        super.commonInit()

        for char in uiModel.pattern {
            if char.isNumber || char == "X" {
                let numberLabel = EDLabel().apply {
                    $0.adjustsFontSizeToFitWidth = true
                    $0.textColor = uiModel.textColorNormal
                    $0.textAlignment = .center
                    $0.backgroundColor = uiModel.textBackgroundColor
                    $0.layer.borderWidth = uiModel.borderWidth
                    $0.layer.borderColor = uiModel.borderColorNormal.cgColor
                    $0.layer.cornerRadius = uiModel.cornerRadius
                    $0.layer.masksToBounds = true
                }
                numberLabels.append(numberLabel)
                addSubview(numberLabel)
                maxCount += 1
            } else if char == "-" {
                let dash = BaseView()
                dash.backgroundColor = UIColor.white
                dashes.append(dash)
                addSubview(dash)
            } else {
                fatalError("Pattern cannot contain character \(char)")
            }
        }
        invalidate()
        addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(touched(_:))))
    }

    @objc func touched(_ sender: UITapGestureRecognizer) {
        super.becomeFirstResponder()
        if let index = numberLabels.firstIndex(where: {
            $0.frame.contains(sender.location(in: self))
        }) {
            currentIndex = index
        }
        shake()
    }

    @discardableResult
    open override func resignFirstResponder() -> Bool {
        let rv = super.resignFirstResponder()
        invalidate()
        return rv
    }

    @discardableResult
    open override func becomeFirstResponder() -> Bool {
        let rv = super.becomeFirstResponder()
        invalidate()
        return rv
    }

    open override var canBecomeFirstResponder: Bool {
        true
    }

    open override func layoutSubviews() {
        let spacing = uiModel.spacing
        let dashWidth = uiModel.dashWidth
        let numberCount = numberLabels.count
        let dashCount = dashes.count
        let spacingCount = numberCount + dashCount - 1
        let numberWidth = (bounds.width - CGFloat(spacingCount) * spacing - CGFloat(dashCount) * dashWidth) / CGFloat(numberCount)
        let viewHeight = bounds.height

        var i: Int = 0
        var j: Int = 0
        var currX: CGFloat = 0
        for char in uiModel.pattern {
            if char.isNumber || char == "X" {
                let numberView = numberLabels[i]
                numberView.frame = CGRect.init(x: currX, y: 0, width: numberWidth, height: viewHeight)
                i += 1
                currX += numberWidth + spacing
            } else {
                let dashView = dashes[j]
                dashView.frame = CGRect.init(x: currX, y: viewHeight / 2 - 1, width: dashWidth, height: 2)
                j += 1
                currX += dashWidth + spacing
            }
        }
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        CGSize(width: size.width, height: uiModel.font.lineHeight + 2 * Dimens.marginMedium)
    }

    private func invalidate() {
        for (i, numberLabel) in numberLabels.enumerated() {
            if i == currentIndex && isFirstResponder {
                numberLabel.layer.borderColor = uiModel.borderColorHighlight.cgColor
            } else {
                numberLabel.layer.borderColor = uiModel.borderColorNormal.cgColor
            }
        }
        for i in 0..<self.rawText.count {
            numberLabels[i].also {
                $0.text = String(self.rawText[i])
                $0.textColor = uiModel.textColorNormal
            }
        }
        for i in self.rawText.count..<self.numberLabels.count {
            numberLabels[i].also {
                if uiModel.patternNoDash[i] == "X" {
                    numberLabels[i].text = ""
                } else {
                    numberLabels[i].text = String(uiModel.patternNoDash[i])
                }
                $0.textColor = uiModel.textColorPlaceholder
            }

        }
        self.delegate?.digitInputView(
            self,
            numberDidChange: rawText
        )
    }

    open override func invalidateAppearance() {
        for (i, numberLabel) in numberLabels.enumerated() {
            if i == currentIndex && isFirstResponder {
                numberLabel.layer.borderColor = uiModel.borderColorHighlight.cgColor
            } else {
                numberLabel.layer.borderColor = uiModel.borderColorNormal.cgColor
            }
        }
    }
}

extension DigitInputView: UIKeyInput {
    open func insertText(_ text: String) {
        var newText = rawText
        /* at last one */
        if rawText.count == maxCount && currentIndex == maxCount - 1 {
            newText.removeLast()
            rawText = newText + text
            invalidate()
        }

        let remove = rawText.count == maxCount ? 1 : 0
        guard
            let firstPart = rawText.substring(start: 0, offsetBy: currentIndex),
            let secondPart = rawText.substring(
                start: currentIndex,
                offsetBy: max(0, rawText.count - currentIndex - remove)
            ) else {
            return
        }

        rawText = firstPart + text + secondPart
        currentIndex = min(currentIndex + 1, maxCount - 1)
    }

    open func deleteBackward() {
        guard currentIndex > 0 else {
            return
        }
        rawText.remove(at: rawText.index(rawText.startIndex, offsetBy: currentIndex - 1))
        currentIndex -= 1
    }

    public var hasText: Bool {
        false
    }

    public var keyboardType: UIKeyboardType {
        get {
            .numberPad
        }
        set {
            assertionFailure()
        }
    }
}
