import UIKit

public protocol StaggeredColleciontViewLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat
}

open class StaggeredCollectionViewLayout: UICollectionViewLayout {

    public weak var delegate: StaggeredColleciontViewLayoutDelegate?

    public var numColumns = 3
    public var horizontalSpacing: CGFloat = dp(8)
    public var verticalSpacing: CGFloat = dp(8)

    private var cache: [UICollectionViewLayoutAttributes] = []

    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    private var contentHeight: CGFloat = 0

    public override var collectionViewContentSize: CGSize {
        CGSize(width: contentWidth, height: contentHeight)
    }

    public override func prepare() {
        guard
            let collectionView = collectionView else {
            return
        }
        print("Prepare called", cache.count)

        /* For now, we recalculate everything */
        cache.removeAll()

        let contentWidth = self.contentWidth

        /* Same cell width always */
        let cellWidth = (contentWidth - CGFloat(numColumns - 1) * horizontalSpacing ) / CGFloat(numColumns)
        let xOffset = (0..<numColumns).map { CGFloat($0) * (cellWidth + horizontalSpacing) }
        var yOffset: [CGFloat] = .init(repeating: 0, count: numColumns)

        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)

            let cellHeight = delegate?.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath, cellWidth: cellWidth) ?? 180
            let targetColumn = yOffset.indices.min { (i1, i2) -> Bool in
                yOffset[i1] < yOffset[i2]
            } ?? 0
            let cellFrame = CGRect(
                x: xOffset[targetColumn],
                y: yOffset[targetColumn] + verticalSpacing,
                width: cellWidth,
                height: cellHeight
            )

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = cellFrame
            cache.append(attributes)

            contentHeight = max(contentHeight, cellFrame.maxY)
            yOffset[targetColumn] += verticalSpacing + cellHeight
        }
    }

    open override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let attr = cache[safe: itemIndexPath.item] {
            let newAttr = UICollectionViewLayoutAttributes(forCellWith: itemIndexPath)
            newAttr.frame = attr.frame.offsetBy(dx: 0, dy: dp(500))
            return newAttr
        }
        return nil
    }

    open override func layoutAttributesForElements(in rect: CGRect)
    -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }

    open override func layoutAttributesForItem(at indexPath: IndexPath)
    -> UICollectionViewLayoutAttributes? {
        cache[indexPath.item]
    }
}
