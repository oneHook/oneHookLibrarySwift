import oneHookLibrary
import UIKit

class ToolbarDemoViewController: BaseScrollableDemoViewController {

    private static func createIcon() -> UIImage {
        UIImage.solid(
            color: .white,
            size: CGSize(width: dp(10), height: dp(10))
        ).withRenderingMode(.alwaysTemplate)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarTitle = "Toolbar Demo View Controller"

        contentLinearLayout.addSubview(EDToolbar().apply {
            $0.backgroundColor = .blue
            $0.contentContainerOffset = 0
            $0.centerLabel.getOrMake().text = "Only Center Text"
        })

        contentLinearLayout.addSubview(EDToolbar().apply {
            $0.marginTop = Dimens.marginMedium
            $0.backgroundColor = .blue
            $0.contentContainerOffset = 0
            $0.centerLabel.getOrMake().text = "Center Text"
            $0.centerSubtitleLabel.getOrMake().text = "and subtitle"
        })

        contentLinearLayout.addSubview(EDToolbar().apply {
            $0.marginTop = Dimens.marginMedium
            $0.backgroundColor = .blue
            $0.contentContainerOffset = 0
            $0.centerLabel.getOrMake().text = "Center Text"
            $0.centerSubtitleLabel.getOrMake().marginTop = 0
            $0.centerSubtitleLabel.getOrMake().text = "and subtitle"
            $0.centerImageView.getOrMake().image = Self.createIcon()
        })

        contentLinearLayout.addSubview(EDToolbar().apply {
            $0.marginTop = Dimens.marginMedium
            $0.backgroundColor = .blue
            $0.contentContainerOffset = 0
            $0.centerLabel.getOrMake().text = "Only Center Text"
            $0.centerImageView.getOrMake().image = Self.createIcon()
        })

        contentLinearLayout.addSubview(EDToolbar().apply {
            $0.marginTop = Dimens.marginMedium
            $0.backgroundColor = .blue
            $0.contentContainerOffset = 0
            $0.centerLabel.getOrMake().text = "Only Center Text"
            $0.centerImageView.getOrMake().image = Self.createIcon()
            $0.leftNavigationButton.getOrMake().setImage(Self.createIcon(), for: .normal)
            $0.rightNavigationButton.getOrMake().setImage(Self.createIcon(), for: .normal)
        })
    }

}
