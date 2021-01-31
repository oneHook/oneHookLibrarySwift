import UIKit

extension CGSize {
    public static let max = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)

    public static func max(width: CGFloat) -> CGSize {
        CGSize(width: width, height: .greatestFiniteMagnitude)
    }

    public static func max(height: CGFloat) -> CGSize {
        CGSize(width: .greatestFiniteMagnitude, height: height)
    }
}

extension CGPoint {

    public func isClose(to point: CGPoint, threshold: CGFloat = 50) -> Bool {
        distance(to: point) < threshold
    }

    public func distance(to point: CGPoint) -> CGFloat {
        (pow(self.x - point.x, 2) + pow(self.y - point.y, 2)).squareRoot()
    }

    public func snap(_ factor: Int) -> CGPoint {
        CGPoint(
            x: round(x / CGFloat(factor)) * CGFloat(factor),
            y: round(y / CGFloat(factor)) * CGFloat(factor)
        )
    }

    // https://stackoverflow.com/a/18157551/1661720
    public func distance(to rect: CGRect) -> CGFloat {
        let deltaX = max(abs(x - rect.midX) - rect.width / 2.0, 0)
        let deltaY = max(abs(y - rect.midY) - rect.height / 2.0, 0)
        return sqrt(deltaX * deltaX + deltaY * deltaY)
    }
}

extension CGRect {

    public var topLeft: CGPoint {
        CGPoint(x: self.minX, y: self.minY)
    }

    public var topRight: CGPoint {
        CGPoint(x: self.maxX, y: self.minY)
    }

    public var bottomLeft: CGPoint {
        CGPoint(x: self.minX, y: self.maxY)
    }

    public var bottomRight: CGPoint {
        CGPoint(x: self.maxX, y: self.maxY)
    }

    public func snapOrigin(_ factor: Int) -> CGRect {
        CGRect(origin: origin.snap(factor), size: size)
    }
}

extension CGFloat {
    public func isClose(to other: CGFloat, threshold: CGFloat = 0.01) -> Bool {
        abs(self - other) < threshold
    }

    public func isSmallerOrClose(to other: CGFloat, threshold: CGFloat = 0.2) -> Bool {
        self - threshold <= other || self + threshold <= other
    }
}
