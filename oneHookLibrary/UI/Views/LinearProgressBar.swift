import UIKit

/* TODO add support for invalidateAppearance  */

open class LinearProgressBar: BaseView {

    private struct LayerInfo {
        var progress: CGFloat
        var color: UIColor
        var cornerRadius: CGFloat?
        var borderWidth: CGFloat?
        var borderColor: UIColor?
    }

    private var progressLayers = [String: CAShapeLayer]()
    private var layerInfos = [String: LayerInfo]()
    public var thickness: CGFloat = dp(20)

    open override func commonInit() {
        super.commonInit()

    }

    deinit {
        layer.sublayers?.forEach {
            $0.removeFromSuperlayer()
        }
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        if layoutSize == CGSize.zero {
            return CGSize(
                width: size.width,
                height: paddingTop + paddingBottom + thickness
            )
        }
        return layoutSize
    }

    public func addProgress(key: String,
                            progress: CGFloat = 0,
                            color: UIColor,
                            cornerRadius: CGFloat? = nil,
                            borderWidth: CGFloat? = nil,
                            borderColor: UIColor? = nil) {
        guard layerInfos[key] == nil else {
            fatalError("Progress layer with \(key) already exist")
        }

        let progressLayer = CAShapeLayer()
        progressLayer.anchorPoint = CGPoint(x: 0, y: 0)
        let layerInfo = LayerInfo(
            progress: progress,
            color: color,
            cornerRadius: cornerRadius,
            borderWidth: borderWidth,
            borderColor: borderColor
        )
        progressLayers[key] = progressLayer
        layerInfos[key] = layerInfo
        layer.addSublayer(progressLayer)

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        invalidateLayer(layer: progressLayer, info: layerInfo)
        CATransaction.commit()
    }

    public func updateProgress(key: String,
                               progress: CGFloat,
                               color: UIColor? = nil,
                               cornerRadius: CGFloat? = nil,
                               borderWidth: CGFloat? = nil,
                               borderColor: UIColor? = nil,
                               animated: Bool = true) {
        guard
            let progressLayer = progressLayers[key],
            let layerInfo = layerInfos[key] else {
            fatalError("Progress layer with \(key) does not exist")
        }

        let newLayerInfo = LayerInfo(
            progress: progress,
            color: color ?? layerInfo.color,
            cornerRadius: cornerRadius ?? layerInfo.cornerRadius,
            borderWidth: borderWidth ?? layerInfo.borderWidth,
            borderColor: borderColor ?? layerInfo.borderColor
        )
        layerInfos[key] = newLayerInfo

        if !animated {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
        }
        invalidateLayer(layer: progressLayer, info: newLayerInfo)
        if !animated {
            CATransaction.commit()
        }
    }

    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        for element in layerInfos {
            if
                let layer = progressLayers[element.key],
                let info = layerInfos[element.key] {
                invalidateLayer(layer: layer, info: info)
            }
        }
    }

    private func invalidateLayer(layer: CAShapeLayer, info: LayerInfo) {
        let width = bounds.width - paddingStart - paddingEnd

        layer.backgroundColor = info.color.cgColor
        layer.cornerRadius = info.cornerRadius ?? 0
        layer.borderWidth = info.borderWidth ?? 0
        layer.borderColor = info.borderColor?.cgColor ?? UIColor.clear.cgColor
        layer.bounds = CGRect(
            origin: .zero,
            size: CGSize(
                width: width * info.progress,
                height: thickness
            )
        )
        layer.position = CGPoint(x: paddingStart, y: paddingTop)
    }
}
