import UIKit
import oneHookLibrary

class GridLayoutDemoViewController: BaseScrollableDemoViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        toolbarTitle = "StackLayout Demo"

        contentLinearLayout.addSubview(EDLabel.h2().apply {
            $0.text = "Columns 2"
        })
        contentLinearLayout.addSubview(GridLayout().apply {
            $0.padding = dp(10)

            for i in 0..<5 {
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
            $0.text = "Columns 3"
        })
        contentLinearLayout.addSubview(GridLayout().apply {
            $0.padding = dp(10)
            $0.columnCount = 3
            $0.cellHeight = dp(30)

            for i in 0..<7 {
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
            $0.text = "Columns 4 with divider"
        })
        contentLinearLayout.addSubview(GridLayout().apply {
            $0.padding = dp(10)
            $0.columnCount = 4
            $0.cellHeight = dp(50)
            $0.showDivider = true

            for i in 0..<12 {
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
