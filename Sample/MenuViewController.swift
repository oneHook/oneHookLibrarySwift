import UIKit
import oneHookLibrary

class MenuViewController: UIViewController {

    let toolbar = ViewGenerator.toolbar().apply {
        $0.layoutGravity = [.top, .fillHorizontal]
        $0.centerLabel.getOrMake().text = "Sample"
        $0.backgroundColor = .lightGray
    }

    override func loadView() {
        view = FrameLayout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(toolbar)
    }

}

