import Foundation

extension Array {
    
    public func insertionIndexOf(elem: Element, isOrderedBefore: (Element, Element) -> Bool) -> Int {
        var low = 0
        var high = self.count - 1
        while low <= high {
            let mid = (low + high) / 2
            if isOrderedBefore(self[mid], elem) {
                low = mid + 1
            } else if isOrderedBefore(elem, self[mid]) {
                high = mid - 1
            } else {
                return mid
            }
        }
        return low
    }

    public func appending<S>(contentsOf newElements: S) -> Self where Element == S.Element, S: Sequence {
        var result = self
        result.append(contentsOf: newElements)
        return result
    }
}

public func makeOrRemove(toTargetCount targetCount: Int,
                         from startCount: Int,
                         make: () -> Void,
                         remove: () -> Void) {
    var startCount = startCount
    while startCount > targetCount {
        remove()
        startCount -= 1
    }
    while startCount < targetCount {
        make()
        startCount += 1
    }
}
