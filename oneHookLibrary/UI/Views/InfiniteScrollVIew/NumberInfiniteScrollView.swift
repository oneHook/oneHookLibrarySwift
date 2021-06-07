import UIKit

open class NumberLabel: EDLabel {

    private static let numberLabelFont = Fonts.regular(Fonts.fontSizeXLarge)
    private static let numberLabelColorNormal: UIColor = .black
    private static let  numberLabelColorDisabled: UIColor = .lightGray

    public enum Style {
        case selectable
        case notSelectable
    }

    public var number: Int?

    open func bind(number: Int?, style: Style) {
        self.number = number
        backgroundColor = .clear
        padding = Dimens.marginMedium
        textAlignment = .center
        font = Self.numberLabelFont
        if style == .selectable {
            textColor = Self.numberLabelColorNormal
        } else {
            textColor = Self.numberLabelColorDisabled
        }
        text = String(number ?? 0)
    }
}

public class NumberInfiniteScrollView<T: NumberLabel>: InfiniteScrollView<T> {

    public var numberSelected: ((Int) -> Void)?

    public var numberLabelHeight = dp(48)

    private var startingNumber: Int
    private var endingNumber: Int
    private var step: Int

    private var _minNumber: Int?
    public var minNumber: Int? {
        get {
            _minNumber
        }
        set {
            if _minNumber != newValue {
                _minNumber = newValue
                invalidateCells()
                makeSureNumberRange(animated: true)
            }
        }
    }

    private var _maxNumber: Int?
    public var maxNumber: Int? {
        get {
            _maxNumber
        }
        set {
            if _maxNumber != newValue {
                _maxNumber = newValue
                invalidateCells()
                makeSureNumberRange(animated: true)
            }
        }
    }

    private var _currentNumber: Int?
    public var currentNumber: Int? {
        get {
            _currentNumber
        }
        set {
            _currentNumber = newValue
            invalidateCells()
            makeSureNumberRange(animated: true)
        }
    }

    public required init(start: Int, end: Int, step: Int = 1) {
        self.startingNumber = start
        self.endingNumber = end
        self.step = step
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setStartingNumber(_ startingNumber: Int, endingNumber: Int, step: Int) -> Bool {
        guard
            self.startingNumber != startingNumber ||
                self.endingNumber != endingNumber ||
                self.step != step else {
            return false
        }
        self.startingNumber = startingNumber
        self.endingNumber = endingNumber
        self.step = step
        var currentNumberChanged = false
        if let currentNumber = _currentNumber {
            if currentNumber < startingNumber {
                _currentNumber = startingNumber
                numberSelected?(startingNumber)
                currentNumberChanged = true
            } else if currentNumber >= endingNumber {
                _currentNumber = endingNumber - self.step
                numberSelected?(endingNumber - self.step)
                currentNumberChanged = true
            }
        }
        reload()
        layoutIfNeeded()
        print("XXX", startingNumber, endingNumber, currentNumberChanged)
        return currentNumberChanged
    }

    public override func commonInit() {
        cellDefaultHeight = numberLabelHeight
        snapToCenter = true
        super.commonInit()
    }

    public override func getCell(direction: InfiniteScrollView<T>.Direction,
                                 referenceCell: T?) -> T {
        var number: Int?
        switch direction {
        case .center:
            number = _currentNumber ?? startingNumber
        case .before:
            number = (referenceCell?.number ?? startingNumber) - step
            if (number ?? 0) < startingNumber {
                number = endingNumber - step
            }
        case .after:
            number = (referenceCell?.number ?? endingNumber) + step
            if (number ?? 0) >= endingNumber {
                number = startingNumber
            }
        }
        return dequeueCell().apply {
            $0.layoutSize = CGSize(width: 0, height: numberLabelHeight)
            $0.layoutGravity = .fillHorizontal
            var style = NumberLabel.Style.selectable
            if
                let minNumber = minNumber,
                let number = number,
                number < minNumber {
                style = .notSelectable
            } else if
                let maxNumber = maxNumber,
                let number = number,
                number > maxNumber {
                style = .notSelectable
            }
            $0.bind(number: number, style: style)
        }
    }

    public override func scrollViewDidEndInteraction(_ scrollView: UIScrollView) {
        super.scrollViewDidEndInteraction(scrollView)
        if !makeSureNumberRange(animated: true) {
            if let number = centerCell?.number {
                numberSelected?(number)
            }
        }
    }

    private func invalidateCells() {
        for cell in cells {
            var style = NumberLabel.Style.selectable
            if
                let minNumber = minNumber,
                let number = cell.number,
                number < minNumber {
                style = .notSelectable
            } else if
                let maxNumber = maxNumber,
                let number = cell.number,
                number > maxNumber {
                style = .notSelectable
            }
            cell.bind(number: cell.number, style: style)
        }
    }

    private func makeSureNumberRange(animated: Bool) -> Bool {
        guard
            !isInterationInProgress,
            let centerNumber = centerCell?.number else {
            return false
        }
        if
            let currentNumber = currentNumber,
            currentNumber != centerNumber {
//            let offset = centerNumber - currentNumber
//            setContentOffset(contentOffset.translate(x: 0, y: CGFloat(offset) * numberLabelHeight), animated: animated)
            print("XXX not at center!!!!!!", currentNumber, centerNumber)
        }
        if
            let minNumber = minNumber,
            minNumber > centerNumber {
            let offset = (minNumber - centerNumber) / step
            setContentOffset(
                contentOffset.translate(
                    x: 0,
                    y: CGFloat(offset) * numberLabelHeight
                ), animated: animated
            )
            _currentNumber = minNumber
            numberSelected?(minNumber)
            return true
        } else if
            let maxNumber = maxNumber,
            maxNumber < centerNumber {
            let offset = (maxNumber - centerNumber) / step
            setContentOffset(
                contentOffset.translate(
                    x: 0,
                    y: CGFloat(offset) * numberLabelHeight
                ), animated: animated
            )
            _currentNumber = maxNumber
            numberSelected?(maxNumber)
            return true
        }
        return false
    }
}
