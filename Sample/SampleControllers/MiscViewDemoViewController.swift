import oneHookLibrary
import UIKit

class MiscViewDemoViewController: BaseScrollableDemoViewController {

    let tagLabel = TagLabel().apply {
        $0.layoutGravity = [.centerHorizontal]
        $0.imageView.image = MiscViewDemoViewController.createIcon()
        $0.titleLabel.text = "Eagle"
    }

    private static func createIcon() -> UIImage {
        UIImage(color: .blue,
                size: CGSize(width: dp(10), height: dp(10)))!.withRenderingMode(.alwaysTemplate)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarTitle = "Misc View Demo View Controller"


        contentLinearLayout.addSubview(EDLabel.h2().apply {
            $0.margin = Dimens.marginMedium
            $0.text = "TagLabel"
        })

        contentLinearLayout.addSubview(tagLabel)

        contentLinearLayout.addSubview(EDLabel.h2().apply {
            $0.margin = Dimens.marginMedium
            $0.text = "SwitchView"
        })

        contentLinearLayout.addSubview(SwitchView().apply {
            $0.layoutGravity = .centerHorizontal
            $0.circleNormalColor = .red
            $0.backgroundNormalColor = .white
            $0.circleHighlightColor = .yellow
            $0.backgroundHighlightColor = .blue
        })
    }

}
