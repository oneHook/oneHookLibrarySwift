import UIKit

open class NumberLabel: EDLabel {

    public enum Style {
        case selectable
        case notSelectable
    }

    public var number: Int?

    open func bind(number: Int?, style: Style) {
        self.number = number
        backgroundColor = .clear
        textAlignment = .center
        font = Fonts.regular(Fonts.fontSizeXLarge)
        switch style {
        case .selectable:
            textColor = .ed_toolbarTextColor
        case .notSelectable:
            textColor = UIColor.ed_toolbarTextColor.lighter(alpha: 0.2)
        }
        text = String(number ?? 0)
    }
}

public class NumberInfiniteScrollView<T: NumberLabel>: InfiniteScrollView<T> {

    public var numberSelected: ((Int) -> Void)?
    public var didScroll: (() -> Void)?

    public var numberLabelHeight = dp(48) {
        didSet {
            cellDefaultWidth = numberLabelHeight
        }
    }

    /// Range starts. can be <= minNumber
    public var startingNumber: Int

    /// Rnage ends. can be >= maxNumber
    public var endingNumber: Int

    /// Interval between two numbers
    public var step: Int

    public var minNumber: Int?
    public var maxNumber: Int?
    public var currentNumber: Int?

    public required init(start: Int, end: Int, step: Int = 1) {
        self.startingNumber = start
        self.endingNumber = end
        self.step = step
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var _currentStartingNumber: Int?
    private var _currentEndingNumber: Int?
    private var _currentStep: Int?

    override func reload() {
        super.reload()
        _currentStartingNumber = startingNumber
        _currentEndingNumber = endingNumber
        _currentStep = step
    }

    /// Update the whole view based on new properties such as
    /// starting number/ending number/step/min number/max number/current number
    /// Returns true if selected number will change, false otherwise
    @discardableResult
    public func update(animated: Bool) -> Bool {
        invalidateCells()

        /* If any of the following attributes are different than current one, we need reload */
        if _currentStartingNumber != startingNumber ||
            _currentEndingNumber != endingNumber ||
            _currentStep != step {
            let oldNumber = currentNumber
            if var currentNumber = currentNumber {
                currentNumber = max(startingNumber, currentNumber)
                currentNumber = min(endingNumber - step, currentNumber)
                if let minNumber = minNumber {
                    currentNumber = max(minNumber, currentNumber)
                }
                if let maxNumber = maxNumber {
                    currentNumber = min(maxNumber, currentNumber)
                }
                self.currentNumber = currentNumber
            }
            reload()
            setNeedsLayout()
            layoutIfNeeded()
            if oldNumber != currentNumber {
                currentNumber.map { numberSelected?($0) }
                return true
            }
            return false
        }

        /* if only update current number/min/max, we can just make sure it scrolls to the
           right position
         */

        return makeSureNumberRange(animated: animated)
    }

    public override func commonInit() {
        cellDefaultHeight = numberLabelHeight
        snapToCenter = true
        super.commonInit()
    }

    private var bestCenterNumber: Int {
        var number = currentNumber ?? startingNumber
        if let minNumber = minNumber {
            number = max(minNumber, number)
        }
        if let maxNumber = maxNumber {
            number = min(maxNumber, number)
        }
        return number
    }

    public func setNumber(_ number: Int, animated: Bool) {
        currentNumber = number
        makeSureNumberRange(animated: animated)
    }

    public func isNumberSelectable(_ number: Int?) -> Bool {
        if
            let minNumber = minNumber,
            let number = number,
            number < minNumber {
            return false
        } else if
            let maxNumber = maxNumber,
            let number = number,
            number > maxNumber {
            return false
        }
        return true
    }

    public override func getCell(direction: InfiniteScrollView<T>.Direction,
                                 referenceCell: T?) -> T {
        var number: Int?
        switch direction {
        case .center:
            number = bestCenterNumber
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
            if !isNumberSelectable(number) {
                style = .notSelectable
            }
            $0.bind(number: number, style: style)
        }
    }

    public override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll?()
        for cell in cells {
            let cellCenterY = cell.center.y
            let centerOffset = cellCenterY - (scrollView.contentOffset.y + scrollView.bounds.height / 2)
            let progress = 1 - (abs(centerOffset) / (scrollView.bounds.height / 2))
            cell.alpha = max(0, progress)
        }
    }

    public override func scrollViewDidEndInteraction(_ scrollView: UIScrollView) {
        super.scrollViewDidEndInteraction(scrollView)
        currentNumber = centerCell?.number
        if !makeSureNumberRange(animated: true) {
            if let number = currentNumber {
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
            let centerNumber = centerCell?.number,
            var currentNumber = currentNumber else {
            return false
        }
        if let minNumber = minNumber {
            currentNumber = max(minNumber, currentNumber)
        }
        if let maxNumber = maxNumber {
            currentNumber = min(maxNumber, currentNumber)
        }
        if currentNumber != centerNumber {
            let offset = (currentNumber - centerNumber) / step
            setContentOffset(contentOffset.translate(x: 0, y: CGFloat(offset) * numberLabelHeight), animated: animated)
            self.currentNumber = currentNumber
            numberSelected?(currentNumber)
            return true
        } else {
            return false
        }
    }
}
