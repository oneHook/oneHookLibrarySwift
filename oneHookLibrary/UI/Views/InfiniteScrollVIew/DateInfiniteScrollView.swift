import UIKit

public class DateLabel: EDLabel {
    var date: Date?
}

public class DateInfiniteScrollView: InfiniteScrollView<DateLabel> {

    public var dateSelected: ((Date) -> Void)?

    public let dateFormatter = DateFormatter().apply {
        $0.dateFormat = "MMM dd, yyyy"
    }
    public var dateLabelHeight = dp(48)
    public var dateLabelFont = UIFont.systemFont(ofSize: 24)
    public var dateLabelColorNormal: UIColor = .black
    public var dateLabelColorDisabled: UIColor = .lightGray

    private var _minDate: Date?
    public var minDate: Date? {
        get {
            _minDate
        }
        set {
            _minDate = newValue?.startOfDay
            invalidateCells()
            makeSureDateRange(animated: true)
        }
    }

    private var _maxDate: Date?
    public var maxDate: Date? {
        get {
            _maxDate
        }
        set {
            _maxDate = newValue?.startOfDay
            invalidateCells()
            makeSureDateRange(animated: true)
        }
    }

    private var _currentDate: Date?
    public var currrentDate: Date? {
        get {
            _currentDate
        }
        set {
            _currentDate = newValue?.startOfDay
            invalidateCells()
            makeSureDateRange(animated: true)
        }
    }


    public override func commonInit() {
        cellDefaultHeight = dateLabelHeight
        snapToCenter = true
        super.commonInit()
    }

    public override func getCell(direction: InfiniteScrollView<DateLabel>.Direction, referenceCell: DateLabel?) -> DateLabel {
        var date: Date?
        switch direction {
        case .center:
            date = _currentDate ?? Date().startOfDay
        case .before:
            date = referenceCell!.date?.add(days: -1)
        case .after:
            date = referenceCell!.date?.add(days: 1)
        }
        return dequeueCell().apply {
            $0.layoutSize = CGSize(width: 0, height: dateLabelHeight)
            $0.layoutGravity = .fillHorizontal
            $0.date = date
            $0.backgroundColor = .clear
            $0.padding = Dimens.marginMedium
            $0.text = dateFormatter.string(from: $0.date!)
            $0.textAlignment = .center
            $0.font = dateLabelFont
            $0.textColor = dateLabelColorNormal
            if
                let minDate = minDate,
                let date = date,
                minDate.timeIntervalSince1970 > date.timeIntervalSince1970 {
                $0.textColor = dateLabelColorDisabled
            } else if
                let maxDate = maxDate,
                let date = date,
                maxDate.timeIntervalSince1970 < date.timeIntervalSince1970 {
                $0.textColor = dateLabelColorDisabled
            }
        }
    }

    public override func scrollViewDidEndInteraction(_ scrollView: UIScrollView) {
        super.scrollViewDidEndInteraction(scrollView)
        makeSureDateRange(animated: true)
    }

//    public override func scrollViewDidStopAtCenterCell(_ scrollView: UIScrollView, centerCell: DateLabel) {
//        _currentDate = centerCell.date
//        if let date = centerCell.date {
//            dateSelected?(date)
//        }
//    }

    private func invalidateCells() {
        for cell in cells {
            cell.font = dateLabelFont
            cell.textColor = dateLabelColorNormal
            if
                let minDate = minDate,
                let date = cell.date,
                minDate.timeIntervalSince1970 > date.timeIntervalSince1970 {
                cell.textColor = dateLabelColorDisabled
            } else if
                let maxDate = maxDate,
                let date = cell.date,
                maxDate.timeIntervalSince1970 < date.timeIntervalSince1970 {
                cell.textColor = dateLabelColorDisabled
            }
        }
    }

    private func makeSureDateRange(animated: Bool) {
        guard
            !isInterationInProgress,
            let centerDate = centerCell?.date else {
            return
        }

        if
            let currentDate = currrentDate,
            currentDate.timeIntervalSince1970 != centerDate.timeIntervalSince1970,
            let day = Calendar.current.dateComponents([.day], from: centerDate, to: currentDate).day {
            setContentOffset(contentOffset.translate(x: 0, y: CGFloat(day) * dateLabelHeight), animated: animated)
        } else if
            let minDate = minDate,
            minDate.timeIntervalSince1970 > centerDate.timeIntervalSince1970,
            let day = Calendar.current.dateComponents([.day], from: centerDate, to: minDate).day {
            setContentOffset(contentOffset.translate(x: 0, y: CGFloat(day) * dateLabelHeight), animated: animated)
            _currentDate = minDate
        } else if
            let maxDate = maxDate,
            maxDate.timeIntervalSince1970 < centerDate.timeIntervalSince1970,
            let day = Calendar.current.dateComponents([.day], from: centerDate, to: maxDate).day {
            setContentOffset(contentOffset.translate(x: 0, y: CGFloat(day) * dateLabelHeight), animated: animated)
            _currentDate = maxDate
        }
    }
}
