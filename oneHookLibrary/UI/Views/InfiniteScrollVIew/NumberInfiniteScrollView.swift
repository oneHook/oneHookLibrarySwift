import UIKit

public class NumberLabel: EDLabel {
    var number: Int?
}

public class NumberInfiniteScrollView: InfiniteScrollView<NumberLabel> {

    public var numberSelected: ((Int) -> Void)?

    public var numberLabelHeight = dp(48)
    public var numberLabelFont = UIFont.systemFont(ofSize: 24)
    public var numberLabelColorNormal: UIColor = .black
    public var numberLabelColorDisabled: UIColor = .lightGray

    private var startingNumber: Int
    private var endingNumber: Int

    private var _minNumber: Int?
    public var minNumber: Int? {
        get {
            _minNumber
        }
        set {
            _minNumber = newValue
            invalidateCells()
            makeSureNumberRange(animated: true)
        }
    }

    private var _maxNumber: Int?
    public var maxNumber: Int? {
        get {
            _maxNumber
        }
        set {
            _maxNumber = newValue
            invalidateCells()
            makeSureNumberRange(animated: true)
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

    public required init(start: Int, end: Int) {
        self.startingNumber = start
        self.endingNumber = end
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func commonInit() {
        cellDefaultHeight = numberLabelHeight
        snapToCenter = true
        super.commonInit()
    }

    public override func getCell(direction: InfiniteScrollView<NumberLabel>.Direction,
                                 referenceCell: NumberLabel?) -> NumberLabel {
        var number: Int?
        switch direction {
        case .center:
            number = _currentNumber ?? startingNumber
        case .before:
            number = (referenceCell?.number ?? startingNumber) - 1
            if (number ?? 0) < startingNumber {
                number = endingNumber
            }
        case .after:
            number = (referenceCell?.number ?? endingNumber) + 1
            if (number ?? 0) > endingNumber {
                number = startingNumber
            }
        }
        return dequeueCell().apply {
            $0.layoutSize = CGSize(width: 0, height: numberLabelHeight)
            $0.layoutGravity = .fillHorizontal
            $0.number = number
            $0.backgroundColor = .clear
            $0.padding = Dimens.marginMedium
            $0.text = String(number ?? 0)
            $0.textAlignment = .center
            $0.font = numberLabelFont
            $0.textColor = numberLabelColorNormal
            if
                let minNumber = minNumber,
                let number = number,
                number < minNumber {
                $0.textColor = numberLabelColorDisabled
            } else if
                let maxNumber = maxNumber,
                let number = number,
                number > maxNumber {
                $0.textColor = numberLabelColorDisabled
            }
        }
    }

    public override func scrollViewDidEndInteraction(_ scrollView: UIScrollView) {
        super.scrollViewDidEndInteraction(scrollView)
        makeSureNumberRange(animated: true)
    }

    public override func scrollViewDidStopAtCenterCell(_ scrollView: UIScrollView, centerCell: NumberLabel) {
        _currentNumber = centerCell.number
        if let number = centerCell.number {
            numberSelected?(number)
        }
    }

    private func invalidateCells() {
        for cell in cells {
            cell.font = numberLabelFont
            cell.textColor = numberLabelColorNormal
            if
                let minNumber = minNumber,
                let number = cell.number,
                number < minNumber {
                cell.textColor = numberLabelColorDisabled
            } else if
                let maxNumber = maxNumber,
                let number = cell.number,
                number > maxNumber {
                cell.textColor = numberLabelColorDisabled
            }
        }
    }

    private func makeSureNumberRange(animated: Bool) {
        guard
            !isInterationInProgress,
            let centerNumber = centerCell?.number else {
            return
        }

        if
            let currentNumber = currentNumber,
            currentNumber != centerNumber {
            let offset = centerNumber - currentNumber
            setContentOffset(contentOffset.translate(x: 0, y: CGFloat(offset) * numberLabelHeight), animated: animated)
        } else if
            let minNumber = minNumber,
            minNumber > centerNumber {
            let offset = centerNumber - minNumber
            setContentOffset(contentOffset.translate(x: 0, y: CGFloat(offset) * numberLabelHeight), animated: animated)
            _currentNumber = minNumber
        } else if
            let maxNumber = maxNumber,
            maxNumber < centerNumber {
            let offset = centerNumber - maxNumber
            setContentOffset(contentOffset.translate(x: 0, y: CGFloat(offset) * numberLabelHeight), animated: animated)
            _currentNumber = maxNumber
        }
    }
}
