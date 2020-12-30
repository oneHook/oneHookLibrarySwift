import UIKit
import oneHookLibrary

class FrameLayoutLayoutDemoViewController: BaseScrollableDemoViewController {

    private func makeLabel() -> EDLabel {
        EDLabel().apply {
            $0.textAlignment = .center
            $0.adjustsFontSizeToFitWidth = true
            $0.padding = Dimens.marginSmall
            $0.backgroundColor = .white
            $0.font = UIFont.systemFont(ofSize: 8)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        toolbarTitle = "FrameLayout Demo"

        contentLinearLayout.addSubview(FrameLayout().apply {
            $0.layoutGravity = [.fillHorizontal]
            $0.layoutSize = CGSize(width: 1, height: dp(150))
            $0.padding = dp(10)
            $0.backgroundColor = .gray

            $0.addSubview(makeLabel().apply {
                $0.text = "Start/Top"
                $0.layoutGravity = [.top, .start]
                $0.marginEnd = Dimens.marginMedium
            })

            $0.addSubview(makeLabel().apply {
                $0.text = "Start/CenterV"
                $0.layoutGravity = [.centerVertical, .start]
                $0.marginEnd = Dimens.marginMedium
            })

            $0.addSubview(makeLabel().apply {
                $0.text = "Start/Bottom"
                $0.layoutGravity = [.bottom, .start]
                $0.marginEnd = Dimens.marginMedium
            })

            $0.addSubview(makeLabel().apply {
                $0.text = "End/Top"
                $0.layoutGravity = [.top, .end]
                $0.marginEnd = Dimens.marginMedium
            })

            $0.addSubview(makeLabel().apply {
                $0.text = "End/CenterV"
                $0.layoutGravity = [.centerVertical, .end]
                $0.marginEnd = Dimens.marginMedium
            })

            $0.addSubview(makeLabel().apply {
                $0.text = "End/Bottom"
                $0.layoutGravity = [.bottom, .end]
                $0.marginEnd = Dimens.marginMedium
            })

            $0.addSubview(makeLabel().apply {
                $0.text = "CenterH/Top"
                $0.layoutGravity = [.centerHorizontal, .top]
                $0.marginEnd = Dimens.marginMedium
            })

            $0.addSubview(makeLabel().apply {
                $0.text = "Center"
                $0.layoutGravity = [.center]
                $0.marginEnd = Dimens.marginMedium
            })

            $0.addSubview(makeLabel().apply {
                $0.text = "CenterH/Bottom"
                $0.layoutGravity = [.centerHorizontal, .bottom]
                $0.marginEnd = Dimens.marginMedium
            })
        })
        


    }
}
