import UIKit

public class DateLabel: EDLabel {
    var date: Date?
}

public class DateInfiniteScrollView: InfiniteScrollView<DateLabel> {

    public let dateFormatter = DateFormatter().apply {
        $0.dateFormat = "MMM dd, yyyy"
    }

    public override func getCell(direction: InfiniteScrollView<DateLabel>.Direction, referenceCell: DateLabel?) -> DateLabel {
        var date: Date?
        switch direction {
        case .center:
            date = Date()
        case .before:
            date = referenceCell!.date?.add(days: -1)
        case .after:
            date = referenceCell!.date?.add(days: 1)
        }
        return dequeueCell().apply {
            $0.date = date
            $0.backgroundColor = UIColor.random()
            $0.textColor = .black
            $0.padding = Dimens.marginMedium
            $0.text = dateFormatter.string(from: $0.date!)
            $0.font = UIFont.systemFont(ofSize: 24)
            $0.textAlignment = .center
        }
    }
}
