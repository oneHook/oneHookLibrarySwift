import UIKit
import oneHookLibrary

class MyConversationInputView: ConversationInputView {

    let captureButton = EDButton().apply {
        $0.layoutGravity = [.centerVertical]
        $0.marginEnd = dp(10)
        $0.setImage(
            UIImage.circle(color: .red, diameter: dp(10)),
            for: .normal
        )
        $0.layer.cornerRadius = dp(5)
        $0.layer.masksToBounds = true
    }

    let attachmentButton = EDButton().apply {
        $0.layoutGravity = [.centerVertical]
        $0.marginStart = dp(10)
        $0.setImage(
            UIImage.circle(color: .blue, diameter: dp(10)),
            for: .normal
        )
        $0.layer.cornerRadius = dp(5)
        $0.layer.masksToBounds = true
    }

    let pictureButton = EDButton().apply {
        $0.layoutGravity = [.centerVertical]
        $0.marginStart = dp(10)
        $0.setImage(
            UIImage.circle(color: .blue, diameter: dp(10)),
            for: .normal
        )
        $0.layer.cornerRadius = dp(5)
        $0.layer.masksToBounds = true
    }

    override func commonInit() {
        super.commonInit()
        paddingStart = dp(10)
        paddingEnd = dp(10)
        layer.borderWidth = dp(1)
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = dp(5)
        shouldSkip = true
        addViewBeforeTextView(captureButton)
        addViewAfterTextView(attachmentButton)
        addViewAfterTextView(pictureButton)
    }
}
