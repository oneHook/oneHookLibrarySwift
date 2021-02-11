import oneHookLibrary
import UIKit

class EGTextFieldDemoViewController: BaseScrollableDemoViewController {


    let textField1 = EGTextField().apply {
        $0.layoutGravity = .fillHorizontal
        $0.font = Fonts.regular(Fonts.fontSizeMedium)
        $0.layer.borderWidth = dp(1)
        $0.borderColorNormal = UIColor.lightGray
        $0.borderColorHighlight = UIColor.white
        $0.attributedPlaceholder = "Placeholder".attributedString(
            textColor: UIColor.lightGray
        )
    }

    let textField2 = EGTextField().apply {
        $0.marginTop = Dimens.marginMedium
        $0.layoutGravity = .fillHorizontal
        $0.layoutSize = CGSize(width: 1, height: dp(50))
        $0.font = Fonts.regular(Fonts.fontSizeLarge)
        $0.layer.borderWidth = dp(1)
        $0.borderColorNormal = UIColor.lightGray
        $0.borderColorHighlight = UIColor.white
        $0.layer.cornerRadius = Dimens.standardCornerRadius

        $0.paddingStart = Dimens.marginMedium
        $0.paddingEnd = Dimens.marginMedium

        $0.rightContainer.getOrMake().also {
            $0.spacing = dp(10)
            
            $0.addSubview(BaseView().apply {
                $0.backgroundColor = .white
                $0.layoutSize = CGSize(width: dp(10), height: dp(10))
            })

            $0.addSubview(BaseView().apply {
                $0.backgroundColor = .white
                $0.layoutSize = CGSize(width: dp(10), height: dp(10))
            })
        }

        $0.attributedPlaceholder = "Placeholder".attributedString(
            letterSpacing: dp(1), textColor: UIColor.lightGray
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarTitle = "EGTextField View Demo View Controller"

        contentLinearLayout.addSubview(textField1)
        contentLinearLayout.addSubview(textField2)
    }

}
