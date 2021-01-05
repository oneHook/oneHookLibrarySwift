import UIKit
import oneHookLibrary

class EqualWeightLayoutDemoViewController: BaseScrollableDemoViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        toolbarTitle = "EqualWeightLayout Demo"

        contentLinearLayout.addSubview(EDLabel.h2().apply {
            $0.margin = Dimens.marginMedium
            $0.text = "Column 2"
        })
        contentLinearLayout.addSubview(EqualWeightLayout().apply {
            $0.padding = dp(10)

            for i in 0..<2 {
                $0.addSubview(EDLabel().apply {
                    $0.layoutGravity = [.centerVertical]
                    $0.layer.masksToBounds = true
                    $0.text = String(i)
                    $0.backgroundColor = UIColor.random()
                    $0.textAlignment = .center
                })
            }
        })

        contentLinearLayout.addSubview(EDLabel.h2().apply {
            $0.margin = Dimens.marginMedium
            $0.text = "Column 3"
        })
        contentLinearLayout.addSubview(EqualWeightLayout().apply {
            $0.padding = dp(10)
            $0.cellHeight = dp(50)
            $0.dividerTopBottomPadding = 0
            $0.showDivider = true

            for i in 0..<3 {
                $0.addSubview(EDLabel().apply {
                    $0.layoutGravity = [.centerVertical]
                    $0.layer.masksToBounds = true
                    $0.text = String(i)
                    $0.backgroundColor = UIColor.random()
                    $0.textAlignment = .center
                })
            }
        })


    }
}
