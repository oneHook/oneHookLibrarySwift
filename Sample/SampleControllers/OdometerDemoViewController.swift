import oneHookLibrary
import UIKit

class OdometerDemoViewController: BaseScrollableDemoViewController {

    var dateOdometerLabel = OdometerLabel()
    var timer: Timer?

    var currencySlider = EDSlider().apply {
        $0.minimumValue = 1000
        $0.maximumValue = 9999999
    }
    var currencyLabel = OdometerLabel()

    var animationSwitch = SwitchView()
    var odometerStyleLabel = OdometerLabel()
    var odometerStyleSlider = EDSlider().apply {
        $0.minimumValue = 1000
        $0.maximumValue = 9999999
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        toolbarTitle = "Odometer Label Demo"

        contentLinearLayout.also {
            /* First section */
            $0.addSubview(EDLabel().apply {
                $0.layoutGravity = .fillHorizontal
                $0.font = UIFont.systemFont(ofSize: dp(20))
                $0.text = "Date"
                $0.marginBottom = Dimens.marginMedium
            })

            $0.addSubview(dateOdometerLabel.apply {
                $0.layoutGravity = .fillHorizontal
                $0.marginBottom = Dimens.marginMedium
            })

            $0.addSubview(ViewGenerator.divider().apply {
                $0.marginBottom = Dimens.marginMedium
            })

            /* Second section */

            $0.addSubview(EDLabel().apply {
                $0.layoutGravity = .fillHorizontal
                $0.font = UIFont.systemFont(ofSize: dp(20))
                $0.text = "Currency"
                $0.marginBottom = Dimens.marginMedium
            })

            $0.addSubview(currencyLabel.apply {
                $0.layoutGravity = .fillHorizontal
                $0.marginBottom = Dimens.marginMedium
            })

            $0.addSubview(currencySlider.apply {
                $0.layoutGravity = .fillHorizontal
                $0.marginBottom = Dimens.marginMedium
            })

            $0.addSubview(ViewGenerator.divider().apply {
                $0.marginBottom = Dimens.marginMedium
            })

            /* Third section */

            $0.addSubview(EDLabel().apply {
                $0.layoutGravity = .fillHorizontal
                $0.font = UIFont.systemFont(ofSize: dp(20))
                $0.text = "Odometer Label"
                $0.marginBottom = Dimens.marginMedium
            })

            $0.addSubview(odometerStyleLabel.apply {
                $0.layoutGravity = .fillHorizontal
                $0.marginBottom = Dimens.marginMedium
            })

            $0.addSubview(odometerStyleSlider.apply {
                $0.layoutGravity = .fillHorizontal
                $0.marginBottom = Dimens.marginMedium
            })

            $0.addSubview(ViewGenerator.divider().apply {
                $0.marginBottom = Dimens.marginMedium
            })
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_CA")

        dateOdometerLabel.textAlignment = .center
        updateDateLabel()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.updateDateLabel()
        })

        currencyLabel.textAlignment = .right
        currencySlider.addTarget(self, action: #selector(sliderValueChanged(sender:)), for: .valueChanged)
        odometerStyleSlider.addTarget(self, action: #selector(sliderValueChanged(sender:)), for: .valueChanged)
        sliderValueChanged(sender: self.currencySlider)

        odometerStyleLabel.horizontalSpacing = 4
        odometerStyleLabel.animationDuration = 2
    }

    private func updateDateLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeString = dateFormatter.string(from: Date())
        self.dateOdometerLabel.setNumber(timeString, animated: true)
    }

    @objc func sliderValueChanged(sender: UIControl) {
        if currencySlider == sender {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: "en_CA")
            let number = Int(currencySlider.value)
            currencyLabel.setNumber(formatter.string(from: number as NSNumber)!, animated: true)
        } else if self.odometerStyleSlider == sender {
            let number = Int(odometerStyleSlider.value)
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.locale = Locale(identifier: "en_CA")
            self.odometerStyleLabel.setNumber(formatter.string(from: number as NSNumber)!, animated: self.animationSwitch.isOn)

            if !self.animationSwitch.isOn {
                print("show", number)
                DispatchQueue.main.async {
                    self.odometerStyleLabel.setNumber(formatter.string(from: (number + 22) as NSNumber)!, animated: true)
                }
            }
        }
    }
}
