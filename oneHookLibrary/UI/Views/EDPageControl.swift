import UIKit

open class EDPageControl: BaseControl {

    public var dotSize = CGSize(width: dp(8), height: dp(8))
    public var notSelectedDotRatio: CGFloat = 0.25
    public var pageIndicatorTintColor = UIColor(white: 1, alpha: 0.5)
    public var currentPageIndicatorTintColor = UIColor.white
    public var spacing = dp(4) 
    public var numberOfPages: Int = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    public var currentPage: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }

    open override func commonInit() {
        super.commonInit()
    }

    open override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        for index in 0..<numberOfPages {
            context.saveGState()

            let offset = CGFloat(index) - currentPage
            var dotWidth = dotSize.width
            var dotHeight = dotSize.height
            if offset < -1 || offset > 1 {
                context.setFillColor(pageIndicatorTintColor.cgColor)
                dotWidth -= dotWidth * notSelectedDotRatio
                dotHeight -= dotHeight * notSelectedDotRatio
            } else {
                context.setFillColor(
                    UIColor.blend(fromColor: pageIndicatorTintColor,
                                  toColor: currentPageIndicatorTintColor,
                                  step: abs(offset)
                    ).cgColor
                )
                if offset < 0 {
                    dotWidth += dotWidth * notSelectedDotRatio * offset
                    dotHeight += dotHeight * notSelectedDotRatio * offset
                } else {
                    dotWidth -= dotWidth * notSelectedDotRatio * abs(offset)
                    dotHeight -= dotHeight * notSelectedDotRatio * abs(offset)
                }
            }

            let index = CGFloat(index)
            let xCenter = paddingStart + (dotSize.width + spacing) * index + dotSize.width / 2

            context.addEllipse(
                in: CGRect(
                    x: xCenter - dotWidth / 2,
                    y: bounds.height / 2 - dotHeight / 2,
                    width: dotWidth,
                    height: dotHeight
                )
            )
            context.drawPath(using: .fill)
            context.restoreGState()
        }
    }

    open override func sizeToFit() {
        bounds = CGRect(origin: .zero, size: sizeThatFits(CGSize.max))
    }

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        if layoutSize != CGSize.zero {
            return layoutSize
        }
        let width = paddingStart +
            dotSize.width * CGFloat(numberOfPages) +
            spacing * CGFloat(numberOfPages - 1) +
            paddingEnd
        let height = paddingTop + dotSize.height + paddingBottom
        return CGSize(
            width: max(0, width),
            height: height
        )
    }
}
