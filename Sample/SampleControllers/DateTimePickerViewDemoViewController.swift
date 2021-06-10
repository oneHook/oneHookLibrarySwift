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

class MyAmPmLabel: NumberLabel {

    private static let formatter = DateFormatter()

    open override func bind(number: Int?, style: Style) {
        super.bind(number: number, style: style)
        text = number == 0 ? "AM" : "PM"
    }
}

class DateTimePickerViewDemoViewController: BaseScrollableDemoViewController {

    private let calendarPicker = EGCalendarPicker().apply {
        $0.spacing = dp(8)
        $0.minimumDate = Date()
    }

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
        minute: 0,
        step: 5
    ).apply {
        $0.backgroundColor = UIColor(white: 0, alpha: 0.1)
        $0.marginTop = Dimens.marginMedium
        $0.layoutSize = CGSize(width: 0, height: dp(250))
        $0.layoutGravity = .fillHorizontal
        $0.durationSelected = { (duration) in
            print("XXX duration selected", duration)
        }
    }

    private let timePicker = EGTimePicker<MyNumberLabel, MyNumberLabel, MyAmPmLabel>(
        hour: 2,
        minute: 30,
        isAm: true,
        step: 5
    ).apply {
        $0.backgroundColor = UIColor(white: 0, alpha: 0.1)
        $0.marginTop = Dimens.marginMedium
        $0.layoutSize = CGSize(width: 0, height: dp(250))
        $0.layoutGravity = .fillHorizontal
        $0.timeSelected = { (time) in
            print("XXX time selected", time)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarTitle = "Date/Time Picker View"
        contentLinearLayout.addSubview(calendarPicker)
        contentLinearLayout.addSubview(timePicker)
        contentLinearLayout.addSubview(datePicker)
        contentLinearLayout.addSubview(durationPicker)
        contentLinearLayout.addSubview(SolidButton().apply {
            $0.padding = Dimens.marginMedium
            $0.layoutGravity = .centerHorizontal
            $0.margin = Dimens.marginMedium
            $0.setBackgroundColor(.red, for: .normal)
            $0.setTitle("Go To", for: .normal)
            $0.addTarget(self, action: #selector(debugButtonPressed), for: .touchUpInside)
        })
    }

    @objc private func debugButtonPressed() {
        datePicker.currentDate = EGDatePicker.Date(year: 2019, month: 2, day: 17)
        durationPicker.currentDuration = EGDurationPicker.Duration(hour: 2, minute: 50)
        timePicker.currentTime = EGTimePicker.Time(hour: 9, minute: 15, isAm: false)
    }
}
