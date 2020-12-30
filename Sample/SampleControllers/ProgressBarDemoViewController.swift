import oneHookLibrary
import UIKit

class ProgressBarDemoViewController: BaseScrollableDemoViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        toolbarTitle = "Progress Bar"

        contentLinearLayout.addSubview(
            ProgressBar().apply {
                $0.mainProgressColor = .red
                $0.subProgressColor = .blue
                $0.progressCornerRadius = dp(8)
                $0.layoutGravity = [.centerHorizontal]
                $0.layoutSize = CGSize(width: dp(200), height: dp(16))
                $0.mainProgress = 0.4
                $0.subProgress = 1.0
            }
        )
    }
}
