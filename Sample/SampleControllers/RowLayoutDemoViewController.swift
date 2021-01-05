import UIKit
import oneHookLibrary

class RowLayoutDemoViewController: BaseScrollableDemoViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        toolbarTitle = "RowLayout Demo"

        contentLinearLayout.addSubview(EDLabel.h2().apply {
            $0.margin = Dimens.marginMedium
            $0.text = "Column 2"
        })
        contentLinearLayout.addSubview(RowLayout().apply {
            $0.padding = dp(10)

            for i in 0..<2 {
                $0.addSubview(EDLabel().apply {
                    $0.paddingTop = Dimens.marginMedium
                    $0.paddingBottom = Dimens.marginMedium
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
        contentLinearLayout.addSubview(RowLayout().apply {
            $0.padding = dp(10)

            for i in 0..<3 {
                $0.addSubview(EDLabel().apply {
                    $0.paddingTop = Dimens.marginMedium
                    $0.paddingBottom = CGFloat.random(in: Dimens.marginMedium..<Dimens.marginXXLarge)
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
