import UIKit
import oneHookLibrary

class BaseDemoViewController: UIViewController {

    var toolbarTitle: String = "" {
        didSet {
            toolbar.centerLabel.getOrMake().text = toolbarTitle
        }
    }

    lazy var toolbar = ViewGenerator.toolbar().apply {
        $0.layoutGravity = [.top, .fillHorizontal]
        $0.centerLabel.getOrMake().textColor = .primaryTextColor
        $0.leftNavigationButton.getOrMake().also {
            $0.setImage(R.Image.ic_arrow_back, for: .normal)
            $0.addTarget(self, action: #selector(onBackTap) , for: .touchUpInside)
        }
    }

    override func loadView() {
        view = FrameLayout()
        view.addSubview(toolbar)
     }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .defaultBackground
    }

    deinit {
        print("DEINIT: \(String(describing: self))")
    }

    @objc private func onBackTap() {
        navigationController?.popViewController(animated: true)
    }
}
