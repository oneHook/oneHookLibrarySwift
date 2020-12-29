import UIKit

open class ProgressBar: BaseView {

    public override var padding: CGFloat {
        didSet {
            layer.setNeedsLayout()
        }
    }

    public var mainProgressColor: UIColor = UIColor.white {
        didSet {
            mainProgressLayer.backgroundColor = mainProgressColor.cgColor
        }
    }

    public var subProgressColor: UIColor = UIColor.white {
        didSet {
            subProgressLayer.backgroundColor = subProgressColor.cgColor
        }
    }

    public var mainProgress: Float = 0 {
        didSet {
            layer.setNeedsLayout()
        }
    }

    public var subProgress: Float = 0 {
        didSet {
            layer.setNeedsLayout()
        }
    }

    public var borderWidth: CGFloat = 0 {
        didSet {
            layer.setNeedsLayout()
        }
    }

    public var progressCornerRadius: CGFloat? {
        didSet {
            layer.setNeedsLayout()
        }
    }

    let mainProgressLayer = CAShapeLayer()
    let subProgressLayer = CAShapeLayer()

    open override func commonInit() {
        super.commonInit()
        backgroundColor = UIColor.clear
        mainProgressLayer.anchorPoint = CGPoint(x: 0, y: 0.5)
        subProgressLayer.anchorPoint = CGPoint(x: 0, y: 0.5)
        layer.addSublayer(subProgressLayer)
        layer.addSublayer(mainProgressLayer)

        mainProgressColor = UIColor.red
        subProgressColor = UIColor.blue
        mainProgress = 0
        subProgress = 0

        layer.masksToBounds = true
    }

    deinit {
        mainProgressLayer.removeFromSuperlayer()
        subProgressLayer.removeFromSuperlayer()
    }

    open override func layoutSublayers(of layer: CALayer) {
        let width = bounds.width
        let height = bounds.height
        let mainProgress = min(1, max(0, self.mainProgress))
        let subProgress = min(1, max(0, self.subProgress))
        if layer == layer {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            let mainProgressHeight = height - 2 * borderWidth
            mainProgressLayer.bounds = CGRect(x: 0,
                                              y: 0,
                                              width: (width - (height - mainProgressHeight)) * CGFloat(mainProgress),
                                              height: mainProgressHeight)
            mainProgressLayer.position = CGPoint(x: (height - mainProgressHeight) / 2 + padding,
                                                 y: height / 2 + padding)
            mainProgressLayer.cornerRadius = progressCornerRadius ?? mainProgressHeight / 2

            subProgressLayer.bounds = CGRect(x: 0,
                                             y: 0,
                                             width: width * CGFloat(subProgress),
                                             height: height)
            subProgressLayer.position = CGPoint(x: padding, y: height / 2 + padding)
            subProgressLayer.cornerRadius = progressCornerRadius ?? height / 2
            CATransaction.commit()
        }
    }

    public func setMainProgress(_ mainProgress: Float, subProgress: Float, animated: Bool) {
        self.mainProgress = min(1, max(0, mainProgress))
        self.subProgress = min(1, max(0, subProgress))
        layoutSublayers(of: layer)
    }

}
