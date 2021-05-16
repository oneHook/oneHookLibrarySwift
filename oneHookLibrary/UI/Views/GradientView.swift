import UIKit

open class GradientView: BaseView {

    @IBInspectable public var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }

    @IBInspectable public var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }

    override open class var layerClass: AnyClass {
        CAGradientLayer.self
    }

    open var gradient: CAGradientLayer? {
        layer as? CAGradientLayer
    }

    func updateView() {
        gradient?.colors = [firstColor, secondColor].map { $0.cgColor }
    }

    open override func invalidateAppearance() {
        updateView()
    }
}

