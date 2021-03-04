import oneHookLibrary
import UIKit

class ImageExtensionDemoViewController: BaseScrollableDemoViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarTitle = "Image Extension"

        for i in 0..<10 {
            contentLinearLayout.addSubview(EDImageView().apply {
                $0.layoutGravity = .centerHorizontal
                $0.layoutSize = CGSize(width: dp(200), height: dp(200))
                $0.image = UIImage(named: "ic_emoji")?.alpha(0.1 * CGFloat(i))
                $0.tintColor = UIColor.red
            })
        }

    }

}
