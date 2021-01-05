import UIKit

public struct LineGraphUIModel {
    fileprivate var points: [CGFloat]

    public init(numbers: [Int], minValue: Int? = nil, maxValue: Int? = nil) {
        let minValue = CGFloat(minValue ?? numbers.min() ?? 0)
        let maxValue = CGFloat(maxValue ?? numbers.max() ?? 0)
        self.points = numbers.map {
            1 - (CGFloat($0) - minValue) / (maxValue - minValue)
        }
        print(self.points)
    }
}

open class LineGraphView: BaseView {

    private var gradient = CAGradientLayer().apply {
        $0.anchorPoint = .zero
    }
    private var maskLayer = CAShapeLayer().apply {
        $0.anchorPoint = .zero
    }
    private var needsRefresh = true
    public var uiModel: LineGraphUIModel? {
        didSet {
            needsRefresh = true
            refresh()
        }
    }

    open override func commonInit() {
        super.commonInit()
        layer.addSublayer(gradient)
        gradient.addSublayer(maskLayer)
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
        refresh()
    }

    private func refresh() {
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
        maskPath.move(to: .init(x: paddingStart, y: height + paddingTop))

        let segmentCount = CGFloat(uiModel.points.count)
        let segmentWidth = width / (segmentCount - 1)

        for i in uiModel.points.indices {
            let toPoint: CGPoint = .init(
                x: CGFloat(i) * segmentWidth + paddingStart,
                y: height * uiModel.points[i] + paddingTop
            )
            maskPath.addLine(to: toPoint)
        }
        maskPath.addLine(to: .init(x: width + paddingStart, y: height + paddingTop))
        maskPath.addLine(to: .init(x: paddingStart, y: height + paddingTop))

        maskLayer.path = maskPath
        gradient.mask = maskLayer
        needsRefresh = false
    }

    public func setGradientColor(topColor: UIColor, bottomColor: UIColor) {
        gradient.colors = [topColor, bottomColor].map { $0.cgColor }
    }
}
