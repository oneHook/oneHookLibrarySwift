import oneHookLibrary
import UIKit

class OdometerDemoViewController: BaseDemoViewController {

    let stackLayout = StackLayout().apply {
        $0.layoutGravity = .center
        $0.orientation = .vertical
        $0.spacing = Dimens.marginMedium
    }

    let odometerLabel = OdometerLabel().apply {
        $0.layoutGravity = .centerHorizontal
        $0.setNumber("0000000000", animated: true)
    }

    let randomButton = EDButton().apply {
        $0.layoutGravity = .centerHorizontal
        $0.padding = Dimens.marginMedium
        $0.setTitle("Random", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        toolbarTitle = "Odometer Label"

        view.addSubview(stackLayout.apply {
            $0.addSubview(odometerLabel)
            $0.addSubview(randomButton)
        })

        randomButton.addTarget(self, action: #selector(randomButtonTap), for: .touchUpInside)
    }

    @objc private func randomButtonTap() {
        let num = Int.random(in: 1000000000..<9999999999)
        odometerLabel.setNumber(String(num), animated: true)
    }
}
