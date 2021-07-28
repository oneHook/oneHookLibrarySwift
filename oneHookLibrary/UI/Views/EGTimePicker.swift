import UIKit


open class EGTimePicker<HourCell: NumberLabel,
                        MinuteCell: NumberLabel,
                        AmPmCell: NumberLabel>: LinearLayout, UIScrollViewDelegate {

    public struct Time {
        public var hour: Int
        public var minute: Int
        public var isAm: Bool

        public init(hour: Int, minute: Int, isAm: Bool) {
            self.hour = hour
            self.minute = minute
            self.isAm = isAm
        }
    }

    public var cellWidth = dp(48) {
        didSet {
            hourPicker.cellDefaultWidth = cellWidth
            minutePicker.cellDefaultWidth = cellWidth
            amPmPicker.layoutSize = CGSize(width: cellWidth, height: 0)
            setNeedsLayout()
        }
    }

    public var cellHeight = dp(48) {
        didSet {
            centerBar.layoutSize = CGSize(width: 0, height: cellHeight)
            hourPicker.numberLabelHeight = cellHeight
            minutePicker.numberLabelHeight = cellHeight
        }
    }

    public var highlightBackgroundColor = UIColor.ed_toolbarTextColor {
        didSet {
            centerBar.backgroundColor = highlightBackgroundColor
        }
    }

    public var highlightTextColor = UIColor.ed_toolbarBackgroundColor {
        didSet {
            for cell in hourHighlightCells {
                cell.textColor = highlightTextColor
            }
            for cell in minuteHighlightCells {
                cell.textColor = highlightTextColor
            }
        }
    }

    private var hourHighlightCells = [HourCell]()
    private var minuteHighlightCells = [MinuteCell]()
    private var amPmHighlightCells = [AmPmCell]()

    private lazy var hourPicker = NumberInfiniteScrollView<HourCell>(start: 1, end: 12).apply {
        $0.orientation = .vertical
        $0.cellDefaultWidth = cellWidth
        $0.currentNumber = currentTime.hour
        $0.layoutGravity = [.fillVertical]
        $0.numberSelected = { [weak self] (hour) in
            self?.onHourSelected(hour)
        }
        $0.didScroll = { [weak self] in
            self?.hourScrolled()
        }
    }

    private lazy var minutePicker = NumberInfiniteScrollView<MinuteCell>(start: 0, end: 60, step: step).apply {
        $0.orientation = .vertical
        $0.cellDefaultWidth = cellWidth
        $0.layoutGravity = [.fillVertical]
        $0.currentNumber = currentTime.minute
        $0.numberSelected = { [weak self] (minute) in
            self?.onMinuteSelected(minute)
        }
        $0.didScroll = { [weak self] in
            self?.minuteScrolled()
        }
    }

    private lazy var amPmPicker = EDScrollView().apply {
        $0.layoutSize = CGSize(width: cellWidth, height: 0)
        $0.layoutGravity = .fillVertical
        $0.showsVerticalScrollIndicator = false
        $0.delegate = self
        $0.addSubview(AmPmCell().apply {
            $0.bind(number: 0, style: .selectable)
        })
        $0.addSubview(AmPmCell().apply {
            $0.bind(number: 1, style: .selectable)
        })
        $0.addSubview(AmPmCell())
        $0.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(amPmPressed))
        )
        $0.isScrollEnabled = true
    }

    public lazy var centerBar = BaseView().apply {
        $0.backgroundColor = highlightBackgroundColor
        $0.layoutSize = CGSize(width: 0, height: cellHeight)
        $0.shouldSkip = true
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = false
    }

    private let step: Int
    public var currentTime: Time {
        didSet {
            hourPicker.setNumber(currentTime.hour, animated: true)
            minutePicker.setNumber(currentTime.minute, animated: true)
            if currentTime.isAm {
                amPmPicker.setContentOffset(
                    CGPoint(x: 0, y: -amPmPicker.contentInset.top),
                    animated: true
                )
            } else {
                amPmPicker.setContentOffset(
                    CGPoint(x: 0, y: cellHeight - amPmPicker.contentInset.top),
                    animated: true
                )
            }
        }
    }
    public var timeSelected: ((Time) -> Void)?

    public required init(hour: Int, minute: Int, isAm: Bool, step: Int = 1) {
        self.step = step
        currentTime = .init(hour: hour, minute: minute, isAm: isAm)
        super.init(frame: .zero)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func commonInit() {
        super.commonInit()
        contentGravity = .centerHorizontal
        backgroundColor = .clear
        orientation = .horizontal
        addSubview(hourPicker)
        addSubview(minutePicker)
        addSubview(amPmPicker)
        addSubview(centerBar)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        centerBar.frame = CGRect(
            x: 0,
            y: (bounds.height - centerBar.layoutSize.height) / 2,
            width: bounds.width,
            height: centerBar.layoutSize.height
        )
        amPmPicker.subviews[0].frame = CGRect(
            x: 0,
            y: 0,
            width: cellWidth,
            height: cellHeight
        )
        amPmPicker.subviews[1].frame = amPmPicker.subviews[0].frame.offsetBy(
            dx: 0,
            dy: cellHeight
        )
        amPmPicker.contentSize = CGSize(width: cellWidth, height: cellHeight * 2)
        amPmPicker.contentInset = UIEdgeInsets(
            top: (amPmPicker.bounds.height - cellHeight) / 2,
            left: 0,
            bottom: (amPmPicker.bounds.height - cellHeight) / 2,
            right: 0
        )

        /* Make sure Am/Pm Selection */
        if currentTime.isAm {
            amPmPicker.setContentOffset(
                CGPoint(x: 0, y: -amPmPicker.contentInset.top),
                animated: false
            )
        } else {
            amPmPicker.setContentOffset(
                CGPoint(x: 0, y: cellHeight - amPmPicker.contentInset.top),
                animated: false
            )
        }
    }

    public override func viewDidFirstLayout() {
        DispatchQueue.main.async {
            self.hourScrolled()
            self.minuteScrolled()
        }
    }

    private func hourScrolled() {
        pickerScrolled(picker: hourPicker, cells: &hourHighlightCells)
    }
    private func minuteScrolled() {
        pickerScrolled(picker: minutePicker, cells: &minuteHighlightCells)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if amPmHighlightCells.isEmpty {
            amPmHighlightCells.append(AmPmCell())
            amPmHighlightCells.append(AmPmCell())
            for cell in amPmHighlightCells {
                centerBar.addSubview(cell)
            }
        }

        let cellFrame1 = amPmPicker.convert(amPmPicker.subviews[0].frame, to: centerBar)
        amPmHighlightCells[0].bind(number: 0, style: .selectable)
        amPmHighlightCells[0].textColor = highlightTextColor
        amPmHighlightCells[0].frame = cellFrame1

        let cellFrame2 = amPmPicker.convert(amPmPicker.subviews[1].frame, to: centerBar)
        amPmHighlightCells[1].bind(number: 1, style: .selectable)
        amPmHighlightCells[1].textColor = highlightTextColor
        amPmHighlightCells[1].frame = cellFrame2
    }

    private func amPmSelected() {
        let offsetY = amPmPicker.contentOffset.y + amPmPicker.contentInset.top
        if offsetY < cellHeight / 2 {
            amPmPicker.setContentOffset(amPmPicker.topOffset, animated: true)
            onAmPmSelected(true)
        } else {
            amPmPicker.setContentOffset(amPmPicker.bottomOffset, animated: true)
            onAmPmSelected(false)
        }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        amPmSelected()
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            amPmSelected()
        }
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

    @objc private func amPmPressed() {
        UIView.animate(
            withDuration: .defaultAnimationSmall,
            animations: {
                if !self.currentTime.isAm {
                    self.amPmPicker.setContentOffset(
                        CGPoint(x: 0, y: -self.amPmPicker.contentInset.top),
                        animated: false
                    )
                } else {
                    self.amPmPicker.setContentOffset(
                        CGPoint(x: 0, y: self.cellHeight - self.amPmPicker.contentInset.top),
                        animated: false
                    )
                }
            }, completion: { (_) in
                self.amPmSelected()
            })

        onAmPmSelected(!currentTime.isAm)
    }

    @objc private func onHourSelected(_ hour: Int) {
        guard currentTime.hour != hour else {
            return
        }
        currentTime.hour = hour
        timeSelected?(currentTime)
    }

    @objc private func onMinuteSelected(_ minute: Int) {
        guard currentTime.minute != minute else {
            return
        }
        currentTime.minute = minute
        timeSelected?(currentTime)
    }

    private func onAmPmSelected(_ isAm: Bool) {
        guard currentTime.isAm != isAm else {
            return
        }
        currentTime.isAm = isAm
        timeSelected?(currentTime)
    }

    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let result = super.hitTest(point, with: event)
        if result == self {
            if point.x < bounds.width / 2 {
                return hourPicker.centerCell
            } else {
                return minutePicker.centerCell
            }
        }
        return result
    }
}

