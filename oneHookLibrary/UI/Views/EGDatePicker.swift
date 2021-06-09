import UIKit

public class EGDatePicker<YearCell: NumberLabel, MonthCell: NumberLabel, DayCell: NumberLabel>: LinearLayout {

    public struct Date {
        var year: Int
        var month: Int
        var day: Int

        public init(year: Int, month: Int, day: Int) {
            self.year = year
            self.month = month
            self.day = day
        }
    }

    public var cellHeight = dp(48) {
        didSet {
            centerBar.layoutSize = CGSize(width: 0, height: cellHeight)
            yearPicker.numberLabelHeight = cellHeight
            monthPicker.numberLabelHeight = cellHeight
            dayPicker.numberLabelHeight = cellHeight
        }
    }
    public var highlightBackgroundColor = UIColor.ed_toolbarTextColor {
        didSet {
            centerBar.backgroundColor = highlightBackgroundColor
        }
    }
    public var highlightTextColor = UIColor.ed_toolbarBackgroundColor {
        didSet {
            for cell in yearHighlightCells {
                cell.textColor = highlightTextColor
            }
            for cell in monthHighlightCells {
                cell.textColor = highlightTextColor
            }
            for cell in dayHighlightCells {
                cell.textColor = highlightTextColor
            }
        }
    }

    private var yearHighlightCells = [YearCell]()
    private var monthHighlightCells = [MonthCell]()
    private var dayHighlightCells = [DayCell]()

    private lazy var yearPicker = NumberInfiniteScrollView<YearCell>(start: 1900, end: 2100).apply {
        $0.orientation = .vertical
        $0.layoutWeight = 1
        $0.currentNumber = currentDate.year
        $0.layoutGravity = [.fillVertical]
        $0.numberSelected = { [weak self] (year) in
            self?.onYearSelected(year)
        }
        $0.didScroll = { [weak self] in
            self?.yearScrolled()
        }
    }

    private lazy var monthPicker = NumberInfiniteScrollView<MonthCell>(start: 1, end: 13).apply {
        $0.orientation = .vertical
        $0.layoutGravity = [.fillVertical]
        $0.layoutWeight = 2
        $0.currentNumber = currentDate.month
        $0.numberSelected = { [weak self] (month) in
            self?.onMonthSelected(month)
        }
        $0.didScroll = { [weak self] in
            self?.monthScrolled()
        }
    }

    private lazy var dayPicker = NumberInfiniteScrollView<DayCell>(start: 1, end: 32).apply {
        $0.orientation = .vertical
        $0.layoutGravity = [.fillVertical]
        $0.layoutWeight = 1
        $0.currentNumber = currentDate.day
        $0.numberSelected = { [weak self] (day) in
            self?.onDaySelected(day)
        }
        $0.didScroll = { [weak self] in
            self?.dayScrolled()
        }
    }

    private lazy var centerBar = BaseView().apply {
        $0.backgroundColor = highlightBackgroundColor
        $0.layoutSize = CGSize(width: 0, height: cellHeight)
        $0.shouldSkip = true
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = false
    }

    public var minDate: Date? {
        didSet {
            makeSureRange()
        }
    }
    public var currentDate: Date
    public var maxDate: Date? {
        didSet {
            makeSureRange()
        }
    }

    public var dateSelected: ((Date) -> Void)?

    public required init(year: Int, month: Int, day: Int) {
        currentDate = .init(year: year, month: month, day: day)
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func commonInit() {
        super.commonInit()
        backgroundColor = .clear
        orientation = .horizontal
        addSubview(yearPicker)
        addSubview(monthPicker)
        addSubview(dayPicker)
        addSubview(centerBar)
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

    public override func viewDidFirstLayout() {
        DispatchQueue.main.async {
            self.yearScrolled()
            self.monthScrolled()
            self.dayScrolled()
        }
    }

    private func yearScrolled() {
        pickerScrolled(picker: yearPicker, cells: &yearHighlightCells)
    }
    private func monthScrolled() {
        pickerScrolled(picker: monthPicker, cells: &monthHighlightCells)
    }
    private func dayScrolled() {
        pickerScrolled(picker: dayPicker, cells: &dayHighlightCells)
    }

    func pickerScrolled<T: NumberLabel>(picker: NumberInfiniteScrollView<T>, cells: inout [T]) {
        if cells.isEmpty {
            cells.append(T())
            cells.append(T())
            cells.append(T())
            for cell in cells {
                centerBar.addSubview(cell)
            }
        }
        guard
            let centerCell = picker.centerCell,
            let index = picker.cells.firstIndex(of: centerCell) else {
            return
        }
        let cellFrame = picker.convert(centerCell.frame, to: centerBar)
        let isSelectable = picker.isNumberSelectable(centerCell.number)
        cells[0].bind(number: centerCell.number, style: .notSelectable)
        if isSelectable {
            cells[0].textColor = highlightTextColor
        }
        cells[0].frame = cellFrame

        if let previous = picker.cells[safe: index - 1] {
            let cellFrame = picker.convert(previous.frame, to: centerBar)
            let isSelectable = picker.isNumberSelectable(previous.number)
            cells[1].bind(number: previous.number, style: .notSelectable)
            if isSelectable {
                cells[1].textColor = highlightTextColor
            }
            cells[1].frame = cellFrame
        } else {
            cells[1].frame = .zero
        }

        if let next = picker.cells[safe: index + 1] {
            let cellFrame = picker.convert(next.frame, to: centerBar)
            let isSelectable = picker.isNumberSelectable(next.number)
            cells[2].bind(number: next.number, style: .notSelectable)
            if isSelectable {
                cells[2].textColor = highlightTextColor
            }
            cells[2].frame = cellFrame
        } else {
            cells[2].frame = .zero
        }
    }

    @objc func onYearSelected(_ year: Int) {
        currentDate.year = year
        makeSureRange()
        if !monthPicker.update(animated: true) {
            if !dayPicker.update(animated: true) {
                dateSelected?(currentDate)
            }
        } else {
            yearScrolled()
        }
    }

    @objc func onMonthSelected(_ month: Int) {
        currentDate.month = month
        makeSureRange()
        if !dayPicker.update(animated: true) {
            dateSelected?(currentDate)
        } else {
            monthScrolled()
        }
    }

    @objc func onDaySelected(_ day: Int) {
        currentDate.day = day
        dateSelected?(currentDate)
        dayScrolled()
    }

    private func makeSureRange() {
        dayPicker.endingNumber = numberOfDayInMonth(currentDate.month, year: currentDate.year) + 1
        if let minDate = minDate {
            yearPicker.minNumber = minDate.year
            if currentDate.year == minDate.year {
                monthPicker.minNumber = minDate.month
                if currentDate.month == minDate.month {
                    dayPicker.minNumber = minDate.day
                } else {
                    dayPicker.minNumber = nil
                }
            } else {
                monthPicker.minNumber = nil
                dayPicker.minNumber = nil
            }
        } else {
            yearPicker.minNumber = nil
            monthPicker.minNumber = nil
            dayPicker.minNumber = nil
        }

        if let maxDate = maxDate {
            yearPicker.maxNumber = maxDate.year
            if currentDate.year == maxDate.year {
                monthPicker.maxNumber = maxDate.month
                if currentDate.month == maxDate.month {
                    dayPicker.maxNumber = maxDate.day
                } else {
                    dayPicker.maxNumber = nil
                }
            } else {
                monthPicker.maxNumber = nil
                dayPicker.maxNumber = nil
            }
        } else {
            yearPicker.maxNumber = nil
            monthPicker.maxNumber = nil
            dayPicker.maxNumber = nil
        }
    }
}
