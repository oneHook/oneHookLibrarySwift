import UIKit

open class TappableBaseView: BaseView, Tappable, Highlightable {

    public let tapRecognizer = UITapGestureRecognizer().apply {
        $0.isEnabled = false
    }

    public var didTap: ((UIView) -> Void)?

    /// nil highlightColor == disabled
    public var highlightColor: UIColor? {
        didSet {
            tapRecognizer.isEnabled = highlightColor != nil
        }
    }

    public var highlightInsets: UIEdgeInsets? = .zero

    // Insert and remove a background view to show highlighting.
    // Obviates changing and remembering the view backgroundColor, and allows customizing the highlight bounds
    private lazy var highlightBackground: OptionalBuilder<UIView> = optionalBuilder({ [weak self] in
        let view = UIView()
        view.backgroundColor = self?.highlightColor ?? UIColor(white: 0.8, alpha: 1)
        self?.insertSubview(view, at: 0)
        view.frame = (self?.bounds ?? .zero).inset(by: self?.highlightInsets ?? .zero)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
        }, clearer: {
            $0.removeFromSuperview()
    })

    open override func commonInit() {
        super.commonInit()
        tapRecognizer.addTarget(self, action: #selector(onTap(tapRec:)))
        addGestureRecognizer(tapRecognizer)
    }

    @objc private func onTap(tapRec: UITapGestureRecognizer) {
        if !highlightBackground.exists {
            showHighlight(true, duration: 0.1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.showHighlight(false, duration: 0.1)
            }
        }

        if let view = view(forTap: tapRec) {
            backgroundTap(view)
        }
    }

    func backgroundTap(_ view: UIView) {
        didTap?(view)
    }

    open func view(forTap recognizer: UITapGestureRecognizer) -> UIView? {
        recognizer.view
    }

    private func showHighlight(_ show: Bool, duration: TimeInterval = .defaultAnimation) {
        if show && highlightColor != nil {
            highlightBackground.getOrMake().alpha = 0
            UIView.animate(withDuration: duration) { [weak self] in
                self?.highlightBackground.getOrMake().alpha = 1
            }
        } else {
            highlightBackground.ifExists { (view) in
                UIView.animate(withDuration: duration, animations: {
                    view.alpha = 0
                }, completion: { [weak self] (_) in
                    self?.highlightBackground.clear()
                })
            }
        }
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Disable forwarding events if we are going to handle highlight for this view.
        // Stops superviews which also have a highlightColor from highlighting
        if highlightColor == nil {
            super.touchesBegan(touches, with: event)
        }
        showHighlight(true)
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Disable forwarding events if we are going to handle highlight for this view.
        // Stops superviews which also have a highlightColor from highlighting
        if highlightColor == nil {
            super.touchesEnded(touches, with: event)
        }

        showHighlight(false)
    }

    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Disable forwarding events if we are going to handle highlight for this view.
        // Stops superviews which also have a highlightColor from highlighting
        if highlightColor == nil {
            super.touchesCancelled(touches, with: event)
        }

        showHighlight(false)
    }
}
