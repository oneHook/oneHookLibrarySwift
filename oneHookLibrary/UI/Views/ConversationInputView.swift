import UIKit

open class ConversationInputView: LinearLayout {

    public var minimumHeight: CGFloat = dp(50)
    public var maximumHeight: CGFloat = dp(80)
    public var requiresHeight: ((CGFloat) -> Void)?
    public var willSendByEnter: ((String) -> Void)?

    private var scrollView: UIScrollView?
    private var lastTextViewHeight: CGFloat = 0

    private let textView = EDTextView().apply {
        $0.layoutGravity = [.centerVertical]
        $0.layoutWeight = 1
        $0.font = Fonts.regular(Fonts.fontSizeMedium)
        $0.textContainerInset = .zero
        $0.textContainer.lineFragmentPadding = 0
    }

    open override func commonInit() {
        super.commonInit()
        padding = Dimens.marginSmall
        orientation = .horizontal
        backgroundColor = .ed_cellBackgroundColor
        addSubview(textView)
        textView.delegate = self
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        let calculatedHeight = lastTextViewHeight + paddingTop + paddingBottom
        return CGSize(
            width: size.width,
            height: min(maximumHeight, max(minimumHeight, calculatedHeight))
        )
    }

    public func addViewBeforeTextView(_ view: UIView) {
        insertSubview(view, belowSubview: textView)
    }

    public func addViewAfterTextView(_ view: UIView) {
        insertSubview(view, aboveSubview: textView)
    }

    public func clearInput() {
        textView.text = ""
    }
}

extension ConversationInputView: UITextViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollView = scrollView
    }

    public func textViewDidChange(_ textView: UITextView) {
        let measuredSize = textView.sizeThatFits(
            CGSize(width: textView.bounds.width,
                   height: CGFloat.greatestFiniteMagnitude)
        )
        if measuredSize.height != lastTextViewHeight {
            lastTextViewHeight = measuredSize.height
            requiresHeight?(measuredSize.height)

            /* May not need this after all */
//            /* This is to make sure when we type more and reach maximum height,
//               we nicely scroll to the very bottom */
//            if
//                let scrollView = scrollView,
//                measuredSize.height > maximumHeight,
//                textView.selectedRange.location == textView.text.count,
//                textView.selectedRange.length == 0 {
//                UIView.animate(withDuration: .defaultAnimationSmall) {
//                    self.textView.contentOffset = CGPoint(x: 0, y: scrollView.contentSize.height - self.maximumHeight)
//                }
//            }
            setNeedsLayout()
        }
    }

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n",
           let willSendByEnter = willSendByEnter {
            willSendByEnter(textView.text)
            return false
        }
        return true
    }
}
