import XCTest
import Foundation
@testable import oneHookLibrary

// swiftlint:disable type_body_length
class DiffUtilityTests: XCTestCase {

    // swiftlint:disable function_body_length file_length
    func testDeleteOnlyWithRelativeOrder() {
        var array1 = [1, 2, 3, 4, 5]
        var array2 = [1, 2, 3, 4]

        var result = calculateDiffWithRelativeOrder(array1: array1,
                                                    array2: array2,
                                                    toIdentifier: { String($0) },
                                                    updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [4])
        XCTAssertEqual(result.deleteRelative, [4])
        XCTAssertEqual(result.insertAbsolute, [])
        XCTAssertEqual(result.insertRelative, [])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])

        array1 = [1, 2, 3, 4, 5, 6]
        array2 = [1, 3, 4, 5, 6]

        result = calculateDiffWithRelativeOrder(array1: array1,
                                                array2: array2,
                                                toIdentifier: { String($0) },
                                                updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [1])
        XCTAssertEqual(result.deleteRelative, [1])
        XCTAssertEqual(result.insertAbsolute, [])
        XCTAssertEqual(result.insertRelative, [])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])

        array1 = [1, 2, 3, 4]
        array2 = [2, 3, 4]

        result = calculateDiffWithRelativeOrder(array1: array1,
                                                array2: array2,
                                                toIdentifier: { String($0) },
                                                updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [0])
        XCTAssertEqual(result.deleteRelative, [0])
        XCTAssertEqual(result.insertAbsolute, [])
        XCTAssertEqual(result.insertRelative, [])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])

        array1 = [1, 2, 3, 4]
        array2 = [1, 2]

        result = calculateDiffWithRelativeOrder(array1: array1,
                                                array2: array2,
                                                toIdentifier: { String($0) },
                                                updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [2, 3])
        XCTAssertEqual(result.deleteRelative, [2, 2])
        XCTAssertEqual(result.insertAbsolute, [])
        XCTAssertEqual(result.insertRelative, [])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])

        array1 = [1, 2, 3, 4]
        array2 = [3, 4]

        result = calculateDiffWithRelativeOrder(array1: array1,
                                                array2: array2,
                                                toIdentifier: { String($0) },
                                                updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [0, 1])
        XCTAssertEqual(result.deleteRelative, [0, 0])
        XCTAssertEqual(result.insertAbsolute, [])
        XCTAssertEqual(result.insertRelative, [])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])

        array1 = [1, 2, 3, 4]
        array2 = [1, 4]

        result = calculateDiffWithRelativeOrder(array1: array1,
                                                array2: array2,
                                                toIdentifier: { String($0) },
                                                updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [1, 2])
        XCTAssertEqual(result.deleteRelative, [1, 1])
        XCTAssertEqual(result.insertAbsolute, [])
        XCTAssertEqual(result.insertRelative, [])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])

        array1 = [1, 2, 3, 4, 5]
        array2 = [1, 3, 5]

        result = calculateDiffWithRelativeOrder(array1: array1,
                                                array2: array2,
                                                toIdentifier: { String($0) },
                                                updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [1, 3])
        XCTAssertEqual(result.deleteRelative, [1, 2])
        XCTAssertEqual(result.insertAbsolute, [])
        XCTAssertEqual(result.insertRelative, [])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])

        array1 = [1, 2, 3, 4, 5]
        array2 = []

        result = calculateDiffWithRelativeOrder(array1: array1,
                                                array2: array2,
                                                toIdentifier: { String($0) },
                                                updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [0, 1, 2, 3, 4])
        XCTAssertEqual(result.deleteRelative, [0, 0, 0, 0, 0])
        XCTAssertEqual(result.insertAbsolute, [])
        XCTAssertEqual(result.insertRelative, [])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])

        array1 = [1, 2, 3, 4, 5]
        array2 = [2, 4]

        result = calculateDiffWithRelativeOrder(array1: array1,
                                                array2: array2,
                                                toIdentifier: { String($0) },
                                                updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [0, 2, 4])
        XCTAssertEqual(result.deleteRelative, [0, 1, 2])
        XCTAssertEqual(result.insertAbsolute, [])
        XCTAssertEqual(result.insertRelative, [])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])
    }
    // swiftlint:enable function_body_length

    // swiftlint:disable function_body_length
    func testInsertOnlyWithRelativeOrder() {
        var array1 = [1, 2, 3]
        var array2 = [0, 1, 2, 3]

        var result = calculateDiffWithRelativeOrder(array1: array1,
                                                    array2: array2,
                                                    toIdentifier: { String($0) },
                                                    updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [])
        XCTAssertEqual(result.deleteRelative, [])
        XCTAssertEqual(result.insertAbsolute, [0])
        XCTAssertEqual(result.insertRelative, [0])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])

        array1 = [1, 2, 3, 4]
        array2 = [1, 2, 3, 4, 5]

        result = calculateDiffWithRelativeOrder(array1: array1,
                                                array2: array2,
                                                toIdentifier: { String($0) },
                                                updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [])
        XCTAssertEqual(result.deleteRelative, [])
        XCTAssertEqual(result.insertAbsolute, [4])
        XCTAssertEqual(result.insertRelative, [4])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])

        array1 = [1, 2, 3, 4]
        array2 = [-1, 0, 1, 2, 3, 4]

        result = calculateDiffWithRelativeOrder(array1: array1,
                                                array2: array2,
                                                toIdentifier: { String($0) },
                                                updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [])
        XCTAssertEqual(result.deleteRelative, [])
        XCTAssertEqual(result.insertAbsolute, [0, 1])
        XCTAssertEqual(result.insertRelative, [0, 0])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])

        array1 = [1, 2, 3, 4]
        array2 = [1, 2, 3, 4, 5, 6]

        result = calculateDiffWithRelativeOrder(array1: array1,
                                                array2: array2,
                                                toIdentifier: { String($0) },
                                                updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [])
        XCTAssertEqual(result.deleteRelative, [])
        XCTAssertEqual(result.insertAbsolute, [4, 5])
        XCTAssertEqual(result.insertRelative, [4, 4])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])

        array1 = [1, 4]
        array2 = [1, 2, 3, 4]

        result = calculateDiffWithRelativeOrder(array1: array1,
                                                array2: array2,
                                                toIdentifier: { String($0) },
                                                updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [])
        XCTAssertEqual(result.deleteRelative, [])
        XCTAssertEqual(result.insertAbsolute, [1, 2])
        XCTAssertEqual(result.insertRelative, [1, 1])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])

        array1 = [1, 3, 5]
        array2 = [1, 2, 3, 4, 5]

        result = calculateDiffWithRelativeOrder(array1: array1,
                                                array2: array2,
                                                toIdentifier: { String($0) },
                                                updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [])
        XCTAssertEqual(result.deleteRelative, [])
        XCTAssertEqual(result.insertAbsolute, [1, 3])
        XCTAssertEqual(result.insertRelative, [1, 2])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])

        array1 = []
        array2 = [1, 2, 3, 4, 5]

        result = calculateDiffWithRelativeOrder(array1: array1,
                                                array2: array2,
                                                toIdentifier: { String($0) },
                                                updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [])
        XCTAssertEqual(result.deleteRelative, [])
        XCTAssertEqual(result.insertAbsolute, [0, 1, 2, 3, 4])
        XCTAssertEqual(result.insertRelative, [0, 0, 0, 0, 0])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])
    }
    // swiftlint:enable function_body_length

    func testUpdateOnlyWithRelativeOrder() {
        var array1 = [1, 2, 3]
        var array2 = [1, 2, 3]

        var result = calculateDiffWithRelativeOrder(array1: array1,
                                                    array2: array2,
                                                    toIdentifier: { String($0) },
                                                    updateCompare: { $0 != $1 })
        XCTAssertEqual(result.deleteAbsolute, [])
        XCTAssertEqual(result.deleteRelative, [])
        XCTAssertEqual(result.insertAbsolute, [])
        XCTAssertEqual(result.insertRelative, [])
        XCTAssertEqual(result.updateBefore, [0, 1, 2])
        XCTAssertEqual(result.updateAfter, [0, 1, 2])

        array1 = [1, 2, 3]
        array2 = [1, 2, 3]

        result = calculateDiffWithRelativeOrder(array1: array1,
                                                array2: array2,
                                                toIdentifier: { String($0) },
                                                updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [])
        XCTAssertEqual(result.deleteRelative, [])
        XCTAssertEqual(result.insertAbsolute, [])
        XCTAssertEqual(result.insertRelative, [])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])
    }

    func testComplicatedWithRelativeOrder() {
        var array1 = [5, 7, 9, 11, 13]
        var array2 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

        var result = calculateDiffWithRelativeOrder(array1: array1,
                                                    array2: array2,
                                                    toIdentifier: { String($0) },
                                                    updateCompare: { $0 != $1 })
        XCTAssertEqual(result.deleteAbsolute, [3, 4])
        XCTAssertEqual(result.deleteRelative, [3, 3])
        XCTAssertEqual(result.insertAbsolute, [0, 1, 2, 3, 5, 7, 9])
        XCTAssertEqual(result.insertRelative, [0, 0, 0, 0, 1, 2, 3])
        XCTAssertEqual(result.updateBefore, [0, 1, 2])
        XCTAssertEqual(result.updateAfter, [4, 6, 8])

        array1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        array2 = [5, 7, 9, 11, 13]

        result = calculateDiffWithRelativeOrder(array1: array1,
                                                array2: array2,
                                                toIdentifier: { String($0) },
                                                updateCompare: { $0 != $1 })
        XCTAssertEqual(result.deleteAbsolute, [0, 1, 2, 3, 5, 7, 9])
        XCTAssertEqual(result.deleteRelative, [0, 0, 0, 0, 1, 2, 3])
        XCTAssertEqual(result.insertAbsolute, [3, 4])
        XCTAssertEqual(result.insertRelative, [3, 3])
        XCTAssertEqual(result.updateBefore, [4, 6, 8])
        XCTAssertEqual(result.updateAfter, [0, 1, 2])
    }

    // swiftlint:disable function_body_length
    func testDeleteOnlyAnyOrder() {
        var array1 = [1, 2, 3, 4, 5]
        var array2 = [1, 2, 3, 4]

        var result = calculateDiffWithRelativeOrder(array1: array1,
                                                    array2: array2,
                                                    toIdentifier: { String($0) },
                                                    updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [4])
        XCTAssertEqual(result.deleteRelative, [4])
        XCTAssertEqual(result.insertAbsolute, [])
        XCTAssertEqual(result.insertRelative, [])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])
        XCTAssertEqual(result.moveAfter.count, 0)

        array1 = [1, 2, 3, 4, 5, 6]
        array2 = [1, 3, 4, 5, 6]

        result = calculateDiffWithRelativeOrder(array1: array1,
                                                array2: array2,
                                                toIdentifier: { String($0) },
                                                updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [1])
        XCTAssertEqual(result.deleteRelative, [1])
        XCTAssertEqual(result.insertAbsolute, [])
        XCTAssertEqual(result.insertRelative, [])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])
        XCTAssertEqual(result.moveAfter.count, 0)

        array1 = [1, 2, 3, 4]
        array2 = [2, 3, 4]

        result = calculateDiffWithRelativeOrder(array1: array1,
                                                array2: array2,
                                                toIdentifier: { String($0) },
                                                updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [0])
        XCTAssertEqual(result.deleteRelative, [0])
        XCTAssertEqual(result.insertAbsolute, [])
        XCTAssertEqual(result.insertRelative, [])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])
        XCTAssertEqual(result.moveAfter.count, 0)

        array1 = [1, 2, 3, 4]
        array2 = [1, 2]

        result = calculateDiffWithRelativeOrder(array1: array1,
                                                array2: array2,
                                                toIdentifier: { String($0) },
                                                updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [2, 3])
        XCTAssertEqual(result.deleteRelative, [2, 2])
        XCTAssertEqual(result.insertAbsolute, [])
        XCTAssertEqual(result.insertRelative, [])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])
        XCTAssertEqual(result.moveAfter.count, 0)

        array1 = [1, 2, 3, 4]
        array2 = [3, 4]

        result = calculateDiffWithRelativeOrder(array1: array1,
                                                array2: array2,
                                                toIdentifier: { String($0) },
                                                updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [0, 1])
        XCTAssertEqual(result.deleteRelative, [0, 0])
        XCTAssertEqual(result.insertAbsolute, [])
        XCTAssertEqual(result.insertRelative, [])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])
        XCTAssertEqual(result.moveAfter.count, 0)

        array1 = [1, 2, 3, 4]
        array2 = [1, 4]

        result = calculateDiffWithRelativeOrder(array1: array1,
                                                array2: array2,
                                                toIdentifier: { String($0) },
                                                updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [1, 2])
        XCTAssertEqual(result.deleteRelative, [1, 1])
        XCTAssertEqual(result.insertAbsolute, [])
        XCTAssertEqual(result.insertRelative, [])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])
        XCTAssertEqual(result.moveAfter.count, 0)

        array1 = [1, 2, 3, 4, 5]
        array2 = [1, 3, 5]

        result = calculateDiffWithRelativeOrder(array1: array1,
                                                array2: array2,
                                                toIdentifier: { String($0) },
                                                updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [1, 3])
        XCTAssertEqual(result.deleteRelative, [1, 2])
        XCTAssertEqual(result.insertAbsolute, [])
        XCTAssertEqual(result.insertRelative, [])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])
        XCTAssertEqual(result.moveAfter.count, 0)

        array1 = [1, 2, 3, 4, 5]
        array2 = []

        result = calculateDiffWithRelativeOrder(array1: array1,
                                                array2: array2,
                                                toIdentifier: { String($0) },
                                                updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [0, 1, 2, 3, 4])
        XCTAssertEqual(result.deleteRelative, [0, 0, 0, 0, 0])
        XCTAssertEqual(result.insertAbsolute, [])
        XCTAssertEqual(result.insertRelative, [])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])
        XCTAssertEqual(result.moveAfter.count, 0)

        array1 = [1, 2, 3, 4, 5]
        array2 = [2, 4]

        result = calculateDiffWithRelativeOrder(array1: array1,
                                                array2: array2,
                                                toIdentifier: { String($0) },
                                                updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [0, 2, 4])
        XCTAssertEqual(result.deleteRelative, [0, 1, 2])
        XCTAssertEqual(result.insertAbsolute, [])
        XCTAssertEqual(result.insertRelative, [])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])
        XCTAssertEqual(result.moveAfter.count, 0)
    }

    func testInsertOnlyAnyOrder() {
        var array1 = [1, 2, 3]
        var array2 = [0, 1, 2, 3]

        var result = calculateDiff(array1: array1,
                                   array2: array2,
                                   toIdentifier: { String($0) },
                                   updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [])
        XCTAssertEqual(result.deleteRelative, [])
        XCTAssertEqual(result.insertAbsolute, [0])
        XCTAssertEqual(result.insertRelative, [0])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])
        XCTAssertEqual(result.moveAfter.count, 0)

        array1 = [1, 2, 3, 4]
        array2 = [1, 2, 3, 4, 5]

        result = calculateDiff(array1: array1,
                               array2: array2,
                               toIdentifier: { String($0) },
                               updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [])
        XCTAssertEqual(result.deleteRelative, [])
        XCTAssertEqual(result.insertAbsolute, [4])
        XCTAssertEqual(result.insertRelative, [4])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])
        XCTAssertEqual(result.moveAfter.count, 0)

        array1 = [1, 2, 3, 4]
        array2 = [-1, 0, 1, 2, 3, 4]

        result = calculateDiff(array1: array1,
                               array2: array2,
                               toIdentifier: { String($0) },
                               updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [])
        XCTAssertEqual(result.deleteRelative, [])
        XCTAssertEqual(result.insertAbsolute, [0, 1])
        XCTAssertEqual(result.insertRelative, [0, 0])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])
        XCTAssertEqual(result.moveAfter.count, 0)

        array1 = [1, 2, 3, 4]
        array2 = [1, 2, 3, 4, 5, 6]

        result = calculateDiff(array1: array1,
                               array2: array2,
                               toIdentifier: { String($0) },
                               updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [])
        XCTAssertEqual(result.deleteRelative, [])
        XCTAssertEqual(result.insertAbsolute, [4, 5])
        XCTAssertEqual(result.insertRelative, [4, 4])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])
        XCTAssertEqual(result.moveAfter.count, 0)

        array1 = [1, 4]
        array2 = [1, 2, 3, 4]

        result = calculateDiff(array1: array1,
                               array2: array2,
                               toIdentifier: { String($0) },
                               updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [])
        XCTAssertEqual(result.deleteRelative, [])
        XCTAssertEqual(result.insertAbsolute, [1, 2])
        XCTAssertEqual(result.insertRelative, [1, 1])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])
        XCTAssertEqual(result.moveAfter.count, 0)

        array1 = [1, 3, 5]
        array2 = [1, 2, 3, 4, 5]

        result = calculateDiff(array1: array1,
                               array2: array2,
                               toIdentifier: { String($0) },
                               updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [])
        XCTAssertEqual(result.deleteRelative, [])
        XCTAssertEqual(result.insertAbsolute, [1, 3])
        XCTAssertEqual(result.insertRelative, [1, 2])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])
        XCTAssertEqual(result.moveAfter.count, 0)

        array1 = []
        array2 = [1, 2, 3, 4, 5]

        result = calculateDiff(array1: array1,
                               array2: array2,
                               toIdentifier: { String($0) },
                               updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [])
        XCTAssertEqual(result.deleteRelative, [])
        XCTAssertEqual(result.insertAbsolute, [0, 1, 2, 3, 4])
        XCTAssertEqual(result.insertRelative, [0, 0, 0, 0, 0])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])
        XCTAssertEqual(result.moveAfter.count, 0)
    }
    // swiftlint:enable function_body_length

    func testUpdateOnlyAnyOrder() {
        var array1 = [1, 2, 3]
        var array2 = [1, 2, 3]

        var result = calculateDiff(array1: array1,
                                   array2: array2,
                                   toIdentifier: { String($0) },
                                   updateCompare: { $0 != $1 })
        XCTAssertEqual(result.deleteAbsolute, [])
        XCTAssertEqual(result.deleteRelative, [])
        XCTAssertEqual(result.insertAbsolute, [])
        XCTAssertEqual(result.insertRelative, [])
        XCTAssertEqual(result.updateBefore, [0, 1, 2])
        XCTAssertEqual(result.updateAfter, [0, 1, 2])
        XCTAssertEqual(result.moveAfter.count, 0)

        array1 = [1, 2, 3]
        array2 = [1, 2, 3]

        result = calculateDiff(array1: array1,
                               array2: array2,
                               toIdentifier: { String($0) },
                               updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [])
        XCTAssertEqual(result.deleteRelative, [])
        XCTAssertEqual(result.insertAbsolute, [])
        XCTAssertEqual(result.insertRelative, [])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])
        XCTAssertEqual(result.moveAfter.count, 0)
    }

    func testMoveAnyOrder() {
        var array1 = [1, 2, 3, 4, 5]
        var array2 = [5, 2, 1, 3, 4]

        var result = calculateDiff(array1: array1,
                                   array2: array2,
                                   toIdentifier: { String($0) },
                                   updateCompare: { $0 != $1 })
        XCTAssertEqual(result.deleteAbsolute, [])
        XCTAssertEqual(result.deleteRelative, [])
        XCTAssertEqual(result.insertAbsolute, [])
        XCTAssertEqual(result.insertRelative, [])
        XCTAssertEqual(result.updateBefore, [0, 1, 2, 3, 4])
        XCTAssertEqual(result.updateAfter, [2, 1, 3, 4, 0])
        var moveAfter = result.moveAfter.map { [$0.from, $0.to]}
        XCTAssertEqual(moveAfter, [[0, 2], [2, 3], [3, 4], [4, 0]])

        array1 = [1, 2, 3, 4]
        array2 = [4, 2, 3, 1]

        result = calculateDiff(array1: array1,
                               array2: array2,
                               toIdentifier: { String($0) },
                               updateCompare: { $0 == $1 })
        XCTAssertEqual(result.deleteAbsolute, [])
        XCTAssertEqual(result.deleteRelative, [])
        XCTAssertEqual(result.insertAbsolute, [])
        XCTAssertEqual(result.insertRelative, [])
        XCTAssertEqual(result.updateBefore, [])
        XCTAssertEqual(result.updateAfter, [])
        moveAfter = result.moveAfter.map { [$0.from, $0.to]}
        XCTAssertEqual(moveAfter, [[0, 3]])

    }

    func testComplicatedAnyOrder() {
        var array1 = [5, 7, 9, 11, 13]
        var array2 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

        var result = calculateDiff(array1: array1,
                                   array2: array2,
                                   toIdentifier: { String($0) },
                                   updateCompare: { $0 != $1 })
        XCTAssertEqual(result.deleteAbsolute, [3, 4])
        XCTAssertEqual(result.deleteRelative, [3, 3])
        XCTAssertEqual(result.insertAbsolute, [0, 1, 2, 3, 5, 7, 9])
        XCTAssertEqual(result.insertRelative, [0, 0, 0, 0, 1, 2, 3])
        XCTAssertEqual(result.updateBefore, [0, 1, 2])
        XCTAssertEqual(result.updateAfter, [4, 6, 8])
        XCTAssertEqual(result.moveAfter.count, 0)

        array1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        array2 = [9, 7, 11, 5, 13]
        result = calculateDiff(array1: array1,
                               array2: array2,
                               toIdentifier: { String($0) },
                               updateCompare: { $0 != $1 })
        XCTAssertEqual(result.deleteAbsolute, [0, 1, 2, 3, 5, 7, 9])
        XCTAssertEqual(result.deleteRelative, [0, 0, 0, 0, 1, 2, 3])
        XCTAssertEqual(result.insertAbsolute, [2, 4])
        XCTAssertEqual(result.insertRelative, [2, 3])
        XCTAssertEqual(result.updateBefore, [4, 6, 8])
        XCTAssertEqual(result.updateAfter, [3, 1, 0])
        let moveAfter = result.moveAfter.map { [$0.from, $0.to]}
        XCTAssertEqual(moveAfter, [[0, 3]])
    }

    func testComplicatedWildlyRandomOrder() {
        let array1 = [5, 7, 9, 11, 13]
        let array2 = [15, 7, 5, 3, 4, 10, 9, 1, 2]

        let result = calculateDiff(array1: array1,
                                   array2: array2,
                                   toIdentifier: { String($0) },
                                   updateCompare: { $0 != $1 })
        XCTAssertEqual(result.deleteAbsolute, [3, 4])
        XCTAssertEqual(result.deleteRelative, [3, 3])
        XCTAssertEqual(result.insertAbsolute, [0, 3, 4, 5, 7, 8])
        XCTAssertEqual(result.insertRelative, [0, 2, 2, 2, 3, 3])
        XCTAssertEqual(result.updateBefore, [0, 1, 2])
        XCTAssertEqual(result.updateAfter, [2, 1, 6])
        XCTAssertEqual(result.moveAfter.count, 1)
    }
}
// swiftlint:enable type_body_length file_length
