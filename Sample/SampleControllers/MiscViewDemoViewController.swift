import oneHookLibrary
import UIKit

class MiscViewDemoViewController: BaseScrollableDemoViewController {

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

        contentLinearLayout.addSubview(TagLabel().apply {
            $0.layoutGravity = [.centerHorizontal]
            $0.imageView.image = MiscViewDemoViewController.createIcon()
            $0.titleLabel.text = "Eagle"
        })

        contentLinearLayout.addSubview(TagLabel().apply {
            $0.iconPosition = .right
            $0.layoutGravity = [.centerHorizontal]
            $0.imageView.image = MiscViewDemoViewController.createIcon()
            $0.titleLabel.text = "Eagle"
        })

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

        contentLinearLayout.addSubview(EDLabel.h2().apply {
            $0.margin = Dimens.marginMedium
            $0.text = "Radio Button"
        })

        contentLinearLayout.addSubview(RadioButtonView().apply {
            $0.layoutGravity = .centerHorizontal
        })
        contentLinearLayout.addSubview(RadioButtonView().apply {
            $0.marginTop = Dimens.marginMedium
            $0.setImage(UIImage(named: R.Image.ic_checkmark))
            $0.layoutGravity = .centerHorizontal
        })
    }

}
