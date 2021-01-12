import oneHookLibrary
import UIKit

class NumberInfiniteScrollView: InfiniteScrollView<EDLabel> {

    private var recycledCells = [EDLabel]()

    override func getCell(direction: InfiniteScrollView<EDLabel>.Direction, referenceCell: EDLabel?) -> EDLabel {
        var n = 0
        if direction == .before {
            n = referenceCell!.tag - 1
        }
        if direction == .after {
            n = referenceCell!.tag + 1
        }
        return (recycledCells.isEmpty ? EDLabel() : recycledCells.removeLast()).apply {
            if orientation == Orientation.horizontal {
                $0.layoutSize = CGSize(width: dp(100), height: bounds.height)
            } else {
                $0.layoutSize = CGSize(width: bounds.width, height: dp(50))
            }
            $0.backgroundColor = UIColor.random()
            $0.textColor = .black
            $0.text = String(n)
            $0.font = UIFont.systemFont(ofSize: 24)
            $0.textAlignment = .center
            $0.tag = n
        }
    }

    override func destroyCell(_ cell: EDLabel) {
        recycledCells.append(cell)
    }
}

private class DateLabel: EDLabel {
    var date: Date?
}

private class DateInfiniteScrollView: InfiniteScrollView<DateLabel> {

    private var recycledCells = [DateLabel]()
    private let dateFormatter = DateFormatter().apply {
        $0.dateFormat = "MMM dd,yyyy"
    }

    override func getCell(direction: InfiniteScrollView<DateLabel>.Direction, referenceCell: DateLabel?) -> DateLabel {
        var date: Date?
        switch direction {
        case .center:
            date = Date()
        case .before:
            date = referenceCell!.date?.add(days: -1)
        case .after:
            date = referenceCell!.date?.add(days: 1)
        }
        return (recycledCells.isEmpty ? DateLabel() : recycledCells.removeLast()).apply {
            $0.date = date
            $0.backgroundColor = UIColor.random()
            $0.textColor = .black
            $0.padding = Dimens.marginMedium
            $0.text = dateFormatter.string(from: $0.date!)
            $0.font = UIFont.systemFont(ofSize: 24)
            $0.textAlignment = .center
        }
    }

    override func destroyCell(_ cell: DateLabel) {
        recycledCells.append(cell)
    }
}

class InfiniteScrollViewDemoViewController: BaseScrollableDemoViewController {

    let infiniteScrollView1 = NumberInfiniteScrollView().apply {
        $0.orientation = .horizontal
        $0.layoutSize = CGSize(width: 0, height: dp(150))
        $0.layoutGravity = [.fillHorizontal]
        $0.backgroundColor = .white
        $0.isPagingEnabled = true
    }

    let infiniteScrollView2 = NumberInfiniteScrollView().apply {
        $0.orientation = .vertical
        $0.layoutSize = CGSize(width: 0, height: dp(200))
        $0.layoutGravity = [.fillHorizontal]
        $0.backgroundColor = .white
        $0.isPagingEnabled = true
    }

    private let infiniteScrollView3 = DateInfiniteScrollView().apply {
        $0.orientation = .horizontal
        $0.layoutSize = CGSize(width: 0, height: dp(150))
        $0.layoutGravity = [.fillHorizontal]
        $0.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarTitle = "Infinite Scroll View"
        contentLinearLayout.addSubview(infiniteScrollView1)
        contentLinearLayout.addSubview(infiniteScrollView2)
        contentLinearLayout.addSubview(infiniteScrollView3)
    }
}
