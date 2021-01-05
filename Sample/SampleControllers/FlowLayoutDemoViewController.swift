import UIKit
import oneHookLibrary

class FlowLayoutDemoViewController: BaseScrollableDemoViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        toolbarTitle = "FlowLayout Demo"

        contentLinearLayout.addSubview(EDLabel.h2().apply {
            $0.margin = Dimens.marginMedium
            $0.text = "Fill Horizontal Flow Layout"
        })
        contentLinearLayout.addSubview(FlowLayout().apply {
            $0.layoutGravity = [.fillHorizontal]
            $0.backgroundColor = UIColor(white: 0, alpha: 0.1)
            $0.padding = dp(10)

            for _ in 0..<20 {
                $0.addSubview(EDLabel().apply {
                    $0.padding = dp(5)
                    $0.paddingStart = dp(10)
                    $0.paddingEnd = dp(10)
                    $0.layoutGravity = [.centerVertical]
                    $0.text = random_country_name()
                    $0.layer.cornerRadius = dp(2)
                    $0.layer.masksToBounds = true
                    $0.backgroundColor = UIColor.random()
                    $0.textAlignment = .center
                })
            }
        })

        contentLinearLayout.addSubview(EDLabel.h2().apply {
            $0.margin = Dimens.marginMedium
            $0.text = "Wrap Content Flow Layout"
        })
        contentLinearLayout.addSubview(FlowLayout().apply {
            $0.backgroundColor = UIColor(white: 0, alpha: 0.1)
            $0.padding = dp(10)
            $0.horizontalSpacing = dp(15)
            $0.verticalSpacing = dp(15)

            for _ in 0..<20 {
                $0.addSubview(EDLabel().apply {
                    $0.padding = dp(5)
                    $0.paddingStart = dp(10)
                    $0.paddingEnd = dp(10)
                    $0.layoutGravity = [.centerVertical]
                    $0.text = random_country_name()
                    $0.layer.cornerRadius = dp(2)
                    $0.layer.masksToBounds = true
                    $0.backgroundColor = UIColor.random()
                    $0.textAlignment = .center
                })
            }
        })
    }
}
