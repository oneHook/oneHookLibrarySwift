import UIKit

private class NumberScrollView: EDScrollView {

    private let contentView = LinearLayout().apply {
        $0.orientation = .vertical
    }

    private var numberCount: Int = 0
    private var lastWidth: CGFloat = 0
    private var lastHeight: CGFloat = 0

    convenience init(numberCount: Int) {
        self.init()

        self.numberCount = numberCount
        for i in 0..<numberCount {
            contentView.addSubview(generateLabel().apply {
                $0.text = String(i)
            })
        }
        addSubview(contentView)
    }

    private func generateLabel() -> EDLabel {
        EDLabel().apply {
            $0.layoutSize = CGSize(width: 0, height: dp(50))
            $0.layoutGravity = [.fillHorizontal]
            $0.font = UIFont.systemFont(ofSize: 20)
            $0.textColor = .black
            $0.textAlignment = .center
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if bounds.width != lastWidth || bounds.height != lastHeight {
            let contentSize = contentView.sizeThatFits(
                CGSize(width: bounds.width,
                       height: CGFloat.greatestFiniteMagnitude)
            )
            contentView.frame = CGRect(origin: .zero,
                                       size: CGSize(
                                        width: bounds.width,
                                        height: contentSize.height
                                       )
            )
            self.contentSize = contentSize
            print("XXX", contentSize)
        }
        lastWidth = bounds.width
        lastHeight = bounds.height
    }
}

public class TimePickerView: BaseControl {
    private var hourScrollView = NumberScrollView(numberCount: 24)
    private var minuteScrollView = NumberScrollView(numberCount: 60)

    public override func commonInit() {
        super.commonInit()
        hourScrollView.backgroundColor = .green
        minuteScrollView.backgroundColor = .yellow
        addSubview(hourScrollView)
        addSubview(minuteScrollView)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        hourScrollView.frame = CGRect(
            x: 0,
            y: 0,
            width: bounds.width / 2,
            height: bounds.height
        )
        minuteScrollView.frame = CGRect(
            x: bounds.width / 2,
            y: 0,
            width: bounds.width / 2,
            height: bounds.height
        )
    }
}
