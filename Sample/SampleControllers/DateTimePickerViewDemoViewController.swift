import oneHookLibrary
import UIKit

private class DummyDayView: FrameLayout, DayCell {

    private var maxLength = CGFloat(50)
    var day: Int = 0
    var month: Int = 0
    var year: Int = 0

    let titleLabel = EDLabel().apply {
        $0.layoutGravity = .center
        $0.textAlignment = .center
        $0.textColor = .black
    }

    convenience init() {
        self.init(frame: .zero)
        layer.masksToBounds = true
        backgroundColor = .lightGray
        addSubview(titleLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 8
        maxLength = max(maxLength, bounds.width)
        let scale = bounds.width / maxLength
        titleLabel.layer.transform = CATransform3DMakeScale(scale, scale, scale)
        titleLabel.font = UIFont.systemFont(ofSize: maxLength / 2.5)
        if scale < 0.9 {
            titleLabel.alpha = 0
        } else {
            titleLabel.alpha = 1
        }
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        CGSize(width: size.width, height: size.width)
    }

    func bind(day: Int, month: Int, year: Int, inMonth: Bool, userInfo: Any?) {
        self.day = day
        self.month = month
        self.year = year

        titleLabel.text = String(day)
        alpha = inMonth ? 1.0 : 0.5

        if let userInfo = userInfo as? [Int] {
            titleLabel.textColor = .white
            if userInfo.contains(day) {
                backgroundColor = UIColor(hex: "075206")
            } else {
                backgroundColor = UIColor(hex: "ab100a")
            }
        }
        setNeedsLayout()
    }
}

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

    private let calendarPicker = EGCalendarPicker<DummyDayView>()

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
