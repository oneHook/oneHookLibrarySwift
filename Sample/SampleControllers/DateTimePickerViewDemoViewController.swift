import oneHookLibrary
import UIKit

class MyNumberLabel: NumberLabel {

    private static let numberLabelFont = Fonts.regular(Fonts.fontSizeXLarge)
    private static let numberLabelColorNormal: UIColor = .black
    private static let numberLabelColorDisabled: UIColor = .lightGray

    open override func bind(number: Int?, style: Style) {
        self.number = number
        backgroundColor = .clear
        padding = Dimens.marginMedium
        textAlignment = .center
        font = Self.numberLabelFont
        switch style {
        case .selectable:
            textColor = Self.numberLabelColorNormal
        case .notSelectable:
            textColor = Self.numberLabelColorDisabled
        case .highlight:
            textColor = .yellow
        }
        text = String(number ?? 0)
    }
}

class MyMonthLabel: NumberLabel {

    private static let formatter = DateFormatter()
    private static let numberLabelFont = Fonts.regular(Fonts.fontSizeXLarge)
    private static let numberLabelColorNormal: UIColor = .black
    private static let numberLabelColorDisabled: UIColor = .lightGray

    open override func bind(number: Int?, style: Style) {
        self.number = number
        backgroundColor = .clear
        padding = Dimens.marginMedium
        textAlignment = .left
        font = Self.numberLabelFont
        switch style {
        case .selectable:
            textColor = Self.numberLabelColorNormal
        case .notSelectable:
            textColor = Self.numberLabelColorDisabled
        case .highlight:
            textColor = .yellow
        }
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
