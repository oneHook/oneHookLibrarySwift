#if canImport(UIKit)
import UIKit

extension UIImage {

    /// Directly load a image from assets and make it tintable
    public static func tintableImage(named name: String) -> UIImage? {
        UIImage(named: name)?.tintable
    }

    /// Create a new Untintable UIImage but share the same cgImage with the original one
    public var original: UIImage {
        withRenderingMode(.alwaysOriginal)
    }

    /// Create a new tintable UIImage but share the same cgImage with the original one
    public var tintable: UIImage {
        withRenderingMode(.alwaysTemplate)
    }

    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let image = UIGraphicsImageRenderer(size: size).image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }

        guard let cgImage = image.cgImage else {
            return nil
        }

        self.init(cgImage: cgImage, scale: 1, orientation: .up)
    }

    public static func solid(_ color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let bounds = CGRect(origin: .zero, size: size)
        let renderer = UIGraphicsImageRenderer(size: bounds.size, format: format)
        return renderer.image { context in
            color.setFill()
            UIRectFill(bounds)
        }
    }

    public static func circle(_ color: UIColor, diameter: CGFloat) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let size = CGSize(width: diameter, height: diameter)
        let bounds = CGRect(origin: .zero, size: size)
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { context in
            color.setFill()
            let path = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: UIRectCorner.allCorners,
                                    cornerRadii: CGSize(width: diameter / 2, height: diameter / 2)
            )
            path.addClip()
            UIRectFill(bounds)
        }
    }

    /// if source image has smaller dimension, will produce the original dimension
    public static func downSampled(_ url: URL, to pointSize: CGSize, scale: CGFloat) -> UIImage? {
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        return downSampled(url, maxPixelDimension: maxDimensionInPixels, scale: scale)
    }

    /// if source image has smaller dimension, will produce the original dimension
    public static func downSampled(_ url: URL, maxPixelDimension: CGFloat, scale: CGFloat = 1.0) -> UIImage? {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, imageSourceOptions) else {
            return nil
        }
        let options =
            [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceShouldCacheImmediately: true,
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceThumbnailMaxPixelSize: maxPixelDimension
            ] as CFDictionary


        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options) else {
            return nil
        }
        return UIImage(cgImage: cgImage, scale: scale, orientation: .up)
    }

    /// if source image has smaller dimension, original dimension will be used
    @discardableResult
    public static func downSample(_ url: URL, to pointSize: CGSize, scale: CGFloat, destinationUrl: URL) -> Bool {
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        return downSample(url, maxPixelDimension: maxDimensionInPixels, destinationUrl: destinationUrl)
    }

    /// if source image has smaller dimension, original dimension will be used
    @discardableResult
    public static func downSample(_ url: URL, maxPixelDimension: CGFloat, destinationUrl: URL, quality: CGFloat = 0.8) -> Bool {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, imageSourceOptions) else {
            return false
        }
        let options =
            [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceShouldCacheImmediately: true,
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceThumbnailMaxPixelSize: maxPixelDimension,
            ] as CFDictionary

        guard
            let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options),
            let imageDestination = CGImageDestinationCreateWithURL(
                destinationUrl as CFURL,
                "public.jpeg" as CFString,
                1,
                nil
            ) else {
            return false
        }
        CGImageDestinationAddImage(imageDestination, cgImage, [
            kCGImageDestinationLossyCompressionQuality: quality
        ] as CFDictionary)
        CGImageDestinationFinalize(imageDestination)
        return true
    }

    @discardableResult
    public func save(to url: URL, quality: CGFloat = 0.8) -> Bool {
        guard
            let cgImage = cgImage,
            let imageDestination = CGImageDestinationCreateWithURL(
                url as CFURL,
                "public.jpeg" as CFString,
                1,
                nil
            ) else {
            return false
        }
        CGImageDestinationAddImage(imageDestination, cgImage, [
            kCGImageDestinationLossyCompressionQuality: quality
        ] as CFDictionary)
        CGImageDestinationFinalize(imageDestination)
        return true
    }

    public func tintTo(_ color: UIColor) -> UIImage? {
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        return UIGraphicsImageRenderer(size: size, format: format).image { context in
            color.setFill()
            context.fill(context.format.bounds)
            draw(in: context.format.bounds, blendMode: .destinationIn, alpha: 1.0)
        }
    }

    public func alpha(_ value: CGFloat) -> UIImage? {
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        return UIGraphicsImageRenderer(size: size, format: format).image { context in
            context.fill(context.format.bounds)
            draw(at: .zero, blendMode: .normal, alpha: value)
        }
    }
}

/// Avoid using these on large images
/// These all have to allocate new memory for image
extension UIImage {

    /// Crop the image by given targetRect
    /// if maximumSize is provided, image will be resized to longer edge not more than maximumSize
    public static func crop(
        image: UIImage,
        targetRect: CGRect,
        maximumSize: CGFloat? = nil
    ) -> UIImage {
        var targetRect = targetRect
        var scaleRatio = CGFloat(1)
        if let maximumSize = maximumSize {
            scaleRatio = min(1, maximumSize / max(targetRect.width, targetRect.height))
            targetRect.origin.x *= scaleRatio
            targetRect.origin.y *= scaleRatio
            targetRect.size.width *= scaleRatio
            targetRect.size.height *= scaleRatio
        }

        let format = UIGraphicsImageRendererFormat()
        format.scale = image.scale
        let renderer = UIGraphicsImageRenderer(size: targetRect.size, format: format)
        return renderer.image { context in
            image.draw(
                in: CGRect(
                    origin: CGPoint(x: -targetRect.minX, y: -targetRect.minY),
                    size: CGSize(width: image.size.width * scaleRatio,
                                 height: image.size.height * scaleRatio)
                )
            )
        }
    }

    /// Crop the center of image with ratio (width / height).
    /// if maximumSize is provided, image will be resized to longer edge not more than maximumSize
    public static func cropCenter(
        image: UIImage,
        targetRatio: CGFloat,
        maximumSize: CGFloat? = nil
    ) -> UIImage {
        let originalRatio = image.size.width / image.size.height
        var targetRect = CGRect.zero
        if originalRatio > targetRatio {
            targetRect.size.width = image.size.height * targetRatio
            targetRect.size.height = image.size.height
            targetRect.origin.x = (image.size.width - targetRect.size.width) / 2
            targetRect.origin.y = 0
        } else {
            targetRect.size.width = image.size.width
            targetRect.size.height = image.size.width / targetRatio
            targetRect.origin.x = 0
            targetRect.origin.y = (image.size.height - targetRect.size.height) / 2
        }

        var scaleRatio = CGFloat(1)
        if let maximumSize = maximumSize {
            scaleRatio = min(1, maximumSize / max(targetRect.width, targetRect.height))
            targetRect.origin.x *= scaleRatio
            targetRect.origin.y *= scaleRatio
            targetRect.size.width *= scaleRatio
            targetRect.size.height *= scaleRatio
        }

        let format = UIGraphicsImageRendererFormat()
        format.scale = image.scale
        let renderer = UIGraphicsImageRenderer(size: targetRect.size, format: format)
        return renderer.image { _ in
            image.draw(
                in: CGRect(
                    origin: CGPoint(x: -targetRect.minX, y: -targetRect.minY),
                    size: CGSize(width: image.size.width * scaleRatio,
                                 height: image.size.height * scaleRatio)
                )
            )
        }
    }

    /// Resize the image to shorter edge to given value, original aspect ratio
    /// will be preserved, if current shorter edge already
    /// smaller than desired shorter edge, nil will be produced
    public static func resizeImage(image: UIImage, shortEdgeTo shortEdge: CGFloat) -> UIImage? {
        let size = image.size
        let currentShortEdge = min(size.width, size.height)
        if currentShortEdge <= shortEdge {
            return nil
        }
        var newSize: CGSize
        if currentShortEdge == size.width {
            newSize = CGSize(
                width: shortEdge,
                height: (shortEdge / currentShortEdge) * size.height
            )
        } else {
            newSize = CGSize(
                width: (shortEdge / currentShortEdge) * size.width,
                height: shortEdge
            )
        }
        let format = UIGraphicsImageRendererFormat()
        format.scale = image.scale
        let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }

    /// Resize the image to longer edge to given value, original aspect ratio
    /// will be preserved, if current longer edge already
    /// smaller than desired longer edge, nil will be produced
    public static func resizeImage(image: UIImage, longEdgeTo longEdge: CGFloat) -> UIImage? {
        let size = image.size
        let currentLongEdge = max(size.width, size.height)
        if currentLongEdge <= longEdge {
            return nil
        }
        var newSize: CGSize
        if currentLongEdge == size.width {
            newSize = CGSize(
                width: longEdge,
                height: (longEdge / currentLongEdge) * size.height
            )
        } else {
            newSize = CGSize(
                width: (longEdge / currentLongEdge) * size.width,
                height: longEdge
            )
        }
        let format = UIGraphicsImageRendererFormat()
        format.scale = image.scale
        let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}

#endif
