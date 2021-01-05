import oneHookLibrary
import UIKit

private class SimpleViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}

private class SimpleDialogViewController: UIViewController {
    override func loadView() {
        view = FrameLayout()
        view.backgroundColor = .clear
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(FrameLayout().apply {
            $0.backgroundColor = .red
            $0.layer.cornerRadius = Dimens.standardCornerRadius
            $0.layer.masksToBounds = true
            $0.layoutGravity = .center
            $0.layoutSize = CGSize(width: dp(150), height: dp(150))
        })
    }
}

class ControllerHostDemoViewController: BaseScrollableDemoViewController {

    private var controllerHost: ControllerHostView!
    private var topMarginSlider = EDSlider().apply {
        $0.value = 0
        $0.minimumValue = 0
        $0.maximumValue = 500
    }
    private let outsideDismissSwitch = SwitchView().apply {
        $0.isOn = true
    }
    private let dragDismissSwitch = SwitchView().apply {
        $0.isOn = true
    }
    private let blurBackgroundSwitch = SwitchView().apply {
        $0.isOn = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        toolbarTitle = "ControllerHost"
        controllerHost = ControllerHostView(parentController: self)
        controllerHost.delegate = self
        controllerHost.contentTopMargin = dp(200)

        view.addSubview(controllerHost)

        contentLinearLayout.addSubview(StackLayout().apply {
            $0.padding = Dimens.marginMedium
            $0.orientation = .vertical
            $0.spacing = Dimens.marginMedium

            $0.addSubview(EDLabel().apply {
                $0.font = UIFont.boldSystemFont(ofSize: 16)
                $0.text = "Top Margin"
            })

            $0.addSubview(topMarginSlider.apply {
                $0.layoutGravity = [.fillHorizontal]
            })

            $0.addSubview(EDLabel().apply {
                $0.font = UIFont.boldSystemFont(ofSize: 16)
                $0.text = "Allow Tap Outside to Dismiss"
            })
            $0.addSubview(outsideDismissSwitch)

            $0.addSubview(EDLabel().apply {
                $0.font = UIFont.boldSystemFont(ofSize: 16)
                $0.text = "Allow Drag to Dismiss"
            })
            $0.addSubview(dragDismissSwitch)

            $0.addSubview(EDLabel().apply {
                $0.font = UIFont.boldSystemFont(ofSize: 16)
                $0.text = "Show blurred background"
            })
            $0.addSubview(blurBackgroundSwitch)
        })

        contentLinearLayout.addSubview(EDButton().apply {
            $0.layoutGravity = [.fillHorizontal]
            $0.marginTop = Dimens.marginMedium
            $0.tag = 1
            $0.setTitleColor(.black, for: .normal)
            $0.setTitle("Present Dialog", for: .normal)
            $0.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        })

        contentLinearLayout.addSubview(EDButton().apply {
            $0.layoutGravity = [.fillHorizontal]
            $0.tag = 0
            $0.setTitleColor(.black, for: .normal)
            $0.setTitle("Present View Controller", for: .normal)
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
            controllerHost.contentTopMargin = CGFloat(topMarginSlider.value)
            if blurBackgroundSwitch.isOn {
                controllerHost.present(
                    SimpleViewController(),
                    style: .init(blurEffect: .init(style: .regular))
                )
            } else {
                controllerHost.present(SimpleViewController())
            }
        case 1:
            controllerHost.contentTopMargin = 0
            if blurBackgroundSwitch.isOn {
                controllerHost.present(
                    SimpleDialogViewController(),
                    style: .init(blurEffect: .init(style: .regular))
                )
            } else {
                controllerHost.present(SimpleDialogViewController())
            }
        default:
            break
        }
    }
}

extension ControllerHostDemoViewController: ControllerHostViewDelegate {

    func controllerStackDidChange() {

    }

    func controllerShouldDismissTapOutside(controller: UIViewController) -> Bool {
        outsideDismissSwitch.isOn
    }

    func controllerShouldDismissByDrag(controller: UIViewController, location: CGPoint) -> Bool {
        dragDismissSwitch.isOn
    }
}
