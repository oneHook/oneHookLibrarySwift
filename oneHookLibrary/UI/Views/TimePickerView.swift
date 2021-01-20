import UIKit

private class NumberScrollView: EDScrollView, UIScrollViewDelegate {

    public var cellHeight = dp(50)
    public var selectedNumber = 0

    private let contentView = LinearLayout().apply {
        $0.orientation = .vertical
    }

    private var numberCount: Int = 0
    private var lastWidth: CGFloat = 0
    private var lastHeight: CGFloat = 0

    convenience init(numberCount: Int) {
        self.init()
        self.numberCount = numberCount
        addSubview(contentView)
        delegate = self
    }

    private func generateLabel() -> EDLabel {
        EDLabel().apply {
            $0.layoutSize = CGSize(width: 0, height: cellHeight)
            $0.layoutGravity = [.fillHorizontal]
            $0.font = UIFont.systemFont(ofSize: 20)
            $0.textColor = .black
            $0.textAlignment = .center
        }
    }

    private func fillScrollView() {
        if contentView.subviews.count == 0 {
            for i in 0..<numberCount {
                contentView.addSubview(generateLabel().apply {
                    $0.text = String(i)
                })
            }
        }
        let paddingCount = (contentView.subviews.count - numberCount) / 2
        let requiredPadding = Int(ceil(bounds.height / cellHeight))
        if paddingCount < requiredPadding {
            for i in 0..<requiredPadding - paddingCount {
                contentView.insertSubview(generateLabel().apply {
                    $0.text = String(numberCount - paddingCount - i - 1)
                }, belowSubview: contentView.subviews[0])
                contentView.addSubview(generateLabel().apply {
                    $0.text = String(paddingCount + i)
                })
            }
        } else if paddingCount > requiredPadding{
            for _ in 0..<paddingCount - requiredPadding {
                contentView.subviews.first?.removeFromSuperview()
                contentView.subviews.last?.removeFromSuperview()
            }
        }
        scrollTo(number: selectedNumber, animated: false)
    }

    private func scrollTo(number: Int, animated: Bool) {
        self.selectedNumber = number
        let targetIndex = CGFloat(contentView.subviews.count - numberCount) / 2 + CGFloat(number)
        setContentOffset(
            CGPoint(
                x: 0,
                y: targetIndex * cellHeight - bounds.height / 2 + cellHeight / 2
            ),
            animated: animated)
    }

    private func checkContentOffset() {
        let paddingHeight = CGFloat(contentView.subviews.count - numberCount) / 2 * cellHeight
        let actualContentHeight = contentSize.height - 2 * paddingHeight
        if contentOffset.y < paddingHeight / 2 {
            contentOffset = CGPoint(x: 0, y: contentOffset.y + actualContentHeight)
        } else if contentOffset.y > contentSize.height - paddingHeight / 2 - bounds.height {
            contentOffset = CGPoint(x: 0, y: contentOffset.y - actualContentHeight)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard
            bounds.width > 0,
            bounds.height > 0,
            bounds.width != lastWidth,
            bounds.height != lastHeight else {
            checkContentOffset()
            return
        }

        fillScrollView()
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
        lastWidth = bounds.width
        lastHeight = bounds.height
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetIndex = targetContentOffset.pointee.y / cellHeight
        let targetIndexRounded = round(targetIndex)
        let snapY = cellHeight * (targetIndexRounded > targetIndex ? targetIndexRounded - 0.5 : targetIndexRounded + 0.5)
        targetContentOffset.pointee = CGPoint(x: 0, y: snapY)
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
