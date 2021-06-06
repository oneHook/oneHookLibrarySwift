import UIKit

public class EGDatePicker<Year: NumberLabel, Month: NumberLabel, Day: NumberLabel>: LinearLayout {

    public struct Date {
        var year: Int
        var month: Int
        var day: Int
    }

    private lazy var yearScrollView = NumberInfiniteScrollView<Year>(start: 1900, end: 2100).apply {
        $0.orientation = .vertical
        $0.layoutWeight = 1
        $0.currentNumber = currentDate.year
        $0.layoutGravity = [.fillVertical]
        $0.numberSelected = { [weak self] (year) in
            self?.onYearSelected(year)
        }
    }

    private lazy var monthPicker = NumberInfiniteScrollView<Month>(start: 1, end: 13).apply {
        $0.orientation = .vertical
        $0.layoutGravity = [.fillVertical]
        $0.layoutWeight = 2
        $0.currentNumber = currentDate.month
        $0.numberSelected = { [weak self] (month) in
            self?.onMonthSelected(month)
        }
    }

    private lazy var dayPicker = NumberInfiniteScrollView<Day>(start: 1, end: 32).apply {
        $0.orientation = .vertical
        $0.layoutGravity = [.fillVertical]
        $0.layoutWeight = 1
        $0.currentNumber = currentDate.day
        $0.numberSelected = { [weak self] (day) in
            self?.onDaySelected(day)
        }
    }

    public let centerBar = FrameLayout().apply {
        $0.backgroundColor = .purple
        $0.layoutSize = CGSize(width: 0, height: dp(48))
        $0.shouldSkip = true
    }

    public var currentDate: Date

    public required init(year: Int, month: Int, day: Int) {
        currentDate = .init(year: year, month: month, day: day)
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func commonInit() {
        super.commonInit()
        backgroundColor = .blue
        orientation = .horizontal
        addSubview(centerBar)
        addSubview(yearScrollView)
        addSubview(monthPicker)
        addSubview(dayPicker)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        centerBar.frame = CGRect(
            x: 0,
            y: (bounds.height - centerBar.layoutSize.height) / 2,
            width: bounds.width,
            height: centerBar.layoutSize.height
        )
    }

    private func isLeapYear(_ year: Int) -> Bool {
        if year % 400 == 0 {
            return true
        } else if year % 100 == 0 {
            return false
        } else {
            return year % 4 == 0
        }
    }

    private func numberOfDayInMonth(_ month: Int, year: Int) -> Int {
        let isLeap = isLeapYear(year)
        if month == 2 {
            if isLeap {
                return 29
            } else {
                return 28
            }
        } else if [1, 3, 5, 7, 8, 10, 12].contains(month) {
            return 31
        } else {
            return 30
        }
    }

    @objc func onYearSelected(_ year: Int) {
        print("XXX on year changed", year)
        currentDate.year = year
        if !dayPicker.setStartingNumber(
            1,
            endingNumber: numberOfDayInMonth(currentDate.month, year: currentDate.year) + 1,
            step: 1
        ) {
            print("XXX new date", currentDate)
        }
    }

    @objc func onMonthSelected(_ month: Int) {
        print("XXX on month changed", month)
        currentDate.month = month
        if !dayPicker.setStartingNumber(
            1,
            endingNumber: numberOfDayInMonth(currentDate.month, year: currentDate.year) + 1,
            step: 1
        ) {
            print("XXX new date", currentDate)
        }
    }

    @objc func onDaySelected(_ day: Int) {
        print("XXX on day changed", day)
        currentDate.day = day
        print("XXX new date", currentDate)
    }
}
