import UIKit

public class EGDateTimePicker: LinearLayout {

    private let dateScrollView = DateInfiniteScrollView().apply {
        $0.orientation = .vertical
        $0.layoutWeight = 5
        $0.currrentDate = Date()
        $0.layoutGravity = [.fillVertical]
    }

    private let hourPicker = NumberInfiniteScrollView(start: 0, end: 23).apply {
        $0.orientation = .vertical
        $0.layoutGravity = [.fillVertical]
        $0.layoutWeight = 1.5
        $0.currentNumber = 0
    }

    private let minutePicker = NumberInfiniteScrollView(start: 0, end: 59).apply {
        $0.orientation = .vertical
        $0.layoutGravity = [.fillVertical]
        $0.layoutWeight = 1.5
        $0.currentNumber = 0
    }

    public let centerBar = FrameLayout().apply {
        $0.backgroundColor = .purple
        $0.layoutSize = CGSize(width: 0, height: dp(48))
        $0.shouldSkip = true
    }

    public override func commonInit() {
        super.commonInit()
        backgroundColor = .blue
        orientation = .horizontal
        addSubview(centerBar)
        addSubview(dateScrollView)
        addSubview(hourPicker)
        addSubview(minutePicker)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        centerBar.frame = CGRect(x: 0,
                                 y: (bounds.height - centerBar.layoutSize.height) / 2,
                                 width: bounds.width,
                                 height: centerBar.layoutSize.height
        )
    }
}
