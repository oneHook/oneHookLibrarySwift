import UIKit
import oneHookLibrary

class BaseDemoViewController: UIViewController {

    var toolbarTitle: String = "" {
        didSet {
            toolbar.centerLabel.getOrMake().text = toolbarTitle
        }
    }

    let toolbar = ViewGenerator.toolbar().apply {
        $0.layoutGravity = [.top, .fillHorizontal]
        $0.backgroundColor = UIColor(hex: "F2F2F2")
    }

    override func loadView() {
        view = FrameLayout()
        view.addSubview(toolbar)
     }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
