import UIKit

public extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        layer.mask = CAShapeLayer().apply {
            $0.path = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            ).cgPath
        }
    }
}

extension UIButton {
    
    public func applyGradient(colours: [UIColor]) {
        self.applyGradient(colours: colours, locations: nil)
    }

    public func applyGradient(colours: [UIColor], locations: [NSNumber]?) {
        if let gradient = layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer {
            gradient.frame = self.bounds
            gradient.colors = colours.map { $0.cgColor }
            gradient.locations = locations
        } else {
            let gradient: CAGradientLayer = CAGradientLayer()
            gradient.frame = self.bounds
            gradient.colors = colours.map { $0.cgColor }
            gradient.locations = locations
            self.layer.insertSublayer(gradient, at: 0)
        }
    }
}

public extension UIView {

    func applyDefaultTextShadow() {
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowColor = UIColor(white: 0, alpha: 0.55).cgColor
        self.layer.shadowOpacity = 0.75
        self.layer.shadowRadius = dp(3)
    }

    func applyDefaultShadow() {
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowColor = UIColor(white: 0, alpha: 0.55).cgColor
        self.layer.shadowOpacity = 0.75
        self.layer.shadowRadius = dp(3)
    }
}

public extension UIView {
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }

        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }

        return nil
    }

    func nearestActiveButton(_ buttons: [UIButton], to point: CGPoint, maxDistance: CGFloat = Dimens.marginMedium) -> UIView? {
        nearest(buttons.filter { !$0.isHidden && $0.isEnabled }, to: point, maxDistance: maxDistance)
    }

    func nearest(_ views: [UIView], to point: CGPoint, maxDistance: CGFloat = Dimens.marginMedium) -> UIView? {
        let closest = views
            .map({ (button) -> (UIView, CGRect) in
                (button, button.convert(button.bounds, to: self))
            })
            .map({ (pair) -> (UIView, CGFloat) in
                (pair.0, point.distance(to: pair.1))
            })
            .min { $0.1 < $1.1 }

        if
            let closest = closest,
            closest.1 < maxDistance {
            return closest.0
        } else {
            return nil
        }
    }
}

public extension UIView {
    func shake() {
        self.transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}
