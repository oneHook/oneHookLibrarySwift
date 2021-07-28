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

    public convenience init(firstColor: UIColor, secondColor: UIColor) {
        self.init()
        self.firstColor = firstColor
        self.secondColor = secondColor
        updateView()
    }

    private var gradient: CAGradientLayer? {
        layer as? CAGradientLayer
    }

    func updateView() {
        gradient?.colors = [firstColor, secondColor].map { $0.cgColor }
    }

    open override func invalidateAppearance() {
        updateView()
    }
}

