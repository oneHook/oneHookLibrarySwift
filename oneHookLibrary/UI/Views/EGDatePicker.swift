import UIKit

public class EGDatePicker: LinearLayout {

    public struct Date {
        var year: Int
        var month: Int
        var day: Int
    }

    private lazy var yearScrollView = NumberInfiniteScrollView(start: 1900, end: 2100).apply {
        $0.orientation = .vertical
        $0.layoutWeight = 5
        $0.currentNumber = currentDate.year
        $0.layoutGravity = [.fillVertical]
        $0.numberSelected = { [weak self] (year) in
            self?.onYearSelected(year)
        }
    }

    private lazy var monthPicker = NumberInfiniteScrollView(start: 1, end: 13).apply {
        $0.orientation = .vertical
        $0.layoutGravity = [.fillVertical]
        $0.layoutWeight = 1.5
        $0.currentNumber = currentDate.month
        $0.numberSelected = { [weak self] (month) in
            self?.onMonthSelected(month)
        }
    }

    private lazy var dayPicker = NumberInfiniteScrollView(start: 1, end: 32).apply {
        $0.orientation = .vertical
        $0.layoutGravity = [.fillVertical]
        $0.layoutWeight = 1.5
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
        centerBar.frame = CGRect(x: 0,
                                 y: (bounds.height - centerBar.layoutSize.height) / 2,
                                 width: bounds.width,
                                 height: centerBar.layoutSize.height
        )
    }

    @objc func onYearSelected(_ year: Int) {

    }

    @objc func onMonthSelected(_ month: Int) {

    }

    @objc func onDaySelected(_ day: Int) {

    }
}
