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
        $0.centerLabel.getOrMake().textColor = .defaultTextColor
        $0.backgroundColor = .defaultToolbarBackground
    }

    override func loadView() {
        view = FrameLayout()
        view.addSubview(toolbar)
     }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .defaultBackgroundColor
    }

    deinit {
        print("DEINIT: \(String(describing: self))")
    }
}
