import UIKit

/* TODO add support for invalidateAppearance  */

public struct LineGraphUIModel {
    fileprivate var points: [CGFloat]
    fileprivate var smooth: Bool = true

    public init(numbers: [Int],
                minValue: Int? = nil,
                maxValue: Int? = nil,
                smooth: Bool = true) {
        let minValue = CGFloat(minValue ?? numbers.min() ?? 0)
        let maxValue = CGFloat(maxValue ?? numbers.max() ?? 0)
        self.points = numbers.map {
            1 - (CGFloat($0) - minValue) / (maxValue - minValue)
        }
        self.smooth = smooth
    }
}

open class LineGraphView: BaseView {

    private var gradient = CAGradientLayer().apply {
        $0.anchorPoint = .zero
    }
    private var maskLayer = CAShapeLayer().apply {
        $0.anchorPoint = .zero
    }
    private var strokeLayer = CAShapeLayer().apply {
        $0.strokeColor = UIColor.white.cgColor
        $0.lineWidth = dp(2)
        $0.anchorPoint = .zero
    }

    private var needsRefresh = true
    private var uiModel: LineGraphUIModel?
    public var isOutlineVisible: Bool = true{
        didSet {
            strokeLayer.isHidden = !isOutlineVisible
        }
    }


    open override func commonInit() {
        super.commonInit()
        layer.addSublayer(strokeLayer)
        layer.addSublayer(gradient)
        gradient.addSublayer(maskLayer)
        gradient.mask = maskLayer
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        if layoutSize == .zero {
            return CGSize(width: size.width, height: size.width / 2)
        }
        return layoutSize
    }

    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        let targetBound = layer.bounds.inset(
            by: UIEdgeInsets(top: paddingTop,
                             left: paddingStart,
                             bottom: paddingBottom,
                             right: paddingEnd)
        )
        if gradient.bounds != targetBound {
            needsRefresh = true
            gradient.bounds = targetBound
            gradient.position = .init(x: paddingStart, y: paddingTop)
            maskLayer.bounds = targetBound
            maskLayer.position = .init(x: paddingStart, y: paddingTop)
        }
        refresh(animated: false)
    }

    private func refresh(animated: Bool) {
        guard
            needsRefresh,
            let uiModel = uiModel,
            uiModel.points.isNotEmpty,
            gradient.bounds != .zero else {
            return
        }
        let width = gradient.bounds.width
        let height = gradient.bounds.height

        let maskPath = CGMutablePath()
        let strokePath = CGMutablePath()
        maskPath.move(to: .init(x: paddingStart, y: height + paddingTop))

        let segmentCount = CGFloat(uiModel.points.count)
        let segmentWidth = width / (segmentCount - 1)

        var points = [CGPoint]()
        for i in uiModel.points.indices {
            let toPoint: CGPoint = .init(
                x: CGFloat(i) * segmentWidth + paddingStart,
                y: height * uiModel.points[i] + paddingTop
            )
            points.append(toPoint)
        }

        if uiModel.smooth {
            let path = quadCurvedPathWithPoints(points).cgPath
            strokePath.addPath(path)
            maskPath.addPath(path)
        } else {
            points.forEach {
                if strokePath.isEmpty {
                    strokePath.move(to: $0)
                } else {
                    strokePath.addLine(to: $0)
                }
                maskPath.addLine(to: $0)
            }
        }

        maskPath.addLine(to: .init(x: width + paddingStart, y: height + paddingTop))
        maskPath.addLine(to: .init(x: paddingStart, y: height + paddingTop))

        if !animated || maskLayer.path == nil {
            /* No previous state or animation is disabled */
            maskLayer.path = maskPath
            strokeLayer.path = strokePath
        } else {
            CATransaction.begin()
            let maskAnimation = CABasicAnimation(keyPath: "path")
            maskAnimation.fromValue = maskLayer.path
            maskAnimation.toValue = maskPath
            maskAnimation.duration = 0.4
            maskAnimation.fillMode = CAMediaTimingFillMode.forwards
            maskAnimation.isRemovedOnCompletion = false

            let strokeAnimation = CABasicAnimation(keyPath: "path")
            strokeAnimation.fromValue = strokeLayer.path
            strokeAnimation.toValue = strokePath
            strokeAnimation.duration = 0.4
            strokeAnimation.fillMode = CAMediaTimingFillMode.forwards
            strokeAnimation.isRemovedOnCompletion = false

            CATransaction.setCompletionBlock {
                self.maskLayer.path = maskPath
                self.strokeLayer.path = strokePath
            }
            maskLayer.add(maskAnimation, forKey: "path")
            strokeLayer.add(strokeAnimation, forKey: "path")
            CATransaction.commit()
        }
    }

    public func setGradientColor(topColor: UIColor, bottomColor: UIColor) {
        gradient.colors = [topColor, bottomColor].map { $0.cgColor }
    }

    public func bind(_ uiModel: LineGraphUIModel, animated: Bool) {
        needsRefresh = true
        self.uiModel = uiModel
        refresh(animated: animated)
    }
}

private func quadCurvedPathWithPoints(_ points: [CGPoint]) -> UIBezierPath {
    let path = UIBezierPath()
    var value = points[0]
    path.move(to: value)
    if points.count == 2 {
        value = points[1]
        path.addLine(to: value)
        return path
    }
    for i in 1..<points.count {
        let next = points[i]
        let mid = midPoint(p1: value, p2: next)
        path.addQuadCurve(to: mid, controlPoint: controlPoint(p1: mid, p2: value))
        path.addQuadCurve(to: next, controlPoint: controlPoint(p1: mid, p2: next))
        value = next
    }
    return path
}

private func midPoint(p1: CGPoint, p2: CGPoint) -> CGPoint {
    CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
}

private func controlPoint(p1: CGPoint, p2: CGPoint) -> CGPoint {
    var controlPoint = midPoint(p1: p1, p2: p2)
    let diffY = abs(p2.y - controlPoint.y)

    if p1.y < p2.y {
        controlPoint.y += diffY
    } else if p1.y > p2.y {
        controlPoint.y -= diffY
    }
    return controlPoint
}


