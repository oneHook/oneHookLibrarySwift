import UIKit

open class EGCalendarPicker<DayView: DayCell & UIView>: LinearLayout {

    public let titleLabel = EDLabel().apply {
        $0.paddingTop = Dimens.marginSmall
        $0.paddingBottom = Dimens.marginSmall
        $0.text = "December, 2020"
        $0.layoutGravity = .fill
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        $0.marginBottom = Dimens.marginSmall
    }

    public let monthView = MonthView<DayView>().apply {
        $0.padding = Dimens.marginSmall
        $0.layoutGravity = [.fillHorizontal]
        $0.bind(MonthViewUIModel(date: Date()))
    }

    public override func commonInit() {
        super.commonInit()
        orientation = .vertical
        addSubview(titleLabel)
        addSubview(monthView)
        monthView.bind(.init(year: 2021, month: 6, showAllDays: true))
    }
}
