import UIKit

public struct BarGraphItem {
    public var title: String?
    public var attributedTitle: NSAttributedString?
    public var value: Int

    public init(title: String, value: Int) {
        self.title = title
        self.value = value
    }

    public init(attributedTitle: NSAttributedString, value: Int) {
        self.attributedTitle = attributedTitle
        self.value = value
    }
}

public typealias ValueAdjustBlock = (Int, [Int]) -> Int
public typealias BarColorAdjustBlock = (BarGraphItem, [BarGraphItem]) -> UIColor
public typealias ScaleValueAdjustBlock = (Int) -> String

open class BarGraphView: BaseView {

    typealias ExtremeValues = (max: Int, min: Int)

    public var scalePadding: CGFloat = 4  {
        didSet {
            self.setNeedsLayout()
        }
    }

    public var titleHeight: CGFloat = 20  {
        didSet {
            self.setNeedsLayout()
        }
    }

    public var horizontalSpacing: CGFloat = 20  {
        didSet {
            self.setNeedsLayout()
        }
    }

    public var topPadding: CGFloat = 20  {
        didSet {
            self.setNeedsLayout()
        }
    }

    public var scaleCount: Int = 3  {
        didSet {
            self.setBars(bars: self.bars)
        }
    }
    public var showHorizontalLine: Bool = true {
        didSet {
            self.setNeedsLayout()
        }
    }

    public var barColor = UIColor.red
    public var horizontalLineColor = UIColor.darkGray

    public var scaleLabelFont = UIFont.systemFont(ofSize: 10)
    public var titleLabelFont = UIFont.systemFont(ofSize: 10)

    public var minValueAdjustBlock: ValueAdjustBlock?
    public var maxValueAdjustBlock: ValueAdjustBlock?
    public var barColorAdjustBlock: BarColorAdjustBlock?
    public var scaleValueAdjustBlock: ScaleValueAdjustBlock?

    /* Data Models */
    private var bars = [BarGraphItem]()
    private var extremeValues = ExtremeValues(max: 0, min: 0)

    /* UI Components */

    private var barLayers = [CAShapeLayer]()
    private var lineLayers = [CAShapeLayer]()
    private var titleLabels = [UILabel]()
    private var scaleLabels = [UILabel]()

    private var recycledLayers = [CAShapeLayer]()
    private var recycledBarLayers = [CAShapeLayer]()
    private var recycledLabels = [UILabel]()

    public func updateBars(bars: [BarGraphItem]) {
        guard bars.count == self.bars.count else {
            fatalError("For update, before and after count must match")
        }
        self.bars = bars

        let values = self.bars.map({$0.value})
        self.extremeValues = self.bars.reduce((max: self.bars[0].value,
                                               min: self.bars[0].value),
                                              { (result, bar) -> ExtremeValues in
                                                (max: max(result.max, bar.value), min: min(result.min, bar.value))
        })

        self.extremeValues.max = self.maxValueAdjustBlock?(self.extremeValues.max, values) ?? self.extremeValues.max
        self.extremeValues.min = self.minValueAdjustBlock?(self.extremeValues.min, values) ?? self.extremeValues.min

        for index in self.bars.indices {
            let bar = self.bars[index]
            let shapeLayer = self.barLayers[index]
            shapeLayer.backgroundColor = self.barColorAdjustBlock?(bar, self.bars).cgColor ?? self.barColor.cgColor

            let titleLabel = self.titleLabels[index]
            if bar.attributedTitle != nil {
                titleLabel.attributedText = bar.attributedTitle!
            } else {
                titleLabel.text = bar.title
            }
        }

        let scaleInterval = (self.extremeValues.max - self.extremeValues.min) / (self.scaleCount - 1)
        for index in 0..<self.scaleCount {
            let scaleLabel = self.scaleLabels[index]
            var scaleValue = index * scaleInterval
            if index == self.scaleCount - 1 {
                scaleValue = self.extremeValues.max
            }
            scaleLabel.text = self.scaleValueAdjustBlock?(scaleValue) ?? String(scaleValue)
        }

        self.setNeedsLayout()
    }

    public func setBars(bars: [BarGraphItem]) {
        self.bars.removeAll()
        self.bars.append(contentsOf: bars)

        /* Remove and recycle all layers */
        for layer in self.barLayers {
            layer.removeFromSuperlayer()
            self.recycledBarLayers.append(layer)
        }
        self.barLayers.removeAll()

        for layer in self.lineLayers {
            layer.removeFromSuperlayer()
            self.recycledLayers.append(layer)
        }
        self.lineLayers.removeAll()

        /* And Recycle all scale/title labels */
        for label in self.scaleLabels {
            label.removeFromSuperview()
            self.recycledLabels.append(label)
        }
        self.scaleLabels.removeAll()

        for label in self.titleLabels {
            label.removeFromSuperview()
            self.recycledLabels.append(label)
        }
        self.titleLabels.removeAll()

        guard !bars.isEmpty else {
            return
        }

        /* Rebuild */

        let values = self.bars.map({$0.value})
        self.extremeValues = self.bars.reduce((max: self.bars[0].value,
                                              min: self.bars[0].value),
                                             { (result, bar) -> ExtremeValues in
            (max: max(result.max, bar.value), min: min(result.min, bar.value))
        })

        self.extremeValues.max = self.maxValueAdjustBlock?(self.extremeValues.max, values) ?? self.extremeValues.max
        self.extremeValues.min = self.minValueAdjustBlock?(self.extremeValues.min, values) ?? self.extremeValues.min

        /* Setup scale labels */
        let scaleInterval = (self.extremeValues.max - self.extremeValues.min) / (self.scaleCount - 1)
        for index in 0..<self.scaleCount {
            let scaleLabel = self.obtainScaleLabel()
            self.scaleLabels.append(scaleLabel)
            self.addSubview(scaleLabel)

            var scaleValue = index * scaleInterval
            if index == self.scaleCount - 1 {
                scaleValue = self.extremeValues.max
            }
            scaleLabel.text = self.scaleValueAdjustBlock?(scaleValue) ?? String(scaleValue)
        }

        /* Setup horizontal lines if needed */
        for _ in 0..<self.scaleCount {
            let lineShape = self.obtainShapeLayer()
            lineShape.backgroundColor = self.horizontalLineColor.cgColor
            self.lineLayers.append(lineShape)
            self.layer.addSublayer(lineShape)
        }

        /* Add all bar layers and title labels */
        for bar in self.bars {
            let shapeLayer = self.obtainBarShapeLayer()
            shapeLayer.backgroundColor = self.barColorAdjustBlock?(bar, self.bars).cgColor ?? self.barColor.cgColor
            self.barLayers.append(shapeLayer)
            self.layer.addSublayer(shapeLayer)

            let titleLabel = self.obtainTitleLabel()
            self.titleLabels.append(titleLabel)
            if bar.attributedTitle != nil {
                titleLabel.attributedText = bar.attributedTitle!
            } else {
                titleLabel.text = bar.title
            }
            self.addSubview(titleLabel)
        }
    }

    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)

        guard !bars.isEmpty else {
            return
        }
        var maxScaleWidth: CGFloat = 0
        for scaleLabel in self.scaleLabels {
            scaleLabel.sizeToFit()
            maxScaleWidth = max(scaleLabel.bounds.width, maxScaleWidth)
        }

        let width = layer.bounds.width
        let height = layer.bounds.height
        let usebleWidth = width - maxScaleWidth - self.scalePadding * 2
        let usebleHeight = height - self.titleHeight - self.topPadding
        let barCount = CGFloat(self.bars.count)
        let barWidth = (usebleWidth - (self.horizontalSpacing * (barCount + 1))) / barCount
        let titleWidth = barWidth + self.horizontalSpacing

        let minValue = self.extremeValues.min
        let maxValue = self.extremeValues.max

        var currX = self.horizontalSpacing + maxScaleWidth + 2 * scalePadding

        for index in self.bars.indices {
            let bar = self.bars[index]
            let layer = self.barLayers[index]
            let titleLabel = self.titleLabels[index]
            let percent = CGFloat(bar.value - minValue) / CGFloat(maxValue - minValue)
            let barHeight = usebleHeight * percent
            layer.frame = CGRect(x: currX,
                                 y: self.topPadding + usebleHeight - barHeight,
                                 width: barWidth,
                                 height: barHeight)

            titleLabel.frame = CGRect(x: currX - self.horizontalSpacing / 2,
                                      y: usebleHeight + self.topPadding,
                                      width: titleWidth,
                                      height: self.titleHeight)

            currX += self.horizontalSpacing + barWidth
        }

        let scaleLabelHeight = usebleHeight / CGFloat(self.scaleCount - 1)
        var currCenterY = usebleHeight + self.topPadding
        for index in self.scaleLabels.indices {
            let scaleLabel = self.scaleLabels[index]
            scaleLabel.bounds = CGRect(x: 0, y: 0, width: maxScaleWidth, height: scaleLabelHeight)
            scaleLabel.center = CGPoint(x: self.scalePadding + maxScaleWidth / 2, y: currCenterY)

            if self.showHorizontalLine {
                self.lineLayers[index].opacity = 1
                self.lineLayers[index].frame = CGRect(x: maxScaleWidth + 2 * self.scalePadding,
                                                      y: currCenterY,
                                                      width: width - (maxScaleWidth + 2 * self.scalePadding),
                                                      height: 1)
            } else {
                self.lineLayers[index].opacity = 0
            }
            currCenterY -= scaleLabelHeight
        }

        print("Layout sublayers called ", self.bars.count)
    }

    private func obtainShapeLayer() -> CAShapeLayer {
        if !self.recycledLayers.isEmpty {
            return self.recycledLayers.removeFirst()
        }
        let shapeLayer = CAShapeLayer()
        return shapeLayer
    }


    private func obtainBarShapeLayer() -> CAShapeLayer {
        if !self.recycledBarLayers.isEmpty {
            return self.recycledBarLayers.removeFirst()
        }
        let shapeLayer = CAShapeLayer()
        return shapeLayer
    }

    private func obtainScaleLabel() -> UILabel {
        let label: UILabel
        if !self.recycledLabels.isEmpty {
            label = self.recycledLabels.removeLast()
        } else {
            label = UILabel()
        }
        label.font = self.scaleLabelFont
        label.textAlignment = .right
        return label
    }

    private func obtainTitleLabel() -> UILabel {
        let label: UILabel
        if !self.recycledLabels.isEmpty {
            label = self.recycledLabels.removeLast()
        } else {
            label = UILabel()
        }
        label.font = self.titleLabelFont
        label.textAlignment = .center
        return label
    }
}
