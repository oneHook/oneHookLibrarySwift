import oneHookLibrary
import UIKit

class InfiniteScrollViewDemoViewController: BaseScrollableDemoViewController {

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

    private let hourPicker = NumberInfiniteScrollView(start: 0, end: 23).apply {
        $0.orientation = .vertical
        $0.layoutGravity = [.fill]
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

    private let minutePicker = NumberInfiniteScrollView(start: 0, end: 59).apply {
        $0.orientation = .vertical
        $0.layoutGravity = [.fill]
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

    private let dateTimePicker = EGDateTimePicker().apply {

        $0.marginTop = Dimens.marginMedium
        $0.layoutSize = CGSize(width: 0, height: dp(250))
        $0.layoutGravity = .fillHorizontal
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarTitle = "Infinite Scroll View"
        contentLinearLayout.addSubview(dateTimePicker)
        contentLinearLayout.addSubview(dateContainer)
        contentLinearLayout.addSubview(hourContainer)
        contentLinearLayout.addSubview(minuteContainer)
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
