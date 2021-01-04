import UIKit

public protocol ColorPickerViewDelegate: class {
    func colrPickerViewDidSelect(_ view: ColorPickerView, color: UIColor, point: CGPoint, state: UIGestureRecognizer.State)
}

open class ColorPickerView : BaseView {

    public weak var delegate: ColorPickerViewDelegate?
    let saturationExponentTop: Float = 2.0
    let saturationExponentBottom: Float = 1.3
    public var elementSize: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    open override func commonInit() {
        super.commonInit()
        clipsToBounds = true
        let touchGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.touchedColor(gestureRecognizer:)))
        touchGesture.minimumPressDuration = 0
        touchGesture.allowableMovement = CGFloat.greatestFiniteMagnitude
        addGestureRecognizer(touchGesture)
    }

    open override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        for y : CGFloat in stride(from: 0.0 , to: rect.height, by: elementSize) {
            var saturation = y < rect.height / 2.0 ? CGFloat(2 * y) / rect.height : 2.0 * CGFloat(rect.height - y) / rect.height
            saturation = CGFloat(powf(Float(saturation), y < rect.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
            let brightness = y < rect.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(rect.height - y) / rect.height
            for x : CGFloat in stride(from: 0.0 ,to: rect.width, by: elementSize) {
                let hue = x / rect.width
                let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
                context!.setFillColor(color.cgColor)
                context!.fill(CGRect(x: x, y: y, width:elementSize,height:elementSize))
            }
        }
    }

    func getColorAtPoint(point: CGPoint) -> UIColor {
        let width = bounds.width
        let height = bounds.height
        let roundedPoint = CGPoint(
            x: elementSize * CGFloat(Int(point.x / elementSize)),
            y: elementSize * CGFloat(Int(point.y / elementSize))
        )
        var saturation = roundedPoint.y < height / 2.0 ? CGFloat(2 * roundedPoint.y) / height : 2.0 * CGFloat(height - roundedPoint.y) / height
        saturation = CGFloat(powf(Float(saturation), roundedPoint.y < height / 2.0 ? saturationExponentTop : saturationExponentBottom))
        let brightness = roundedPoint.y < height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(height - roundedPoint.y) / height
        let hue = roundedPoint.x / width
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }

    func getPointForColor(color: UIColor) -> CGPoint {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil);

        var yPos: CGFloat = 0
        let halfHeight = (self.bounds.height / 2)
        if (brightness >= 0.99) {
            let percentageY = powf(Float(saturation), 1.0 / saturationExponentTop)
            yPos = CGFloat(percentageY) * halfHeight
        } else {
            //use brightness to get Y
            yPos = halfHeight + halfHeight * (1.0 - brightness)
        }
        let xPos = hue * self.bounds.width
        return CGPoint(x: xPos, y: yPos)
    }

    @objc func touchedColor(gestureRecognizer: UILongPressGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began, .changed:
            let point = gestureRecognizer.location(in: self)
            let color = getColorAtPoint(point: point)
            delegate?.colrPickerViewDidSelect(self, color: color, point: point, state: gestureRecognizer.state)
        default:
            break
        }
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        if layoutSize == .zero {
            return CGSize(width: size.width, height: size.width / 2)
        }
        return layoutSize
    }
}
