import UIKit

private class MyMonthView: BaseView {

    var anyDayInMonth: Date?
    private var firstDay = Date()

    private var cells = [EDButton]()
    private weak var parent: EGCalendarPicker?

    required init(parent: EGCalendarPicker) {
        self.parent = parent
        super.init(frame: .zero)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func commonInit() {
        super.commonInit()
        if let parent = parent {
            for _ in 0..<42 {
                cells.append(parent.createCell())
            }
        }
        for (index, cell) in cells.enumerated() {
            addSubview(cell)
            cell.tag = index
            cell.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
            cell.setTitle(String(index), for: .normal)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard cells.count == 42 else {
            return
        }
        let spacing = parent?.spacing ?? 0
        let cellLength = ((bounds.width - paddingStart - paddingEnd) - spacing * 6) / 7
        var currX = paddingStart
        var currY = paddingTop
        for i in 0..<42 {
            cells[i].frame = CGRect(
                x: currX,
                y: currY,
                width: cellLength,
                height: cellLength
            )
            cells[i].layer.cornerRadius = cellLength / 2
            cells[i].layer.masksToBounds = true
            currX += spacing + cellLength
            if i > 0 && (i + 1) % 7 == 0 {
                currX = paddingStart
                currY += spacing + cellLength
            }
        }
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let spacing = parent?.spacing ?? 0
        let maxWidth = size.width - paddingStart - paddingEnd
        let cellLength = (maxWidth - spacing * 6) / 7
        let height = cellLength * 6 + spacing * 5 + paddingTop + paddingBottom
        return CGSize(width: size.width, height: height)
    }

    func bind(_ anyDayInMonth: Date) {
        self.anyDayInMonth = anyDayInMonth
        guard
            let calendar = parent?.calendar,
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: anyDayInMonth)),
            let firstDay = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: startOfMonth)) else {
            return
        }
        self.firstDay = firstDay
        let currentMonth = calendar.dateComponents([.month], from: anyDayInMonth).month ?? -2
        for i in 0..<42 {
            if let date = calendar.date(byAdding: .day, value: i, to: firstDay) {
                let components = calendar.dateComponents([.day, .month], from: date)
                let day = components.day ?? 0
                let month = components.month ?? -1
                let cell = cells[i]

                cell.isEnabled = true
                cell.isSelected = false

                if
                    let minimumDate = parent?.minimumDate,
                    minimumDate.timeIntervalSince1970 > date.timeIntervalSince1970 {
                    cell.isEnabled = false
                } else if
                    let maximumDate = parent?.maximumDate,
                    maximumDate.timeIntervalSince1970 < date.timeIntervalSince1970 {
                    cell.isEnabled = false
                } else if month != currentMonth {
                    cell.isEnabled = false
                } else if
                    let selectedDate = parent?.selectedDate,
                    calendar.isDate(date, inSameDayAs: selectedDate) {
                    cell.isSelected = true
                }

                cell.setTitle(String(day), for: .normal)
            }
        }
    }

    @objc private func buttonPressed(sender: EDButton) {
        if let date = parent?.calendar.date(byAdding: .day, value: sender.tag, to: firstDay) {
            parent?.selectedDate = date
            parent?.notifySelection()
        }
    }
}

open class EGCalendarPicker: LinearLayout {

    public var dateSelected: ((Date) -> Void)?

    public var spacing: CGFloat = 0 {
        didSet {
            weekdayLabelsRowLayout.spacing = spacing
        }
    }
    public var calendar = Calendar.current
    public var titleDateFormatter = DateFormatter().apply {
        $0.dateFormat = "MMMM YYYY"
    }
    private var _minimumDate: Date?
    public var minimumDate: Date? {
        get {
            _minimumDate
        }
        set {
            _minimumDate = newValue.map { calendar.startOfDay(for: $0) }
            monthViewFront.anyDayInMonth.map {
                monthViewFront.bind($0)
            }
        }
    }
    private var _maximumDate: Date?
    public var maximumDate: Date? {
        get {
            _maximumDate
        }
        set {
            _maximumDate = newValue.map { calendar.startOfDay(for: $0) }
            monthViewFront.anyDayInMonth.map {
                monthViewFront.bind($0)
            }
        }
    }
    private var _selectedDate: Date?
    public var selectedDate: Date? {
        get {
            _selectedDate
        }
        set {
            _selectedDate = newValue.map { calendar.startOfDay(for: $0) }
            monthViewFront.anyDayInMonth.map {
                monthViewFront.bind($0)
            }
        }
    }

    public let titleLabel = EDLabel().apply {
        $0.paddingTop = Dimens.marginSmall
        $0.paddingBottom = Dimens.marginSmall
        $0.layoutGravity = .fill
        $0.font = Fonts.bold(Fonts.fontSizeXLarge)
        $0.marginBottom = Dimens.marginSmall
    }

    public let weekdayLabels = [
        EDLabel().apply {
            $0.font = Fonts.bold(Fonts.fontSizeMedium)
            $0.textColor = .ed_placeholderTextColor
            $0.textAlignment = .center
            $0.text = "S"
        },
        EDLabel().apply {
            $0.font = Fonts.bold(Fonts.fontSizeMedium)
            $0.textColor = .ed_placeholderTextColor
            $0.textAlignment = .center
            $0.text = "M"
        },
        EDLabel().apply {
            $0.font = Fonts.bold(Fonts.fontSizeMedium)
            $0.textColor = .ed_placeholderTextColor
            $0.textAlignment = .center
            $0.text = "T"
        },
        EDLabel().apply {
            $0.font = Fonts.bold(Fonts.fontSizeMedium)
            $0.textColor = .ed_placeholderTextColor
            $0.textAlignment = .center
            $0.text = "W"
        },
        EDLabel().apply {
            $0.font = Fonts.bold(Fonts.fontSizeMedium)
            $0.textColor = .ed_placeholderTextColor
            $0.textAlignment = .center
            $0.text = "T"
        },
        EDLabel().apply {
            $0.font = Fonts.bold(Fonts.fontSizeMedium)
            $0.textColor = .ed_placeholderTextColor
            $0.textAlignment = .center
            $0.text = "F"
        },
        EDLabel().apply {
            $0.font = Fonts.bold(Fonts.fontSizeMedium)
            $0.textColor = .ed_placeholderTextColor
            $0.textAlignment = .center
            $0.text = "S"
        }
    ]

    private lazy var weekdayLabelsRowLayout = RowLayout().apply {
        $0.spacing = spacing
        for weekdayLabel in weekdayLabels {
            $0.addSubview(weekdayLabel)
        }
    }

    public lazy var previousMonthButton = EDButton().apply {
        $0.padding = Dimens.marginSmall
        $0.setTitle("Previous", for: .normal)
        $0.setTitleColor(.ed_toolbarTextColor, for: .normal)
        $0.addTarget(self, action: #selector(previousMonthButtonPressed), for: .touchUpInside)
    }

    public lazy var nextMonthButton = EDButton().apply {
        $0.padding = Dimens.marginSmall
        $0.setTitle("Next", for: .normal)
        $0.setTitleColor(.ed_toolbarTextColor, for: .normal)
        $0.marginStart = Dimens.marginMedium
        $0.addTarget(self, action: #selector(nextMonthButtonPressed), for: .touchUpInside)
    }

    private lazy var monthViewFront = MyMonthView(parent: self)
    private lazy var monthViewBack = MyMonthView(parent: self).apply {
        $0.isHidden = true
    }
    private lazy var scrollView = EDScrollView().apply {
        $0.addSubview(monthViewBack)
        $0.addSubview(monthViewFront)
        $0.isPagingEnabled = true
        $0.isScrollEnabled = false
    }

    private lazy var leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(_:))).apply {
        $0.direction = .left
        $0.delegate = self
        $0.cancelsTouchesInView = false
    }
    private lazy var rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(_:))).apply {
        $0.direction = .right
        $0.delegate = self
        $0.cancelsTouchesInView = false
    }

    open override func commonInit() {
        super.commonInit()
        orientation = .vertical
        addSubview(LinearLayout().apply {
            $0.orientation = .horizontal
            $0.paddingBottom = Dimens.marginSmall
            $0.addSubview(titleLabel.apply {
                $0.layoutGravity = .centerVertical
                $0.layoutWeight = 1
            })
            $0.addSubview(previousMonthButton.apply {
                $0.layoutGravity = .centerVertical
            })
            $0.addSubview(nextMonthButton.apply {
                $0.layoutGravity = .centerVertical
            })
        })
        addSubview(weekdayLabelsRowLayout.apply {
            $0.marginTop = Dimens.marginSmall
            $0.marginBottom = Dimens.marginSmall
        })
        addSubview(scrollView)
        addGestureRecognizer(leftSwipeGestureRecognizer)
        addGestureRecognizer(rightSwipeGestureRecognizer)
        goToMonth(Date())
    }

    func goToMonth(_ anyDayInMonth: Date) {
        monthViewFront.bind(anyDayInMonth)
        titleLabel.text = titleDateFormatter.string(from: anyDayInMonth)
    }

    open func createCell() -> EDButton {
        SolidButton().apply {
            $0.setTitleColor(UIColor.ed_toolbarTextColor.lighter(alpha: 0.2), for: .disabled)
            $0.setTitleColor(UIColor.ed_toolbarTextColor, for: .normal)
            $0.setTitleColor(UIColor.ed_toolbarBackgroundColor, for: .highlighted)
            $0.setTitleColor(UIColor.ed_toolbarBackgroundColor, for: .selected)
            $0.setBackgroundColor(UIColor.ed_toolbarTextColor, for: .selected)
            $0.setBackgroundColor(UIColor.ed_toolbarTextColor, for: .highlighted)
        }
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let monthViewSize = monthViewFront.sizeThatFits(size)
        scrollView.layoutSize = monthViewSize
        let result = super.sizeThatFits(size)
        scrollView.layoutSize = .zero
        return result
    }

    open override func layoutSubviews() {
        let monthViewSize = monthViewFront.sizeThatFits(bounds.size)
        scrollView.layoutSize = monthViewSize
        super.layoutSubviews()
        scrollView.layoutSize = .zero

        scrollView.contentSize = CGSize(width: scrollView.bounds.width * 3, height: 1)
        scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width, y: 0), animated: false)
        monthViewFront.frame = CGRect(
            origin: CGPoint(x: scrollView.bounds.width,
                            y: 0),
            size: monthViewSize
        )
        monthViewBack.frame = monthViewFront.frame
    }

    private func gotoPreviousMonth() {
        monthViewBack.isHidden = false
        monthViewBack.frame = CGRect(
            origin: .zero,
            size: monthViewFront.bounds.size
        )
        let previousMonth = calendar.date(byAdding: .month, value: -1, to: (monthViewFront.anyDayInMonth ?? Date())) ?? Date()
        monthViewBack.bind(previousMonth)

        UIView.animate(
            withDuration: .defaultAnimation,
            animations: {
                self.scrollView.setContentOffset(.zero, animated: false)
            }, completion: { (_) in
                self.titleLabel.text = self.titleDateFormatter.string(from: previousMonth)
                self.monthViewBack.frame = self.monthViewFront.frame
                self.scrollView.bringSubviewToFront(self.monthViewBack)
                let temp = self.monthViewBack
                self.monthViewBack = self.monthViewFront
                self.monthViewFront = temp
                self.scrollView.setContentOffset(
                    CGPoint(x: self.scrollView.bounds.width, y: 0),
                    animated: false
                )
                self.scrollView.setNeedsDisplay()
                self.monthViewBack.isHidden = true
            })
    }

    private func gotoNextMonth() {
        monthViewBack.isHidden = false
        monthViewBack.frame = CGRect(
            origin: CGPoint(x: scrollView.bounds.width * 2, y: 0),
            size: monthViewFront.bounds.size
        )
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: (monthViewFront.anyDayInMonth ?? Date())) ?? Date()
        monthViewBack.bind(nextMonth)
        UIView.animate(
            withDuration: .defaultAnimation,
            animations: {
                self.scrollView.setContentOffset(
                    CGPoint(x: self.scrollView.bounds.width * 2, y: 0),
                    animated: false
                )
            }, completion: { (_) in
                self.titleLabel.text = self.titleDateFormatter.string(from: nextMonth)
                self.monthViewBack.frame = self.monthViewFront.frame
                self.scrollView.bringSubviewToFront(self.monthViewBack)
                let temp = self.monthViewBack
                self.monthViewBack = self.monthViewFront
                self.monthViewFront = temp
                self.scrollView.setContentOffset(
                    CGPoint(x: self.scrollView.bounds.width, y: 0),
                    animated: false
                )
                self.scrollView.setNeedsDisplay()
                self.monthViewBack.isHidden = true
            })
    }

    @objc private func swipeGesture(_ gestureRecognizer: UISwipeGestureRecognizer) {
        switch gestureRecognizer.direction {
        case .right:
            gotoPreviousMonth()
        case .left:
            gotoNextMonth()
        default:
            break
        }
    }

    @objc private func previousMonthButtonPressed() {
        gotoPreviousMonth()
    }

    @objc private func nextMonthButtonPressed() {
        gotoNextMonth()
    }

    func notifySelection() {
        selectedDate.map {
            dateSelected?($0)
        }
    }
}

extension EGCalendarPicker: UIGestureRecognizerDelegate {

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
