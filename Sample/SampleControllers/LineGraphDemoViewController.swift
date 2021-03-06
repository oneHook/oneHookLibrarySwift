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
        $0.marginTop = Dimens.marginLarge
        $0.setGradientColor(topColor: UIColor.red, bottomColor: UIColor.black)
    }

    let graph3 = LineGraphView().apply {
        $0.marginTop = Dimens.marginLarge
        $0.isOutlineVisible = false
        $0.setGradientColor(topColor: UIColor.green, bottomColor: UIColor.red)
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
        contentLinearLayout.addSubview(graph3)
        contentLinearLayout.addSubview(randomButton.apply {
            $0.margin = Dimens.marginLarge
            $0.addTarget(self, action: #selector(randomButtonPressed), for: .touchUpInside)
        })

        randomButtonPressed()
    }

    @objc private func randomButtonPressed() {
        var numbers = Array.init(repeating: 0, count: 20)
        for i in numbers.indices {
            numbers[i] = Int.random(in: 3..<20)
        }

        let graphs = [graph1, graph2, graph3]
        for (index, graph) in graphs.enumerated() {
            graph.bind(LineGraphUIModel(
                numbers: numbers,
                minValue: -5,
                maxValue: 25,
                smooth: index % 2 == 0
            ), animated: true)
        }
    }
}
