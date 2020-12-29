import UIKit

public protocol DayCell {
    func bind(day: Int, month: Int, year: Int, inMonth: Bool, userInfo: Any?)
}

public struct MonthViewUIModel {
    public let year: Int
    public let month: Int
    public let daysInMonth: Int
    /* If a month takes only 4 rows to fill (2015.2), should we show all rows */
    public var showAllDays: Bool
    public var userInfo: Any?

    var startingIndex: Int
    var endingIndex: Int

    public init(date: Date, showAllDays: Bool = false, userInfo: Any? = nil) {
        let calendar = Calendar.current
        let date = date.startOfMonth!
        let dateComponents = calendar.dateComponents([.year, .month], from: date)
        self.year = dateComponents.year ?? 0
        self.month = dateComponents.month ?? 0
        self.daysInMonth = calendar.range(of: .day, in: .month, for: date)!.count
        self.showAllDays = showAllDays
        self.userInfo = userInfo
        self.startingIndex = calendar.component(.weekday, from: date) - 1
        self.endingIndex = startingIndex + daysInMonth
    }

    public init(year: Int, month: Int, showAllDays: Bool = false, userInfo: Any? = nil) {
        self.year = year
        self.month = month
        self.showAllDays = showAllDays
        self.userInfo = userInfo

        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = 1
        dateComponents.timeZone = .current

        let calendar = Calendar.current
        let startingDate = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: startingDate)!

        self.daysInMonth = range.count
        self.startingIndex = calendar.component(.weekday, from: startingDate) - 1
        self.endingIndex = startingIndex + daysInMonth
    }
}

open class MonthView<CellType: UIView & DayCell>: StackLayout {

    private var rows = [RowLayout]()
    private var _uiModel: MonthViewUIModel?
    public var uiModel: MonthViewUIModel? {
        _uiModel
    }
    public var didTap: ((CellType) -> Void)? = nil

    open override func commonInit() {
        super.commonInit()
        spacing = Dimens.marginSmall
        orientation = .vertical

        for _ in 0..<6 {
            let rowView = RowLayout().apply {
                $0.spacing = Dimens.marginSmall
                for _ in 0..<7 {
                    $0.addSubview(CellType().apply {
                        $0.addGestureRecognizer(
                            UITapGestureRecognizer(
                                target: self,
                                action: #selector(cellOnTap(tapRec:))
                            )
                        )
                    })
                }
            }
            rows.append(rowView)
            addSubview(rowView)
        }
    }

    public func bind(_ uiModel: MonthViewUIModel) {
        self._uiModel = uiModel
        for row in rows {
            row.isHidden = false
        }

        for i in 0..<42 {
            let row = i / 7
            let col = i % 7
            let day = i - uiModel.startingIndex + 1
            let inMonth = i >= uiModel.startingIndex && i < uiModel.endingIndex
            if let cell = rows[safe:row]?.subviews[safe:col] as? CellType {
                cell.bind(day: day, month: uiModel.month, year: uiModel.year, inMonth: inMonth, userInfo: uiModel.userInfo)
            }
            if col == 0 && i >= uiModel.endingIndex && !uiModel.showAllDays {
                rows[safe: row]?.isHidden = true
            }
        }
    }

    @objc private func cellOnTap(tapRec: UITapGestureRecognizer) {
        if let cell = tapRec.view as? CellType {
            didTap?(cell)
        }
    }
}
