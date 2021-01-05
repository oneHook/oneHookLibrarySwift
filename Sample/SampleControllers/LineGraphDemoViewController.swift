import oneHookLibrary
import UIKit

class LineGraphDemoViewController: BaseScrollableDemoViewController {

    let graph = LineGraphView().apply {
        $0.padding = Dimens.marginMedium
        $0.layer.borderWidth = dp(2)
        $0.layer.borderColor = UIColor.white.cgColor
        $0.setGradientColor(topColor: UIColor.red, bottomColor: UIColor.blue)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarTitle = "Line Graph"
        contentLinearLayout.addSubview(graph)

        graph.uiModel = LineGraphUIModel(
            numbers: [1, 2, 5, 6, 8, 5, 4, 2, 4, 2, 1, 5],
            minValue: -5,
            maxValue: 10
        )
    }
}
