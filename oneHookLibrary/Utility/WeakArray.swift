import Foundation

// https://www.objc.io/blog/2017/12/28/weak-arrays/

final class WeakBox<A: AnyObject> {
    weak var unbox: A?
    init(_ value: A) {
        unbox = value
    }
}

struct WeakArray<Element: AnyObject> {
    private var items: [WeakBox<Element>] = []

    init(_ elements: [Element]) {
        items = elements.map { WeakBox($0) }
    }
}

extension WeakArray: Collection {
    var startIndex: Int { items.startIndex }
    var endIndex: Int { items.endIndex }

    subscript(_ index: Int) -> Element? {
        items[index].unbox
    }

    func index(after idx: Int) -> Int {
        items.index(after: idx)
    }

    mutating func append(_ element: Element) {
        items.append(WeakBox(element))
    }

    mutating func prune() {
        items = items.filter { $0.unbox != nil }
    }

    typealias EquatableElement = AnyObject & Equatable

    mutating func remove<E: EquatableElement>(_ element: E) {
        if let index = items.firstIndex(where: { element == $0.unbox as? E }) {
            items.remove(at: index)
        }
    }
}
