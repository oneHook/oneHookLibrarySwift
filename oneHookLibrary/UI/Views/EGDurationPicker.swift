import UIKit

public class EGDurationPicker<Hour: NumberLabel, Minute: NumberLabel>: LinearLayout {

    public struct Duration {
        var hour: Int
        var minute: Int

        public init(hour: Int, minute: Int) {
            self.hour = hour
            self.minute = minute
        }
    }

    private var hourHighlightCells = [Hour]()
    private var minuteHighlightCells = [Minute]()

    private lazy var hourPicker = NumberInfiniteScrollView<Hour>(start: 0, end: 24).apply {
        $0.orientation = .vertical
        $0.layoutWeight = 1
        $0.currentNumber = currentDuration.hour
        $0.layoutGravity = [.fillVertical]
        $0.numberSelected = { [weak self] (hour) in
            self?.onHourSelected(hour)
        }
        $0.didScroll = { [weak self] in
            self?.hourScrolled()
        }
    }

    private lazy var minutePicker = NumberInfiniteScrollView<Minute>(start: 0, end: 60, step: 5).apply {
        $0.orientation = .vertical
        $0.layoutGravity = [.fillVertical]
        $0.layoutWeight = 1
        $0.currentNumber = currentDuration.minute
        $0.numberSelected = { [weak self] (minute) in
            self?.onMinuteSelected(minute)
        }
        $0.didScroll = { [weak self] in
            self?.minuteScrolled()
        }
    }

    public let centerBar = BaseView().apply {
        $0.backgroundColor = .purple
        $0.layoutSize = CGSize(width: 0, height: dp(48))
        $0.shouldSkip = true
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = false
    }

    private let hourLabel = EDLabel().apply {
        $0.textAlignment = .center
        $0.font = Fonts.regular(Fonts.fontSizeXLarge)
        $0.textColor = .white
        $0.text = "Hours"
    }
    private let minuteLabel = EDLabel().apply {
        $0.textAlignment = .center
        $0.font = Fonts.regular(Fonts.fontSizeXLarge)
        $0.textColor = .white
        $0.text = "Min"
    }

    public var currentDuration: Duration
    public var durationSelected: ((Duration) -> Void)?

    public required init(hour: Int, minute: Int) {
        currentDuration = .init(hour: hour, minute: minute)
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func commonInit() {
        super.commonInit()
        backgroundColor = .clear
        orientation = .horizontal
        addSubview(hourPicker)
        addSubview(BaseView().apply {
            $0.layoutWeight = 1
        })
        addSubview(minutePicker)
        addSubview(BaseView().apply {
            $0.layoutWeight = 1
        })
        addSubview(centerBar.apply {
            $0.addSubview(hourLabel)
            $0.addSubview(minuteLabel)
        })
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

    public override func viewDidFirstLayout() {
        DispatchQueue.main.async {
            self.hourScrolled()
            self.minuteScrolled()
        }
    }

    private func hourScrolled() {
        pickerScrolled(picker: hourPicker, cells: &hourHighlightCells)
        hourLabel.frame = CGRect(
            x: hourPicker.frame.maxX,
            y: 0,
            width: hourPicker.frame.width,
            height: centerBar.frame.height
        )
    }
    private func minuteScrolled() {
        pickerScrolled(picker: minutePicker, cells: &minuteHighlightCells)
        minuteLabel.frame = CGRect(
            x: minutePicker.frame.maxX,
            y: 0,
            width: minutePicker.frame.width,
            height: centerBar.frame.height
        )
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
        cells[0].bind(number: centerCell.number, style: isSelectable ? .highlight : .notSelectable)
        cells[0].frame = cellFrame

        if let previous = picker.cells[safe: index - 1] {
            let cellFrame = picker.convert(previous.frame, to: centerBar)
            let isSelectable = picker.isNumberSelectable(previous.number)
            cells[1].bind(number: previous.number, style: isSelectable ? .highlight : .notSelectable)
            cells[1].frame = cellFrame
        } else {
            cells[1].frame = .zero
        }

        if let next = picker.cells[safe: index + 1] {
            let cellFrame = picker.convert(next.frame, to: centerBar)
            let isSelectable = picker.isNumberSelectable(next.number)
            cells[2].bind(number: next.number, style: isSelectable ? .highlight : .notSelectable)
            cells[2].frame = cellFrame
        } else {
            cells[2].frame = .zero
        }
    }

    @objc func onHourSelected(_ hour: Int) {
        currentDuration.hour = hour
        durationSelected?(currentDuration)
    }

    @objc func onMinuteSelected(_ minute: Int) {
        currentDuration.minute = minute
        durationSelected?(currentDuration)
    }
}