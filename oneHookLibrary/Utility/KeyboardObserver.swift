import UIKit

public protocol KeyboardObservable: AnyObject {
    func keyboardWillAnimate()
    func keyboardDidAnimate(_ finished: Bool)
}

public extension KeyboardObservable {
    func keyboardWillAnimate() {}
    func keyboardDidAnimate(_ finished: Bool) {}
}

// https://stackoverflow.com/a/27140764/1661720
extension UIResponder {
    private weak static var _currentFirstResponder: UIResponder?

    public static var current: UIResponder? {
        _currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(findFirstResponder(sender:)), to: nil, from: nil, for: nil)
        return _currentFirstResponder
    }

    @objc internal func findFirstResponder(sender: AnyObject) {
        UIResponder._currentFirstResponder = self
    }
}

public class KeyboardObserver {
    public static let defaultFirstResponderKeyboardInset: CGFloat = dp(20)
    public static let shared = KeyboardObserver()

    public var keyboardFrame: CGRect?
    public var keyboardInset: CGFloat {
        guard
            let keyboardFrame = keyboardFrame,
            keyboardFrame.minY < UIScreen.main.bounds.height else {
                return 0
        }

        return UIScreen.main.bounds.height - keyboardFrame.minY
    }

    public var keyboardIsVisible: Bool {
        guard let responder = UIResponder.current else {
            return false
        }

        return (keyboardInset - (responder.inputAccessoryView?.intrinsicContentSize.height ?? 0)) > 2
    }

    public var inputAccessoryIsVisible: Bool {
        !keyboardIsVisible && keyboardInset > 0
    }

    public var keyboardOrInputAccessoryIsVisible: Bool {
        keyboardInset > 0
    }

    public var enabled: Bool = true {
        didSet {
            observeKeyboardWillChangeFrameNotifications(enabled)
        }
    }

    private var observers: WeakArray<AnyObject> = WeakArray([])

    public func addObserver<T: KeyboardObservable>(_ observer: T) {
        observers.append(observer)
    }

    public typealias KeyboardObservableEquatable = KeyboardObservable & Equatable

    public func removeObserver<T: KeyboardObservableEquatable>(_ observer: T) {
        observers.remove(observer)
    }

    public init() {
        // `defer` required to trigger didSet on init
        // swiftlint:disable:next inert_defer
        defer {
            enabled = true
        }
    }

    private func observeKeyboardWillChangeFrameNotifications(_ observe: Bool) {
        if observe {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(keyboardWillChangeFrame),
                name: UIResponder.keyboardWillChangeFrameNotification,
                object: nil
            )
        } else {
            NotificationCenter.default.removeObserver(
                self,
                name: UIResponder.keyboardWillChangeFrameNotification,
                object: nil
            )
        }
    }

    @objc private func keyboardWillChangeFrame(notification: Notification) {
        if
            let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let curveValue = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue
                ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let curve = UIView.AnimationOptions(rawValue: curveValue)

            observers.prune()
            self.keyboardFrame = keyboardFrame

            if observers.isEmpty {
                return
            }

            UIView.animate(
                withDuration: duration,
                delay: 0,
                options: curve,
                animations: { [weak self] in
                    self?.observers.forEach { ($0 as? KeyboardObservable)?.keyboardWillAnimate() }
                },
                completion: { [weak self] (finished) in
                    self?.observers.forEach { ($0 as? KeyboardObservable)?.keyboardDidAnimate(finished) }
                }
            )
        }
    }

    public func scrollFirstResponderToVisible(_ scrollView: UIScrollView, bottomInset: CGFloat? = nil) {
        guard
            let responder = scrollView.firstResponder,
            keyboardInset > 0 else {
            return
        }
        scrollViewToVisible(scrollView, to: responder, bottomInset: bottomInset)
    }

    public func scrollViewToVisible(
        _ scrollView: UIScrollView,
        to view: UIView,
        viewSize: CGSize? = nil,
        bottomInset: CGFloat? = nil,
        firstResponderKeyboardInset: CGFloat = defaultFirstResponderKeyboardInset
    ) {
        var visibleScrollViewRect = scrollView.bounds
        visibleScrollViewRect.size.height -= bottomInset ?? keyboardInset
        var scrollToRect = view.convert(
            CGRect(origin: .zero, size: viewSize ?? view.bounds.size),
            to: scrollView
        )
        scrollToRect.size.height += firstResponderKeyboardInset

        let maxContentOffsetY = scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom

        if !visibleScrollViewRect.contains(scrollToRect) {
            scrollView.setContentOffset(
                CGPoint(
                    x: 0,
                    y: max(0, min(maxContentOffsetY, scrollToRect.maxY - visibleScrollViewRect.size.height))
                ),
                animated: true
            )
        }
    }
}
