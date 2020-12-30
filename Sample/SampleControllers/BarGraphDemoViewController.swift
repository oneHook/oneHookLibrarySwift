import oneHookLibrary
import UIKit

class BarGraphDemoViewController: BaseScrollableDemoViewController {

    let barGraph = BarGraphView().apply {
        $0.layoutGravity = [.fillHorizontal]
        $0.layoutSize = CGSize(width: dp(0), height: dp(300))

        $0.backgroundColor = UIColor(white: 0, alpha: 0.1)
        $0.minValueAdjustBlock = { min, values in
            return 0
        }
        $0.maxValueAdjustBlock = { (max: Int, values) in
            return max + Int(Double(max) * 0.1)
        }
        $0.barColorAdjustBlock = { item, items in
            let maxValue = items.reduce(items[0].value, { (result, item) -> Int in
                max(result, item.value)
            })
            if item.value == maxValue {
                return UIColor.red
            } else {
                return UIColor.yellow
            }
        }
        $0.scaleValueAdjustBlock = { n in
            n.formatUsingAbbrevation()
        }
    }

    let selectionSegmentControl = EDSegmentedControl().apply {
        $0.marginTop = Dimens.marginMedium
        $0.layoutGravity = .fillHorizontal
        $0.insertSegment(withTitle: "TopPadding", at: 0, animated: false)
        $0.insertSegment(withTitle: "Padding", at: 0, animated: false)
        $0.insertSegment(withTitle: "TitleHeight", at: 0, animated: false)
        $0.insertSegment(withTitle: "Spacing", at: 0, animated: false)
        $0.insertSegment(withTitle: "Count", at: 0, animated: false)
    }

    let selectionSlider = EDSlider().apply {
        $0.marginTop = Dimens.marginMedium
        $0.layoutGravity = .fillHorizontal
    }

    let horizontalLineSegmentControl = EDSegmentedControl().apply {
        $0.marginTop = Dimens.marginMedium
        $0.layoutGravity = .fillHorizontal
        $0.insertSegment(withTitle: "Show Horizontal Lines", at: 0, animated: false)
        $0.insertSegment(withTitle: "No Show", at: 0, animated: false)
    }

    let updateButton = EDButton().apply {
        $0.layoutGravity = [.centerHorizontal]
        $0.marginTop = Dimens.marginMedium
        $0.padding = Dimens.marginMedium
        $0.setTitleColor(.black, for: .normal)
        $0.setTitle("Update", for: .normal)
    }

    let barCountSlider = EDSlider().apply {
        $0.marginTop = Dimens.marginMedium
        $0.layoutGravity = .fillHorizontal
        $0.minimumValue = 1
        $0.maximumValue = 10
        $0.value = 3
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        contentLinearLayout.addSubview(barGraph)
        contentLinearLayout.addSubview(selectionSegmentControl)
        contentLinearLayout.addSubview(selectionSlider)
        contentLinearLayout.addSubview(horizontalLineSegmentControl)
        contentLinearLayout.addSubview(updateButton)
        contentLinearLayout.addSubview(barCountSlider)

        selectionSegmentValueChanged(selectionSegmentControl)
        barsSliderValueChanged(barCountSlider)

        selectionSegmentControl.addTarget(self, action: #selector(selectionSegmentValueChanged(_:)), for: .valueChanged)
        selectionSlider.addTarget(self, action: #selector(selectionSliderValueChanged(_:)), for: .valueChanged)
        updateButton.addTarget(self, action: #selector(updateButtonPressed(_:)), for: .touchUpInside)
        horizontalLineSegmentControl.addTarget(self, action: #selector(horiztonalLineChanged(_:)), for: .valueChanged)
        barCountSlider.addTarget(self, action: #selector(barsSliderValueChanged(_:)), for: .valueChanged)
    }

    @objc func selectionSegmentValueChanged(_ sender: Any) {
        switch self.selectionSegmentControl.selectedSegmentIndex {
        case 0:
            self.selectionSlider.minimumValue = 0
            self.selectionSlider.maximumValue = 100
            self.selectionSlider.value = Float(self.barGraph.topPadding)
        case 1:
            self.selectionSlider.minimumValue = 0
            self.selectionSlider.maximumValue = 100
            self.selectionSlider.value = Float(self.barGraph.scalePadding)
        case 2:
            self.selectionSlider.minimumValue = 0
            self.selectionSlider.maximumValue = 100
            self.selectionSlider.value = Float(self.barGraph.titleHeight)
        case 3:
            self.selectionSlider.minimumValue = 0
            self.selectionSlider.maximumValue = 100
            self.selectionSlider.value = Float(self.barGraph.horizontalSpacing)
        case 4:
            self.selectionSlider.minimumValue = 3
            self.selectionSlider.maximumValue = 10
            self.selectionSlider.value = Float(self.barGraph.scaleCount)
        default:
            return
        }
    }

    @objc func selectionSliderValueChanged(_ sender: Any) {
        let value = self.selectionSlider.value
        switch self.selectionSegmentControl.selectedSegmentIndex {
        case 0:
            self.barGraph.topPadding = CGFloat(value)
        case 1:
            self.barGraph.scalePadding = CGFloat(value)
        case 2:
            self.barGraph.titleHeight = CGFloat(value)
        case 3:
            self.barGraph.horizontalSpacing = CGFloat(value)
        case 4:
            self.barGraph.scaleCount = Int(value)
        default:
            return
        }
    }

    @objc func horiztonalLineChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.barGraph.showHorizontalLine = true
        } else {
            self.barGraph.showHorizontalLine = false
        }
    }
    @objc func updateButtonPressed(_ sender: Any) {
        let count = Int(self.barCountSlider.value)
        let titles = Array(1...count).map({"Title " + String($0)})
        let items = titles.map({ BarGraphItem(title: $0, value: Int.random(in: 100..<9999))})
        self.barGraph.updateBars(bars: items)
    }

    @objc func barsSliderValueChanged(_ sender: Any) {
        let count = Int(self.barCountSlider.value)
        let titles = Array(1...count).map({"Title " + String($0)})
        let items = titles.map({ BarGraphItem(title: $0, value: Int.random(in: 1000..<99999))})
        self.barGraph.setBars(bars: items)
    }

}

private extension Int {

    func formatUsingAbbrevation () -> String {
        let numFormatter = NumberFormatter()

        typealias Abbrevation = (threshold:Double, divisor:Double, suffix:String)
        let abbreviations:[Abbrevation] = [(0, 1, ""),
                                           (1000.0, 1000.0, "K"),
                                           (100_000.0, 1_000_000.0, "M"),
                                           (100_000_000.0, 1_000_000_000.0, "B")]
        // you can add more !
        let startValue = Double (abs(self))
        let abbreviation:Abbrevation = {
            var prevAbbreviation = abbreviations[0]
            for tmpAbbreviation in abbreviations {
                if (startValue < tmpAbbreviation.threshold) {
                    break
                }
                prevAbbreviation = tmpAbbreviation
            }
            return prevAbbreviation
        } ()

        let value = Double(self) / abbreviation.divisor
        numFormatter.positiveSuffix = abbreviation.suffix
        numFormatter.negativeSuffix = abbreviation.suffix
        numFormatter.allowsFloats = true
        numFormatter.minimumIntegerDigits = 1
        numFormatter.minimumFractionDigits = 0
        numFormatter.maximumFractionDigits = 1

        return numFormatter.string(from: NSNumber(value:value))!
    }

}

