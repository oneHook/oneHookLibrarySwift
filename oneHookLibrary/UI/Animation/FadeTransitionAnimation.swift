import UIKit

public class FadeTransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {

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
        containerView.addSubview(animatingView)
        animatingView.frame = finalFrame
        animatingView.alpha = 0
        UIView.animate(withDuration: duration,
                       animations: {
                        animatingView.alpha = 1
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }

    private func animateDismissingTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let animatingView = transitionContext.view(forKey: .from)
            else {
                return
        }
        let duration = transitionDuration(using: transitionContext)
        animatingView.alpha = 1
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: .curveLinear,
                       animations: {
                        animatingView.alpha = 0
        }, completion: { _ in
            self.dismissCompletion?(!transitionContext.transitionWasCancelled)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
