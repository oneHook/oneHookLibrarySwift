import oneHookLibrary
import UIKit

class InfiniteScrollViewDemoViewController: BaseScrollableDemoViewController {

    private let hourPicker = NumberInfiniteScrollView(start: 0, end: 24).apply {
        $0.orientation = .vertical
        $0.layoutGravity = [.fill]
        $0.currentNumber = 7
        $0.minNumber = 3
        $0.maxNumber = 15
        $0.numberSelected = { (number) in
            print("XXX Hour selected", number)
        }
    }

    private lazy var hourContainer = FrameLayout().apply {
        $0.backgroundColor = .gray
        $0.marginTop = Dimens.marginMedium
        $0.layoutSize = CGSize(width: 0, height: dp(250))
        $0.layoutGravity = .fillHorizontal
        $0.addSubview(FrameLayout().apply {
            $0.layoutSize = CGSize(width: 0, height: dp(48))
            $0.layoutGravity = [.fillHorizontal, .centerVertical]
            $0.backgroundColor = .purple
        })
        $0.addSubview(hourPicker)
    }

    private let minutePicker = NumberInfiniteScrollView(start: 0, end: 60, step: 5).apply {
        $0.orientation = .vertical
        $0.layoutGravity = [.fill]
        $0.minNumber = 10
        $0.maxNumber = 30
        $0.update(animated: false)
        $0.numberSelected = { (number) in
            print("XXX minute selected", number)
        }
    }

    private lazy var minuteContainer = FrameLayout().apply {
        $0.backgroundColor = .gray
        $0.marginTop = Dimens.marginMedium
        $0.layoutSize = CGSize(width: 0, height: dp(250))
        $0.layoutGravity = .fillHorizontal
        $0.addSubview(FrameLayout().apply {
            $0.layoutSize = CGSize(width: 0, height: dp(48))
            $0.layoutGravity = [.fillHorizontal, .centerVertical]
            $0.backgroundColor = .purple
        })
        $0.addSubview(minutePicker)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarTitle = "Infinite Scroll View"
        contentLinearLayout.addSubview(hourContainer)
        contentLinearLayout.addSubview(minuteContainer)
    }
}
