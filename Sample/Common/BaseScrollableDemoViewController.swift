import UIKit
import oneHookLibrary

class BaseScrollableDemoViewController: BaseDemoViewController {

    let scrollView = EDScrollView().apply {
        $0.layoutGravity = [.fill]
    }

    let contentLinearLayout = LinearLayout().apply {
        $0.padding = Dimens.marginLarge
        $0.orientation = .vertical
        $0.layoutGravity = [.fillHorizontal]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.insertSubview(scrollView, belowSubview: toolbar)
        scrollView.addSubview(contentLinearLayout)
        view.backgroundColor = .white
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let size = contentLinearLayout.sizeThatFits(CGSize(width: view.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        contentLinearLayout.frame = CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: size.height))
        scrollView.contentSize = CGSize(width: 1, height: size.height)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentInset = UIEdgeInsets(top: toolbar.bounds.height, left: 0, bottom: 0, right: 0)
    }
}
