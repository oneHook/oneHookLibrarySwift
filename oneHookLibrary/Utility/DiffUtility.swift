import Foundation

public struct DiffResult {
    public let deleteAbsolute: [Int]
    public let deleteRelative: [Int]
    public let insertAbsolute: [Int]
    public let insertRelative: [Int]
    public let updateBefore: [Int]
    public let updateAfter: [Int]
    public let moveBefore: [(from: Int, to: Int)]
    public let moveAfter: [(from: Int, to: Int)]
}

public func calculateDiffWithRelativeOrder<T: Any, IdType: Comparable>(
    array1: [T],
    array2: [T],
    toIdentifier: (T) -> IdType,
    updateCompare: (T, T) -> Bool) -> DiffResult {
    var array1 = array1
    let array2 = array2
    var compare1 = array1.map { toIdentifier($0) }
    let compare2 = array2.map { toIdentifier($0) }

    var toDeleteAbsolute = [Int]()
    var toDeleteRelative = [Int]()
    var toInsertAbsolute = [Int]()
    var toInsertRelative = [Int]()
    var toUpdateBefore = [Int]()
    var toUpdateAfter = [Int]()

    var deletedCount = 0
    var insertedCount = 0

    var index1 = 0
    var index2 = 0

    /* Check all deleted ones first */
    while index1 < array1.count && index2 < array2.count {
        if compare1[index1] == compare2[index2] {
            if !updateCompare(array1[index1], array2[index2]) {
                toUpdateBefore.append(index1)
            }
            index1 += 1
            index2 += 1
        } else if compare1[index1] < compare2[index2] {
            /* Deleted */
            toDeleteAbsolute.append(index1)
            toDeleteRelative.append(index1 - deletedCount)
            deletedCount += 1
            index1 += 1
        } else {
            /* Inserted */
            index2 += 1
        }
    }

    while index1 < array1.count {
        toDeleteAbsolute.append(index1)
        toDeleteRelative.append(index1 - deletedCount)
        deletedCount += 1
        index1 += 1
    }

    /* Remove all deleted ones */
    for index in toDeleteRelative {
        array1.remove(at: index)
        compare1.remove(at: index)
    }

    index1 = 0
    index2 = 0

    /* Check all inserted ones */
    while index1 < array1.count && index2 < array2.count {
        if compare1[index1] == compare2[index2] {
            if !updateCompare(array1[index1], array2[index2]) {
                toUpdateAfter.append(index2)
            }
            index1 += 1
            index2 += 1
        } else {
            /* Inserted */
            toInsertAbsolute.append(index1 + insertedCount)
            toInsertRelative.append(index1)
            insertedCount += 1
            index2 += 1
        }
    }

    while index2 < array2.count {
        toInsertAbsolute.append(index2)
        toInsertRelative.append(index2 - insertedCount)
        insertedCount += 1
        index2 += 1
    }

    return DiffResult(deleteAbsolute: toDeleteAbsolute,
                      deleteRelative: toDeleteRelative,
                      insertAbsolute: toInsertAbsolute,
                      insertRelative: toInsertRelative,
                      updateBefore: toUpdateBefore,
                      updateAfter: toUpdateAfter,
                      moveBefore: [],
                      moveAfter: [])
}

// swiftlint:disable cyclomatic_complexity
public func calculateDiff<T: Any, IdType: Equatable>(
    array1: [T],
    array2: [T],
    toIdentifier: (T) -> IdType,
    updateCompare: (T, T) -> Bool) -> DiffResult {

    var array1 = array1
    let array2 = array2
    var compare1 = array1.map { toIdentifier($0) }
    let compare2 = array2.map { toIdentifier($0) }
    let originalCompare1 = compare1
    let originalCompare2 = compare2

    var toDeleteAbsolute = [Int]()
    var toDeleteRelative = [Int]()
    var toInsertAbsolute = [Int]()
    var toInsertRelative = [Int]()
    var toUpdateBefore = [Int]()
    var toUpdateAfter = [Int]()

    var index = 0
    var deletedCount = 0
    var insertedCount = 0

    while index < compare1.count {
        if !compare2.contains(compare1[index]) {
            /* Deleted */
            toDeleteAbsolute.append(index)
            toDeleteRelative.append(index - deletedCount)
            deletedCount += 1
        }
        index += 1
    }

    /* Remove all deleted ones */
    for index in toDeleteRelative {
        array1.remove(at: index)
        compare1.remove(at: index)
    }

    index = 0
    while index < compare2.count {
        if !compare1.contains(compare2[index]) {
            /* New element found */
            /* Inserted */
            toInsertAbsolute.append(index)
            toInsertRelative.append(index - insertedCount)
            insertedCount += 1
        }
        index += 1
    }

    /* Insert all new ones */
    for index in toInsertAbsolute {
        array1.insert(array2[index], at: index)
        compare1.insert(compare2[index], at: index)
    }

    var toMoveBefore = [(from: Int, to: Int)]()
    var toMoveAfter = [(from: Int, to: Int)]()

    index = 0
    while index < compare1.count {
        let currItem = compare1[index]
        guard
            let originalIndex1 = originalCompare1.firstIndex(of: currItem),
            let originalIndex2 = originalCompare2.firstIndex(of: currItem),
            let index2 = compare2.firstIndex(of: currItem) else {
                index += 1
                continue
        }

        if index != index2 {
            /* Moved */
            if !toMoveAfter.contains(where: { (entry) -> Bool in
                entry.from == index2 && entry.to == index
            }) {
                toMoveAfter.append((from: index, to: index2))
            }
        }
        if originalIndex1 != originalIndex2 {
            /* Moved */
            if !toMoveBefore.contains(where: { (entry) -> Bool in
                entry.from == originalIndex2 && entry.to == originalIndex1
            }) {
                toMoveBefore.append((from: originalIndex1, to: originalIndex2))
            }
        }

        if !updateCompare(array1[index], array2[index2]) {
            toUpdateBefore.append(originalIndex1)
            toUpdateAfter.append(index2)
        }
        index += 1
    }

    return DiffResult(deleteAbsolute: toDeleteAbsolute,
                      deleteRelative: toDeleteRelative,
                      insertAbsolute: toInsertAbsolute,
                      insertRelative: toInsertRelative,
                      updateBefore: toUpdateBefore,
                      updateAfter: toUpdateAfter,
                      moveBefore: toMoveBefore,
                      moveAfter: toMoveAfter)
}
// swiftlint:enable cyclomatic_complexity
