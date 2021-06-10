import UIKit

private class MyMonthView: BaseView {

    private var cells = [EDButton]()
    private weak var parent: EGCalendarPicker?

    required init(parent: EGCalendarPicker) {
        self.parent = parent
        super.init(frame: .zero)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func commonInit() {
        super.commonInit()
        if let parent = parent {
            for _ in 0..<42 {
                cells.append(parent.createCell())
            }
        }
        for (index, cell) in cells.enumerated() {
            addSubview(cell)
            cell.tag = index
            cell.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
            cell.setTitle(String(index), for: .normal)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard cells.count == 42 else {
            return
        }
        let spacing = parent?.spacing ?? 0
        let cellLength = ((bounds.width - paddingStart - paddingEnd) - spacing * 6) / 7
        var currX = paddingStart
        var currY = paddingTop
        for i in 0..<42 {
            cells[i].frame = CGRect(
                x: currX,
                y: currY,
                width: cellLength,
                height: cellLength
            )
            currX += spacing + cellLength
            if i > 0 && (i + 1) % 7 == 0 {
                currX = paddingStart
                currY += spacing + cellLength
            }
        }
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let spacing = parent?.spacing ?? 0
        let maxWidth = size.width - paddingStart - paddingEnd
        let cellLength = (maxWidth - spacing * 6) / 7
        let height = cellLength * 6 + spacing * 5 + paddingTop + paddingBottom
        return CGSize(width: size.width, height: height)
    }

    @objc private func buttonPressed(sender: EDButton) {
        print("XXX", sender.tag)
    }
}

open class EGCalendarPicker: LinearLayout {

    public var spacing: CGFloat = 0

    public let titleLabel = EDLabel().apply {
        $0.paddingTop = Dimens.marginSmall
        $0.paddingBottom = Dimens.marginSmall
        $0.text = "December, 2020"
        $0.layoutGravity = .fill
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        $0.marginBottom = Dimens.marginSmall
    }

    private lazy var monthViewFront = MyMonthView(parent: self)
    private lazy var monthViewBack = MyMonthView(parent: self)
    private lazy var scrollView = EDScrollView().apply {
        $0.addSubview(monthViewBack)
        $0.addSubview(monthViewFront)
        $0.isPagingEnabled = true
        $0.isScrollEnabled = false
    }

    private lazy var leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(_:))).apply {
        $0.direction = .left
        $0.delegate = self
        $0.cancelsTouchesInView = false
    }
    private lazy var rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(_:))).apply {
        $0.direction = .right
        $0.delegate = self
        $0.cancelsTouchesInView = false
    }

    public override func commonInit() {
        super.commonInit()
        orientation = .vertical
        addSubview(titleLabel)
        addSubview(scrollView)
        addGestureRecognizer(leftSwipeGestureRecognizer)
        addGestureRecognizer(rightSwipeGestureRecognizer)
    }

    open func createCell() -> EDButton {
        EDButton().apply {
            $0.backgroundColor = .red
        }
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let monthViewSize = monthViewFront.sizeThatFits(size)
        scrollView.layoutSize = monthViewSize
        let result = super.sizeThatFits(size)
        scrollView.layoutSize = .zero
        return result
    }

    open override func layoutSubviews() {
        let monthViewSize = monthViewFront.sizeThatFits(bounds.size)
        scrollView.layoutSize = monthViewSize
        super.layoutSubviews()
        scrollView.layoutSize = .zero

        scrollView.contentSize = CGSize(width: scrollView.bounds.width * 3, height: 1)
        scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width, y: 0), animated: false)
        monthViewFront.frame = CGRect(
            origin: CGPoint(x: scrollView.bounds.width,
                            y: 0),
            size: monthViewSize
        )
        monthViewBack.frame = monthViewFront.frame
    }

    @objc private func swipeGesture(_ gestureRecognizer: UISwipeGestureRecognizer) {
        switch gestureRecognizer.direction {
        case .right:
            print("XXX right")
            monthViewBack.frame = CGRect(
                origin: .zero,
                size: monthViewFront.bounds.size
            )
            UIView.animate(
                withDuration: .defaultAnimation,
                animations: {
                    self.scrollView.setContentOffset(.zero, animated: false)
                }, completion: { (_) in
                    self.monthViewBack.frame = self.monthViewFront.frame
                    self.bringSubviewToFront(self.monthViewBack)
                    let temp = self.monthViewBack
                    self.monthViewBack = self.monthViewFront
                    self.monthViewFront = temp
                    self.scrollView.setContentOffset(
                        CGPoint(x: self.scrollView.bounds.width, y: 0),
                        animated: false
                    )
                })
        case .left:
            print("XXX left")
            monthViewBack.frame = CGRect(
                origin: CGPoint(x: scrollView.bounds.width * 2, y: 0),
                size: monthViewFront.bounds.size
            )
            UIView.animate(
                withDuration: .defaultAnimation,
                animations: {
                    self.scrollView.setContentOffset(
                        CGPoint(x: self.scrollView.bounds.width * 2, y: 0),
                        animated: false
                    )
                }, completion: { (_) in
                    self.monthViewBack.frame = self.monthViewFront.frame
                    self.bringSubviewToFront(self.monthViewBack)
                    let temp = self.monthViewBack
                    self.monthViewBack = self.monthViewFront
                    self.monthViewFront = temp
                    self.scrollView.setContentOffset(
                        CGPoint(x: self.scrollView.bounds.width, y: 0),
                        animated: false
                    )
                })
        default:
            break
        }
    }
}

extension EGCalendarPicker: UIGestureRecognizerDelegate {

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
