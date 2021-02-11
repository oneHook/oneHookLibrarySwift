import oneHookLibrary
import UIKit

class DigitInputViewDemoViewController: BaseScrollableDemoViewController, DigitInputViewDelegate {

    let digitInputView1 = DigitInputView(uiModel: .init(
        pattern: "XXX-XXX-XXXX",
        borderColorNormal: .white,
        borderColorHighlight: .red
    ))
    let digitInputView2 = DigitInputView(uiModel: .init(
        pattern: "123456",
        textColorPlaceholder: .darkGray,
        borderColorNormal: .lightGray,
        borderColorHighlight: .darkGray
    ))

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarTitle = "Digit Input View Demo View Controller"

        contentLinearLayout.addSubview(digitInputView1.apply {
            $0.layoutSize = CGSize(width: 0, height: dp(100))
            $0.layoutGravity = [.fillHorizontal]
        })

        contentLinearLayout.addSubview(digitInputView2.apply {
            $0.marginTop = Dimens.marginMedium
            $0.layoutSize = CGSize(width: 0, height: dp(50))
            $0.layoutGravity = [.fillHorizontal]
        })

        digitInputView1.delegate = self
        digitInputView2.delegate = self

        digitInputView1.becomeFirstResponder()
    }

    func digitInputView(_: DigitInputView, numberDidChange number: String) {
        print("XXX", number)
    }
}
