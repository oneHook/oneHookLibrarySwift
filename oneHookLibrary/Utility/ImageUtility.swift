import UIKit

extension UIImage {

    public static func tintableImage(named name: String) -> UIImage? {
        let oImage = UIImage(named: name)
        return oImage?.withRenderingMode(.alwaysTemplate)
    }

    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }

    public static func circle(diameter: CGFloat, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.saveGState()

        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        ctx.setFillColor(color.cgColor)
        ctx.fillEllipse(in: rect)

        ctx.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return img
    }

    public func crop(toRect cropRect: CGRect) -> UIImage? {
        let rect = CGRect(
            x: cropRect.origin.x * scale,
            y: cropRect.origin.y * scale,
            width: cropRect.width * scale,
            height: cropRect.height * scale
        )

        guard let croppedImageRef = cgImage?.cropping(to: rect) else {
            return nil
        }

        return UIImage(cgImage: croppedImageRef, scale: scale, orientation: imageOrientation)
    }

    public static func cropToBounds(image: UIImage,
                                    width: Double,
                                    height: Double) -> UIImage {

        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)

        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            let newWidth = contextSize.height * 4 / 3
            posX = ((contextSize.width - newWidth) / 2)
            posY = 0
            cgwidth = newWidth
            cgheight = contextSize.height
        } else {
            let newHeight = contextSize.width / 4 * 3
            posX = 0
            posY = ((contextSize.height - newHeight) / 2)
            cgwidth = contextSize.width
            cgheight = newHeight
        }

        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)

        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!

        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)

        return image
    }

    /* Resize the image to shorter edge to given value, if current shorter edge already
       smaller than desired shorter edge, nil will be produced */
    public static func resizeImage(image: UIImage, shortEdgeTo shortEdge: CGFloat) -> UIImage? {
        let size = image.size
        let currentShortEdge = min(size.width, size.height)
        if currentShortEdge <= shortEdge {
            return nil
        }
        var newSize: CGSize
        if currentShortEdge == size.width {
            newSize = CGSize(width: shortEdge, height: (shortEdge / currentShortEdge) * size.height)
        } else {
            newSize = CGSize(width: (shortEdge / currentShortEdge) * size.width, height: shortEdge)
        }
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }

    public static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }

    public func tintTo(_ color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)

        guard
            let context = UIGraphicsGetCurrentContext(),
            let cgImage = cgImage else {
            return nil
        }

        color.setFill()
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.clip(to: CGRect(x: 0, y: 0, width: size.width, height: size.height), mask: cgImage)
        context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let coloredImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return coloredImg
    }

    public func alpha(_ value: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
