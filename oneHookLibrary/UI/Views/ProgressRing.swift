import UIKit

/* TODO add support for invalidateAppearance  */

open class ProgressRing: BaseView {

    private struct LayerInfo {
        var progress: CGFloat
        var color: UIColor
    }

    private var progressLayers = [String: CAShapeLayer]()
    private var layerInfos = [String: LayerInfo]()
    public var thickness: CGFloat = dp(8)

    open override func commonInit() {
        super.commonInit()
        self.layoutSize = CGSize(width: dp(32), height: dp(32))

    }

    deinit {
        layer.sublayers?.forEach {
            $0.removeFromSuperlayer()
        }
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        layoutSize
    }

    public func addProgress(key: String,
                            progress: CGFloat = 0,
                            color: UIColor) {
        guard layerInfos[key] == nil else {
            fatalError("Progress layer with \(key) already exist")
        }

        let progressLayer = CAShapeLayer()
        progressLayer.anchorPoint = CGPoint(x: 0, y: 0)
        let layerInfo = LayerInfo(
            progress: progress,
            color: color
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
                               animated: Bool = true) {
        guard
            let progressLayer = progressLayers[key],
            let layerInfo = layerInfos[key] else {
            fatalError("Progress layer with \(key) does not exist")
        }

        let newLayerInfo = LayerInfo(
            progress: progress,
            color: color ?? layerInfo.color
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
        let length = bounds.width - paddingStart - paddingEnd - thickness
        let frame = CGRect(x: paddingStart + thickness / 2,
                           y: paddingTop + thickness / 2,
                           width: length,
                           height: length)
        if layer.bounds != frame {
            layer.bounds = frame
            layer.position = frame.origin
            layer.path = UIBezierPath(ovalIn: frame).cgPath
        }
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = info.color.cgColor
        layer.lineWidth = thickness
        layer.strokeStart = 0
        layer.strokeEnd = info.progress
        layer.lineCap = .round
    }

}
