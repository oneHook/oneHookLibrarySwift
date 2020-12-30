import oneHookLibrary
import UIKit

private class SimpleViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}

class ControllerHostDemoViewController: BaseScrollableDemoViewController {

    private var controllerHost: ControllerHostView!

    override func viewDidLoad() {
        super.viewDidLoad()

        toolbarTitle = "ControllerHost"
        controllerHost = ControllerHostView(parentController: self)
        controllerHost.delegate = self
        controllerHost.contentTopMargin = dp(200)

        view.addSubview(controllerHost)

        contentLinearLayout.addSubview(EDButton().apply {
            $0.layoutGravity = [.fillHorizontal]
            $0.tag = 0
            $0.setTitleColor(.black, for: .normal)
            $0.setTitle("Present", for: .normal)
            $0.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        })
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        controllerHost.matchParent()
    }

    @objc private func buttonPressed(sender: UIControl) {
        switch sender.tag {
        case 0:
            controllerHost.present(SimpleViewController())
            break
        default:
            break
        }
    }
}

extension ControllerHostDemoViewController: ControllerHostViewDelegate {

    func controllerStackDidChange() {

    }

    func controllerShouldDismissTapOutside(controller: UIViewController) -> Bool {
        true
    }

    func controllerShouldDismissByDrag(controller: UIViewController, location: CGPoint) -> Bool {
        false
    }
}
