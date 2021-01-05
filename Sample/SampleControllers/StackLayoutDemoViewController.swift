import UIKit
import oneHookLibrary

class StackLayoutDemoViewController: BaseScrollableDemoViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        toolbarTitle = "StackLayout Demo"

        contentLinearLayout.addSubview(EDLabel.h2().apply {
            $0.text = "Horizontal 0 spacing"
        })
        contentLinearLayout.addSubview(StackLayout().apply {
            $0.orientation = .horizontal
            $0.padding = dp(10)

            for i in 0..<5 {
                $0.addSubview(EDLabel().apply {
                    $0.layoutGravity = [.centerVertical]
                    $0.layoutSize = CGSize(width: dp(50), height: dp(50))
                    $0.layer.cornerRadius = dp(25)
                    $0.layer.masksToBounds = true
                    $0.text = String(i)
                    $0.backgroundColor = UIColor.random()
                    $0.textAlignment = .center
                })
            }
        })

        contentLinearLayout.addSubview(EDLabel.h2().apply {
            $0.marginTop = Dimens.marginMedium
            $0.text = "Horizontal negative spacing"
        })
        contentLinearLayout.addSubview(StackLayout().apply {
            $0.orientation = .horizontal
            $0.padding = dp(10)
            $0.spacing = -dp(15)

            for i in 0..<5 {
                $0.addSubview(EDLabel().apply {
                    $0.layoutGravity = [.centerVertical]
                    $0.layoutSize = CGSize(width: dp(50), height: dp(50))
                    $0.layer.cornerRadius = dp(25)
                    $0.layer.masksToBounds = true
                    $0.text = String(i)
                    $0.backgroundColor = UIColor.random()
                    $0.textAlignment = .center
                })
            }
        })

        contentLinearLayout.addSubview(EDLabel.h2().apply {
            $0.marginTop = Dimens.marginMedium
            $0.text = "Horizontal negative spacing"
        })
        contentLinearLayout.addSubview(StackLayout().apply {
            $0.orientation = .horizontal
            $0.padding = dp(10)
            $0.spacing = -dp(25)

            for i in 0..<5 {
                $0.addSubview(EDLabel().apply {
                    $0.layoutGravity = [.centerVertical]
                    $0.layoutSize = CGSize(width: dp(50), height: dp(50))
                    $0.layer.cornerRadius = dp(25)
                    $0.layer.masksToBounds = true
                    $0.text = String(i)
                    $0.backgroundColor = UIColor.random()
                    $0.textAlignment = .center
                })
            }
        })

        contentLinearLayout.addSubview(EDLabel.h2().apply {
            $0.marginTop = Dimens.marginMedium
            $0.text = "Vertical 0 spacing"
        })
        contentLinearLayout.addSubview(StackLayout().apply {
            $0.orientation = .vertical
            $0.padding = dp(10)
            $0.spacing = -dp(25)

            for i in 0..<5 {
                $0.addSubview(EDLabel().apply {
                    $0.layoutGravity = [.centerVertical]
                    $0.layoutSize = CGSize(width: dp(50), height: dp(50))
                    $0.layer.cornerRadius = dp(25)
                    $0.layer.masksToBounds = true
                    $0.text = String(i)
                    $0.backgroundColor = UIColor.random()
                    $0.textAlignment = .center
                })
            }
        })

        contentLinearLayout.addSubview(EDLabel.h2().apply {
            $0.marginTop = Dimens.marginMedium
            $0.text = "Vertical 10 spacing"
        })
        contentLinearLayout.addSubview(StackLayout().apply {
            $0.orientation = .vertical
            $0.padding = dp(10)
            $0.spacing = dp(10)

            for i in 0..<5 {
                $0.addSubview(EDLabel().apply {
                    $0.layoutGravity = [.centerVertical]
                    $0.layoutSize = CGSize(width: dp(50), height: dp(50))
                    $0.layer.cornerRadius = dp(25)
                    $0.layer.masksToBounds = true
                    $0.text = String(i)
                    $0.backgroundColor = UIColor.random()
                    $0.textAlignment = .center
                })
            }
        })
    }
}
