import UIKit

// This is used as an input accessory view and relays .center changes for tracking keybaord dismiss mode .interactive
public class KeyboardInputObserver: BaseView {
    private var observation: NSKeyValueObservation?
    public var frameDidChange: ((UIView) -> Void)?

    // This view requires a height so that the interactive dismiss gesture starts at the correct point.
    // The view is transparent with the actual input view laid out underneath.
    public var height: CGFloat = 0 {
        didSet {
            if oldValue != height {
                invalidateIntrinsicContentSize()
            }
        }
    }

    public override func commonInit() {
        // flexibleHeight required for inputAccessoryView self sizing
        autoresizingMask = .flexibleHeight
        isUserInteractionEnabled = false
    }

    deinit {
        observation?.invalidate()
    }

    public override var intrinsicContentSize: CGSize {
        .init(width: frame.width, height: height)
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        intrinsicContentSize
    }

    public override func didMoveToWindow() {
        if window != nil {
            if observation == nil {
                observation = superview?.observe(\.center, options: .new, changeHandler: { [weak self] (_, _) in
                    self.map { $0.frameDidChange?($0) }
                })
            }
        } else {
            observation?.invalidate()
            observation = nil
        }
    }
}
