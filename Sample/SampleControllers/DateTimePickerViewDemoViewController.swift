import oneHookLibrary
import UIKit

class MyNumberLabel: NumberLabel {

    open override func bind(number: Int?, style: Style) {
        super.bind(number: number, style: style)
    }
}

class MyMonthLabel: NumberLabel {

    private static let formatter = DateFormatter()

    open override func bind(number: Int?, style: Style) {
        super.bind(number: number, style: style)
        text = Self.formatter.monthSymbols[safe: (number ?? 1) - 1] ?? "" + String(number ?? 0)
    }
}

class DateTimePickerViewDemoViewController: BaseScrollableDemoViewController {

    private let datePicker = EGDatePicker<MyNumberLabel, MyMonthLabel, MyNumberLabel>(
        year: 2020,
        month: 5,
        day: 15
    ).apply {
        $0.backgroundColor = UIColor(white: 0, alpha: 0.1)
        $0.marginTop = Dimens.marginMedium
        $0.layoutSize = CGSize(width: 0, height: dp(250))
        $0.layoutGravity = .fillHorizontal
        $0.minDate = EGDatePicker.Date(year: 2018, month: 9, day: 9)
        $0.maxDate = EGDatePicker.Date(year: 2020, month: 6, day: 5)
        $0.dateSelected = { (date) in
            print("XXX date selected", date)
        }
    }

    private let durationPicker = EGDurationPicker<MyNumberLabel, MyNumberLabel>(
        hour: 0,
        minute: 0
    ).apply {
        $0.backgroundColor = UIColor(white: 0, alpha: 0.1)
        $0.marginTop = Dimens.marginMedium
        $0.layoutSize = CGSize(width: 0, height: dp(250))
        $0.layoutGravity = .fillHorizontal
        $0.durationSelected = { (duration) in
            print("XXX duration selected", duration)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarTitle = "Date/Time Picker View"
        contentLinearLayout.addSubview(datePicker)
        contentLinearLayout.addSubview(durationPicker)
    }
}
