import oneHookLibrary
import UIKit

class EGTextFieldDemoViewController: BaseScrollableDemoViewController {


    let textField1 = EGTextField().apply {
        $0.layoutGravity = .fillHorizontal
        $0.font = Fonts.regular(Fonts.fontSizeMedium)
        $0.layer.borderWidth = dp(1)
        $0.layer.borderColor = UIColor.white.cgColor
    }

    let textField2 = EGTextField().apply {
        $0.marginTop = Dimens.marginMedium
        $0.layoutGravity = .fillHorizontal
        $0.layoutSize = CGSize(width: 1, height: dp(50))
        $0.font = Fonts.regular(Fonts.fontSizeLarge)
        $0.layer.borderWidth = dp(1)
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.cornerRadius = Dimens.standardCornerRadius

        $0.paddingStart = Dimens.marginMedium
        $0.paddingEnd = Dimens.marginMedium

        $0.rightContainer.getOrMake().also {
            $0.addSubview(BaseView().apply {
                $0.backgroundColor = .white
                $0.layoutSize = CGSize(width: dp(10), height: dp(10))
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarTitle = "EGTextField View Demo View Controller"

        contentLinearLayout.addSubview(textField1)
        contentLinearLayout.addSubview(textField2)
    }

}
