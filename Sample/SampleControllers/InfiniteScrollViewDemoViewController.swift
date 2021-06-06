import oneHookLibrary
import UIKit

class NumberInfiniteScrollView: InfiniteScrollView<EDLabel> {

    override func getCell(direction: InfiniteScrollView<EDLabel>.Direction, referenceCell: EDLabel?) -> EDLabel {
        var n = 0
        if direction == .before {
            n = referenceCell!.tag - 1
        }
        if direction == .after {
            n = referenceCell!.tag + 1
        }
        return dequeueCell().apply {
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
        $0.orientation = .vertical
        $0.layoutSize = CGSize(width: 0, height: dp(250))
        $0.layoutGravity = [.fillHorizontal]
        $0.backgroundColor = .gray
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarTitle = "Infinite Scroll View"
        contentLinearLayout.addSubview(infiniteScrollView1)
        contentLinearLayout.addSubview(infiniteScrollView2)
        contentLinearLayout.addSubview(infiniteScrollView3)
    }
}
