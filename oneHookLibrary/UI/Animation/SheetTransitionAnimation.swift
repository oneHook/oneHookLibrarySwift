import UIKit

public let kTagBackgroundContainer = 100
public let kTagContentContainer = 101

public class SheetTransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    let duration: TimeInterval = .defaultAnimation
    public var presenting = true
    var originFrame = CGRect.zero

    public var dismissCompletion: ((Bool) -> Void)?

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if presenting {
            animatePresentingTransition(using: transitionContext)
        } else {
            animateDismissingTransition(using: transitionContext)
        }
    }

    private func animatePresentingTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toVC = transitionContext.viewController(forKey: .to),
            let animatingView = transitionContext.view(forKey: .to)
            else {
                return
        }
        let containerView = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)
        let finalFrame = transitionContext.finalFrame(for: toVC)
        let backgroundContainer = animatingView.viewWithTag(kTagBackgroundContainer)
        let contentContainer = animatingView.viewWithTag(kTagContentContainer)

        containerView.addSubview(animatingView)
        animatingView.frame = finalFrame
        animatingView.backgroundColor = UIColor.clear
        contentContainer?.transform = CGAffineTransform(
            translationX: 0,
            y: finalFrame.height
        )
        backgroundContainer?.alpha = 0
        UIView.animate(withDuration: duration,
                       animations: {
                        backgroundContainer?.alpha = 1
                        contentContainer?.transform = CGAffineTransform.identity
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }

    private func animateDismissingTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toVC = transitionContext.viewController(forKey: .to),
            let animatingView = transitionContext.view(forKey: .from)
            else {
                return
        }
        let duration = transitionDuration(using: transitionContext)
        let finalFrame = transitionContext.finalFrame(for: toVC)
        let backgroundContainer = animatingView.viewWithTag(kTagBackgroundContainer)
        let contentContainer = animatingView.viewWithTag(kTagContentContainer)

        contentContainer?.transform = CGAffineTransform.identity
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: .curveLinear,
                       animations: {
                        backgroundContainer?.alpha = 0
                        if let currentFrame = contentContainer?.frame {
                            contentContainer?.frame = CGRect(x: currentFrame.minX,
                                                             y: currentFrame.minY + finalFrame.height,
                                                             width: currentFrame.width,
                                                             height: currentFrame.height)
                        }
        }, completion: { _ in
            self.dismissCompletion?(!transitionContext.transitionWasCancelled)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

public class SheetInteractionController: UIPercentDrivenInteractiveTransition, UIGestureRecognizerDelegate {
    public var interactionInProgress = false

    private var shouldCompleteTransition = false
    private weak var viewController: UIViewController!

    public init(viewController: UIViewController) {
        super.init()
        self.viewController = viewController
        preparePanGestureRecognizer()
        prepareTapGesture()
    }

    private func preparePanGestureRecognizer() {
        viewController.view.addGestureRecognizer(UIPanGestureRecognizer(
            target: self,
            action: #selector(handleGesture(_:))).apply({ (panRec) in
                panRec.delegate = self
            }))
    }

    private func prepareTapGesture() {
        viewController.view.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(handleTap(_:))).apply {
                    $0.delegate = self
        })
    }

    @objc func handleTap(_ gestureReconnizer: UITapGestureRecognizer) {
        viewController.dismiss(animated: true, completion: nil)
    }

    @objc func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        var progress = (translation.y / viewController.view.bounds.height)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
            viewController.dismiss(animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                self.update(progress)
            }
        case .changed:
            shouldCompleteTransition = progress > 0.3
            update(progress)
        case .cancelled:
            interactionInProgress = false
            cancel()
        case .ended:
            let gestureVelocity = gestureRecognizer.velocity(in: gestureRecognizer.view!.superview!)
            interactionInProgress = false
            if shouldCompleteTransition || gestureVelocity.y > 1000 {
                finish()
            } else {
                cancel()
            }
        default:
            break
        }
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let location = gestureRecognizer.location(in: viewController.view)
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
            return true
        } else {
            let contentView = viewController.view.viewWithTag(kTagContentContainer)
            return !(contentView?.frame.contains(location) ?? true)
        }
    }
}
