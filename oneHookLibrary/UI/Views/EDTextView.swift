import UIKit

open class EDTextView: UITextView, UITextViewDelegate {

    open override var font: UIFont? {
        didSet {
            placeholderLabel.font = font
        }
    }

    open override var text: String! {
        didSet {
            placeholderLabel.isHidden = !text.isEmpty
            textDidChange?(text)
        }
    }

    public var onFirstResponderStateChanged: ((Bool) -> Void)?
    var textDidChange: ((String) -> Void)?
    var editingDidBegin: (() -> Void)?

    private var _layoutParams: LayoutParams = LayoutParams()
    override open var layoutParams: LayoutParams {
        _layoutParams
    }

    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.textContainer.lineFragmentPadding = 0
        textContainerInset = .zero
        delegate = self
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        if layoutSize == CGSize.zero {
            textContainerInset = UIEdgeInsets(
                top: paddingTop,
                left: paddingStart,
                bottom: paddingBottom,
                right: paddingEnd
            )
            return super.sizeThatFits(size)
        }
        return layoutSize
    }

    open var discardTouchesOutsideTextAttributes = false

    /* Only handle if user's finger is near any attributed-text attributes.
     Used for content that wants to allow touches for dataDetectorTypes, but
     pass through touches for selecting the background.
     */
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard
            !isEditable,
            discardTouchesOutsideTextAttributes else {
            return super.point(inside: point, with: event)
        }
        guard let pos = closestPosition(to: point) else {
            return false
        }
        guard let range = tokenizer.rangeEnclosingPosition(
            pos,
            with: .character,
            inDirection: .layout(.left)
            ) else {
                return false
        }

        let startIndex = offset(from: beginningOfDocument, to: range.start)
        return attributedText.attribute(.link, at: startIndex, effectiveRange: nil) != nil
    }

    lazy var placeholderLabel = EDLabel().apply {
        $0.font = self.font
        $0.textColor = .ed_placeholderTextColor
        $0.isHidden = !text.isEmpty
        addSubview($0)
    }

    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            placeholderLabel.text
        }
        set {
            placeholderLabel.text = newValue
            setNeedsLayout()
        }
    }

    public func setPlaceholderTextColor(_ color: UIColor?) {
        placeholderLabel.textColor = color
    }

    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !text.isEmpty
        textDidChange?(textView.text)
        setNeedsLayout()
    }

    public func textViewDidBeginEditing(_ textView: UITextView) {
        editingDidBegin?()
    }

    open override func layoutSubviews() {
        textContainerInset = UIEdgeInsets(
            top: paddingTop,
            left: paddingStart,
            bottom: paddingBottom,
            right: paddingEnd
        )
        super.layoutSubviews()
        /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
        placeholderLabel.sizeToFit()
        placeholderLabel.frame = CGRect(
            x: paddingStart,
            y: paddingTop,
            width: placeholderLabel.bounds.width,
            height: placeholderLabel.bounds.height
        )
    }

    @discardableResult
    open override func resignFirstResponder() -> Bool {
        let rv = super.resignFirstResponder()
        onFirstResponderStateChanged?(!rv)
        return rv
    }

    @discardableResult
    open override func becomeFirstResponder() -> Bool {
        let rv = super.becomeFirstResponder()
        onFirstResponderStateChanged?(rv)
        return rv
    }
}

