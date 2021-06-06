import UIKit

public class DateLabel: EDLabel {
    var date: Date?
}

public class DateInfiniteScrollView: InfiniteScrollView<DateLabel> {

    public let dateFormatter = DateFormatter().apply {
        $0.dateFormat = "MMM dd, yyyy"
    }

    public override func commonInit() {
        cellDefaultHeight = dp(48)
        snapToCenter = true
        super.commonInit()
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
            $0.layoutSize = CGSize(width: 0, height: dp(48))
            $0.layoutGravity = .fillHorizontal
            $0.date = date
            $0.backgroundColor = .clear
            $0.textColor = .black
            $0.padding = Dimens.marginMedium
            $0.text = dateFormatter.string(from: $0.date!)
            $0.font = UIFont.systemFont(ofSize: 24)
            $0.textAlignment = .center
        }
    }

    public override func scrollViewDidEndInteraction(scrollView: UIScrollView) {
        print("XXX did stop")


        if let centerCell = cells.first(where: {
            let cellFrame = $0.frame.offsetBy(dx: 0, dy: -(scrollView.contentOffset.y - cellDefaultHeight!))
            return cellFrame.contains(
                CGPoint(x: scrollView.bounds.width / 2,
                        y: scrollView.bounds.height / 2)
            )
        }) {
            print("XXX!!!!", centerCell.date)
        }
    }
}
