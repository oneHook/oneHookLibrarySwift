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

//    let infiniteScrollView1 = NumberInfiniteScrollView().apply {
//        $0.orientation = .horizontal
//        $0.layoutSize = CGSize(width: 0, height: dp(150))
//        $0.layoutGravity = [.fillHorizontal]
//        $0.backgroundColor = .white
//        $0.isPagingEnabled = true
//    }
//
//    let infiniteScrollView2 = NumberInfiniteScrollView().apply {
//        $0.orientation = .vertical
//        $0.layoutSize = CGSize(width: 0, height: dp(200))
//        $0.layoutGravity = [.fillHorizontal]
//        $0.backgroundColor = .white
//        $0.isPagingEnabled = true
//    }

    private let datePicker = DateInfiniteScrollView().apply {
        $0.orientation = .vertical
        $0.layoutGravity = [.fill]
        $0.currrentDate = Date().add(days: -5)
        $0.minDate = Date().startOfDay.add(days: -15)
        $0.maxDate = Date().startOfDay.add(days: 15)
    }

    private lazy var dateContainer = FrameLayout().apply {
        $0.backgroundColor = .gray
        $0.marginTop = Dimens.marginMedium
        $0.layoutSize = CGSize(width: 0, height: dp(250))
        $0.layoutGravity = .fillHorizontal
        $0.addSubview(FrameLayout().apply {
            $0.layoutSize = CGSize(width: 0, height: dp(48))
            $0.layoutGravity = [.fillHorizontal, .centerVertical]
            $0.backgroundColor = .purple
        })
        $0.addSubview(datePicker)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarTitle = "Infinite Scroll View"
//        contentLinearLayout.addSubview(infiniteScrollView1)
//        contentLinearLayout.addSubview(infiniteScrollView2)
        contentLinearLayout.addSubview(dateContainer)
        contentLinearLayout.addSubview(SolidButton().apply {
            $0.marginTop = Dimens.marginMedium
            $0.setBackgroundColor(.red, for: .normal)
            $0.padding = Dimens.marginMedium
            $0.setTitle("Debug", for: .normal)
            $0.addTarget(self, action: #selector(debugButtonPressed), for: .touchUpInside)
        })
    }

    @objc private func debugButtonPressed() {
        print("XXX", datePicker.contentOffset)
//        datePicker.setContentOffset(.init(x: 0, y: datePicker.contentOffset.y - dp(48) * 365), animated: true)
        datePicker.minDate = Date()
    }
}
