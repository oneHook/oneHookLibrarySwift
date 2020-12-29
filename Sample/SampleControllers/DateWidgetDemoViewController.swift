import UIKit
import oneHookLibrary

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
        alpha = inMonth ? 1.0 : 0

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

private class MonthViewWithTitle: LinearLayout {

    let titleLabel = EDLabel().apply {
        $0.paddingTop = Dimens.marginSmall
        $0.paddingBottom = Dimens.marginSmall
        $0.text = "December, 2020"
        $0.layoutGravity = .fill
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        $0.marginBottom = Dimens.marginSmall
    }

    let monthView = MonthView<DummyDayView>().apply {
        $0.padding = Dimens.marginSmall
        $0.layoutGravity = [.fillHorizontal]
        $0.bind(MonthViewUIModel(date: Date()))
    }

    override func commonInit() {
        super.commonInit()
        orientation = .vertical
        addSubview(titleLabel)
        addSubview(monthView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
//        titleLabel.font = UIFont.boldSystemFont(ofSize: bounds.width / 16)
    }

    func bind(_ uiModel: MonthViewUIModel) {
        let monthName = DateFormatter().monthSymbols[uiModel.month - 1]
        titleLabel.text = "\(monthName), \(uiModel.year)"
        monthView.bind(uiModel)
    }
}

class DateWidgetDemoViewController: BaseScrollableDemoViewController {

    private var rowItemCount = CGFloat(2)

    private let flowLayout = FlowLayout().apply {
        $0.horizontalSpacing = 0
        $0.verticalSpacing = Dimens.marginMedium
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        toolbarTitle = "Date Widget"

        toolbar.leftNavigationButton.getOrMake().also {
            $0.setTitle("Back", for: .normal)
            $0.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        }

        toolbar.rightNavigationButton.getOrMake().also {
            $0.setTitle("Zoom", for: .normal)
            $0.setTitleColor(.blue, for: .normal)
            $0.addTarget(self, action: #selector(switchButtonPressed), for: .touchUpInside)
        }

        var date = Date()
        for _ in 0..<12 {
            flowLayout.addSubview(MonthViewWithTitle().apply {
                var selected = [Int]()
                for _ in 0..<Int.random(in: 0..<31) {
                    selected.append(Int.random(in: 0..<31))
                }
                $0.bind(MonthViewUIModel(date: date, showAllDays: false, userInfo: selected))
                $0.monthView.didTap = { [weak self] (cell) in
                    guard let self = self else {
                        return
                    }
                    if self.rowItemCount == 2 {
                        self.rowItemCount = 1
                        self.doLayout(targetMonth: cell.month, targetYear: cell.year, animated: true)
                    } else {
                        let time = "\(cell.year)-\(cell.month)-\(cell.day)"
                        let controller = UIAlertController(title: "Pick a Time",
                                                           message: "Now you can pick a time for \(time)",
                                                           preferredStyle: .alert)
                        controller.addAction(.init(title: "Sure!", style: .cancel, handler: nil))
                        self.present(controller, animated: true, completion: nil)
                    }
                }
            })
            date = date.add(months: 1)!
        }
        contentLinearLayout.addSubview(flowLayout)
    }

    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func switchButtonPressed() {
        if rowItemCount == 1 {
            rowItemCount = 2
        } else if rowItemCount == 2 {
            rowItemCount = 3
        } else {
            rowItemCount = 1
        }
        doLayout(animated: true)
    }

    private func doLayout(targetMonth: Int? = nil, targetYear: Int? = nil, animated: Bool) {
        let maxWidth = contentLinearLayout.bounds.width - contentLinearLayout.paddingStart - contentLinearLayout.paddingEnd
        let cellWidth = (maxWidth - flowLayout.horizontalSpacing * (rowItemCount - 1)) / rowItemCount

        var targetY: CGFloat?
        var currY = -scrollView.contentInset.top
        for child in flowLayout.subviews {
            child.layoutSize = .zero
            let size = child.sizeThatFits(
                CGSize(
                    width: cellWidth,
                    height: CGFloat.greatestFiniteMagnitude
                )
            )
            child.layoutSize = CGSize(width: cellWidth, height: size.height)

            if
                let view = child as? MonthViewWithTitle,
                view.monthView.uiModel?.year == targetYear,
                view.monthView.uiModel?.month == targetMonth {
                targetY = currY
            }

            currY += size.height + flowLayout.verticalSpacing
        }

        UIView.animate(withDuration: animated ? .defaultAnimation : 0) {
            self.contentLinearLayout.setNeedsLayout()
            self.contentLinearLayout.layoutIfNeeded()
            self.scrollView.setContentOffset(CGPoint(x: 0, y: targetY ?? -self.scrollView.contentInset.top), animated: false)
        }
        invalidateContentInset()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        doLayout(animated: false)
    }
}
