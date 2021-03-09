import UIKit

extension UIView {

    public func ed_pop(duration: TimeInterval = 0.1) {
        UIView.animate(
            withDuration: duration,
            animations: {
                self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
            completion: { _ in
                UIView.animate(withDuration: duration) {
                    self.transform = CGAffineTransform.identity
                }
            })
    }
}
