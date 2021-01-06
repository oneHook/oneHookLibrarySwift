import oneHookLibrary
import UIKit

class LineGraphDemoViewController: BaseScrollableDemoViewController {

    let graph1 = LineGraphView().apply {
        $0.padding = Dimens.marginMedium
        $0.layer.borderWidth = dp(2)
        $0.layer.borderColor = UIColor.white.cgColor
        $0.setGradientColor(topColor: UIColor.red, bottomColor: UIColor.blue)
    }

    let graph2 = LineGraphView().apply {
        $0.padding = Dimens.marginMedium
        $0.layer.borderWidth = dp(2)
        $0.layer.borderColor = UIColor.white.cgColor
        $0.setGradientColor(topColor: UIColor.red, bottomColor: UIColor.blue)
    }

    let randomButton = EDButton().apply {
        $0.setTitle("Random", for: .normal)
        $0.layoutGravity = [.centerHorizontal]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarTitle = "Line Graph"
        contentLinearLayout.addSubview(graph1)
        contentLinearLayout.addSubview(graph2)
        contentLinearLayout.addSubview(randomButton.apply {
            $0.margin = Dimens.marginLarge
            $0.addTarget(self, action: #selector(randomButtonPressed), for: .touchUpInside)
        })
    }

    @objc private func randomButtonPressed() {
        var numbers = Array.init(repeating: 0, count: 50)
        for i in numbers.indices {
            numbers[i] = Int.random(in: 3..<20)
        }
        
        graph1.uiModel = LineGraphUIModel(
            numbers: numbers,
            minValue: -5,
            maxValue: 25,
            smooth: true
        )
        graph2.uiModel = LineGraphUIModel(
            numbers: numbers,
            minValue: -5,
            maxValue: 25,
            smooth: false
        )
    }
}
