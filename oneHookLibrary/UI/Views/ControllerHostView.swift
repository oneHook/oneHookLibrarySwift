import UIKit

public extension Notification.Name {
    static let controllerHostWillDismiss = Notification.Name("controllerHostWillDismiss")
}

public protocol ControllerHostViewDelegate: class {
    func controllerStackDidChange()
    func controllerShouldDismissTapOutside(controller: UIViewController) -> Bool
    func controllerShouldDismissByDrag(controller: UIViewController,
                                       location: CGPoint) -> Bool
}

extension ControllerHostViewDelegate {
    func controllerShouldDismissTapOutside(controller: UIViewController) -> Bool {
        true
    }

    func controllerShouldDismissByDrag(controller: UIViewController,
                                       location: CGPoint) -> Bool {
        true
    }
}

open class ControllerHostView: BaseView {

    public struct PresentationStyle {
        var dimColor: UIColor
        var replaceTop: Bool
        var animationType: AnimationType

        public init(dimColor: UIColor = UIColor(white: 0, alpha: 0.8),
                    replaceTop: Bool = false,
                    animationType: AnimationType = .bottom) {
            self.dimColor = dimColor
            self.replaceTop = replaceTop
            self.animationType = animationType
        }
    }

    public enum AnimationType {
        case bottom
        case fade
        case none

        func setInitialState(view: UIView,
                             contentTopMargin: CGFloat,
                             bounds: CGRect,
                             controllerSize: CGSize) {
            switch self {
            case .bottom:
                view.frame = CGRect(
                    origin: CGPoint(x: 0, y: bounds.height),
                    size: controllerSize
                )
            case .fade:
                view.frame = CGRect(
                    origin: CGPoint(x: 0, y: contentTopMargin),
                    size: controllerSize
                )
                view.alpha = 0
            default:
                break
            }
        }
    }

    open var animationDuration: TimeInterval = .defaultAnimation
    open var animationReplaceDuration: TimeInterval = 0.15

    private weak var parentController: UIViewController?
    private var animations = [AnimationType]()
    private var dimCovers = [BaseView]()
    private var controllers = [UIViewController]() {
        didSet {
            /* If any controller is presented, we will allow
             user interaction in this view so that touch
             event wont pass down */
            isUserInteractionEnabled = controllers.isNotEmpty
            delegate?.controllerStackDidChange()
        }
    }

    open weak var delegate: ControllerHostViewDelegate?

    open var topViewController: UIViewController? {
        controllers.last
    }

    open var viewControllers: [UIViewController] {
        controllers
    }

    private(set) var interactionInProgress: Bool = false
    private(set) var shouldCompleteTransition: Bool = false

    open var contentTopMargin: CGFloat = 0

    required public init(parentController: UIViewController?) {
        self.parentController = parentController
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override open func commonInit() {
        super.commonInit()
        isUserInteractionEnabled = false
        backgroundColor = .clear

        addGestureRecognizer(
            UITapGestureRecognizer(target: self,
                                   action: #selector(onTap(tapRec:))).apply {
                                    $0.delegate = self
            }
        )
        addGestureRecognizer(
            UIPanGestureRecognizer(target: self,
                                   action: #selector(onPan(panRec:))).apply {
                                    $0.delegate = self
            }
        )
    }

    open func present(_ viewController: UIViewController,
                      style: PresentationStyle = .init(),
                      completion: (() -> Void)? = nil) {
        if style.replaceTop {
            executeReplace(viewController, style: style, completion: completion)
        } else {
            executePresent(viewController, style: style, completion: completion)
        }
    }

    private func executePresent(_ viewController: UIViewController,
                                style: PresentationStyle,
                                completion: (() -> Void)? = nil) {
        let animation = style.animationType
        let cover = BaseView().apply {
            $0.alpha = 0
            $0.frame = bounds
            $0.backgroundColor = style.dimColor
        }
        dimCovers.append(cover)
        addSubview(cover)
        controllers.append(viewController)
        parentController?.addChild(viewController)
        addSubview(viewController.view)
        animations.append(animation)

        let controllerSize = CGSize(width: bounds.width,
                                    height: bounds.height - contentTopMargin)
        if animation != .none {

            if controllers.count == 1 {
                parentController?.viewWillDisappear(true)
            }
            cover.frame = bounds
            animation.setInitialState(view: viewController.view,
                                      contentTopMargin: contentTopMargin,
                                      bounds: bounds,
                                      controllerSize: controllerSize)
            UIView.animate(withDuration: animationDuration,
                           animations: {
                            cover.alpha = 1
                            viewController.view.alpha = 1
                            viewController.view.frame = CGRect(
                                origin: CGPoint(x: 0, y: self.contentTopMargin),
                                size: controllerSize
                            )
            }, completion: { [weak self] (_) in
                if self?.controllers.count == 1 {
                    self?.parentController?.viewDidDisappear(true)
                }
                completion?()
            })
        } else {
            if controllers.count == 1 {
                parentController?.viewWillDisappear(false)
            }
            cover.frame = bounds
            cover.alpha = 1
            viewController.view.frame = CGRect(
                origin: CGPoint(x: 0, y: self.contentTopMargin),
                size: controllerSize
            )
            if controllers.count == 1 {
                parentController?.viewDidDisappear(false)
            }
            completion?()
        }
    }

    private func executeReplace(_ viewController: UIViewController,
                                style: PresentationStyle,
                                completion: (() -> Void)? = nil) {
        guard
            controllers.isNotEmpty else {
                return
        }

        let toReplace = controllers.removeLast()
        controllers.append(viewController)

        toReplace.removeFromParent()
        parentController?.addChild(viewController)
        addSubview(viewController.view)
        let animation = style.animationType
        let controllerSize = CGSize(width: bounds.width,
                                    height: bounds.height - contentTopMargin)
        if animation != .none {
            animation.setInitialState(view: viewController.view,
                                      contentTopMargin: contentTopMargin,
                                      bounds: bounds,
                                      controllerSize: controllerSize)
            UIView.animate(withDuration: animationReplaceDuration,
                           animations: {
                            animation.setInitialState(view: toReplace.view,
                                                      contentTopMargin: self.contentTopMargin,
                                                      bounds: self.bounds,
                                                      controllerSize: controllerSize)
            }, completion: { (_) in
                UIView.animate(withDuration: self.animationReplaceDuration,
                               animations: {
                                viewController.view.alpha = 1
                                viewController.view.frame = CGRect(
                                    origin: CGPoint(x: 0,
                                                    y: self.contentTopMargin),
                                    size: controllerSize
                                )
                }, completion: { (_) in
                    toReplace.view.removeFromSuperview()
                    completion?()
                })
            })
        } else {
            viewController.view.frame = CGRect(
                origin: CGPoint(x: 0, y: self.contentTopMargin),
                size: controllerSize
            )
            toReplace.view.removeFromSuperview()
            completion?()
        }
    }

    @discardableResult
    open func dismiss(animated flag: Bool,
                      completion: (() -> Void)? = nil,
                      duration: TimeInterval? = nil) -> Bool {
        if controllers.isEmpty {
            return false
        }

        NotificationCenter.default.post(name: .controllerHostWillDismiss, object: self)

        let toPop = controllers.removeLast()
        let cover = dimCovers.removeLast()
        let animation = animations.removeLast()
        toPop.removeFromParent()

        let controllerSize = CGSize(width: bounds.width,
                                    height: bounds.height - contentTopMargin)
        if flag {
            if
                controllers.isEmpty,
                parentController?.navigationController == nil ||
                    parentController?.navigationController?.viewControllers.last == parentController {
                parentController?.viewWillAppear(true)
            }
            UIView.animate(withDuration: duration ?? animationDuration,
                           animations: {
                            cover.alpha = 0
                            animation.setInitialState(view: toPop.view,
                                                      contentTopMargin: self.contentTopMargin,
                                                      bounds: self.bounds,
                                                      controllerSize: controllerSize)
            }, completion: { [weak self] (_) in
                cover.removeFromSuperview()
                toPop.view.removeFromSuperview()
                if let self = self {
                    if
                        self.controllers.isEmpty,
                        self.parentController?.navigationController == nil ||
                            self.parentController?.navigationController?.viewControllers.last == self.parentController {
                        self.parentController?.viewDidAppear(true)
                    }
                }
                completion?()
            })
        } else {
            if
                controllers.isEmpty,
                parentController?.navigationController == nil ||
                    parentController?.navigationController?.viewControllers.last == parentController {
                parentController?.viewWillAppear(false)
            }
            cover.alpha = 0
            cover.removeFromSuperview()
            toPop.view.removeFromSuperview()
            if
                controllers.isEmpty,
                parentController?.navigationController == nil ||
                    parentController?.navigationController?.viewControllers.last == parentController {
                parentController?.viewDidAppear(false)
            }
            completion?()
        }
        return true
    }

    @objc private func onTap(tapRec: UITapGestureRecognizer) {
        /* Will not called if tap on any controller view */
        guard
            let topViewController = topViewController,
            !topViewController.view.frame.contains(tapRec.location(in: self)),
            !interactionInProgress else {
                return
        }
        if delegate?.controllerShouldDismissTapOutside(
            controller: topViewController) ?? true {
            dismiss(animated: true)
        }
    }

    @objc private func onPan(panRec: UIPanGestureRecognizer) {
        guard
            let viewController = topViewController else {
                return
        }
        let translation = panRec.translation(in: self)
        var progress = (translation.y / viewController.view.bounds.height)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        switch panRec.state {
        case .began:
            interactionInProgress = true
            shouldCompleteTransition = false
        case .changed:
            shouldCompleteTransition = progress > 0.5
            panShouldUpdate(progress: progress, translationY: translation.y)
        case .cancelled:
            interactionInProgress = false
            panShouldCancel()
        case .ended:
            let gestureVelocity = panRec.velocity(in: self)
            interactionInProgress = false
            if shouldCompleteTransition || gestureVelocity.y > 2000 {
                panShouldFinish()
            } else {
                panShouldCancel()
            }
        default:
            break
        }
    }

    private func panShouldUpdate(progress: CGFloat, translationY: CGFloat) {
        guard
            let presentingView = topViewController?.view,
            let dimCover = dimCovers.last else {
                return
        }
        let height = bounds.height - contentTopMargin
        dimCover.alpha = 1 - progress
        presentingView.putTop(
            top: max(contentTopMargin,
                     contentTopMargin + translationY),
            height: height
        )
    }

    private func panShouldCancel() {
        guard
            let presentingView = topViewController?.view,
            let dimCover = dimCovers.last else {
                return
        }
        let height = bounds.height - contentTopMargin
        let offset = presentingView.frame.minY - contentTopMargin
        let duration = CGFloat(0.15) + CGFloat(0.075) * offset / (bounds.height - contentTopMargin)
        UIView.animate(withDuration: TimeInterval(duration),
                       animations: { [weak self] in
                        guard let self = self else {
                            return
                        }
                        self.topViewController?.viewDidAppear(true)
                        dimCover.alpha = 1
                        presentingView.putTop(top: self.contentTopMargin,
                                              height: height)
        })
    }

    private func panShouldFinish() {
        guard
            let presentingView = topViewController?.view else {
                return
        }
        let offset = bounds.height - presentingView.frame.minY
        let duration = CGFloat(0.15) + CGFloat(0.075) * offset / (bounds.height - contentTopMargin)
        dismiss(animated: true, duration: TimeInterval(duration))
    }
}

extension ControllerHostView: UIGestureRecognizerDelegate {

    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if
            parentController != nil,
            parentController?.navigationController != nil,
            parentController?.navigationController?.topViewController != parentController {
            /* if parent controller wrapped inside a navigation controller, only handle
               gesture if parent controller is the top one */
            return false
        }
        guard let topViewController = topViewController,
            let topAnimation = animations.last,
            topAnimation == .bottom else {
                return false
        }
        if gestureRecognizer.isKind(of: UITapGestureRecognizer.self) {
            return !topViewController.view.frame.contains(
                gestureRecognizer.location(in: self)
            )
        }
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
            let location = gestureRecognizer.location(in: self)
            return delegate?.controllerShouldDismissByDrag(
                controller: topViewController,
                location: location
                ) ?? true
        }
        return true
    }

    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
    }
}
