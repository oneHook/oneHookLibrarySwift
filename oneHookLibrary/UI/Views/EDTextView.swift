import UIKit

open class EDTextView: UITextView, UITextViewDelegate {

    private var _layoutParams: LayoutParams = LayoutParams()
    override open var layoutParams: LayoutParams {
        _layoutParams
    }

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        if layoutSize == CGSize.zero {
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

    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }

    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?

            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }

            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }

    public func setPlaceholderTextColor(_ color: UIColor?) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.textColor = color
        } else {
            addPlaceholder("")
            setPlaceholderTextColor(color)
        }
    }

    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = !self.text.isEmpty
        }
        layoutSubviews()
    }

    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            let labelX = self.textContainerInset.left + dp(4)
            let labelY = self.textContainerInset.top
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        self.resizePlaceholder()
    }

    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()

        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()

        placeholderLabel.font = self.font
        placeholderLabel.textColor = SharedCustomization.defaultTextBlack
        placeholderLabel.tag = 100

        placeholderLabel.isHidden = !self.text.isEmpty

        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
}

