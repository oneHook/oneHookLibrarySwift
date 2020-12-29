import XCTest
@testable import oneHookLibrary

private func mins(_ count: Float) -> TimeInterval {
    DateUtils.secondsInMinute * TimeInterval(count)
}

private func hours(_ count: Float) -> TimeInterval {
    DateUtils.secondsInHour * TimeInterval(count)
}

private func days(_ count: Float) -> TimeInterval {
    DateUtils.secondsInDay * TimeInterval(count)
}

public func == (lhs: DateUtils.TimeDifference, rhs: DateUtils.TimeDifference) -> Bool {
    lhs.direction == rhs.direction && lhs.unit == rhs.unit && lhs.value == rhs.value
}

class DateUtilsUnitTests: XCTestCase {

    func testTimeGeneralCase() {
        let now = Date()
        var result = DateUtils.compare(from: now, with: Date(timeInterval: -4, since: now))
        XCTAssert(result == DateUtils.TimeDifference(direction: .before,
                                                     unit: .second,
                                                     value: 4,
                                                     deltaSeconds: 0))

        result = DateUtils.compare(from: now, with: Date(timeInterval: mins(-4), since: now))
        XCTAssert(result == DateUtils.TimeDifference(direction: .before,
                                                     unit: .minute,
                                                     value: 4,
                                                     deltaSeconds: 0))

        result = DateUtils.compare(from: now, with: Date(timeInterval: hours(-4), since: now))
        XCTAssert(result == DateUtils.TimeDifference(direction: .before,
                                                     unit: .hour,
                                                     value: 4,
                                                     deltaSeconds: 0))

        result = DateUtils.compare(from: now, with: Date(timeInterval: days(-4), since: now))
        XCTAssert(result == DateUtils.TimeDifference(direction: .before,
                                                     unit: .day,
                                                     value: 4,
                                                     deltaSeconds: 0))

        result = DateUtils.compare(from: now, with: Date(timeInterval: days(-8), since: now))
        XCTAssert(result == DateUtils.TimeDifference(direction: .before,
                                                     unit: .week,
                                                     value: 1,
                                                     deltaSeconds: 0))

        /* if not using secondCompareOnly, it may produce more 'realistic result' */
        result = DateUtils.compare(from: now, with: Date(timeInterval: days(-32), since: now), secondCompareOnly: true)
        XCTAssert(result == DateUtils.TimeDifference(direction: .before,
                                                     unit: .month,
                                                     value: 1,
                                                     deltaSeconds: 0))

        result = DateUtils.compare(from: now, with: Date(timeInterval: days(-366), since: now))
        XCTAssert(result == DateUtils.TimeDifference(direction: .before,
                                                     unit: .year,
                                                     value: 1,
                                                     deltaSeconds: 0))
    }

    func testRealCaseFutureSecondMinutes() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"
        
        var date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        var date2 = formatter.date(from: "2020-01-31 20:28:46 +0000")!
        var result = DateUtils.compare(from: date1, with: date2)
        XCTAssert(result == DateUtils.TimeDifference(direction: .before,
                                                     unit: .second,
                                                     value: 2,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        date2 = formatter.date(from: "2020-01-31 20:27:49 +0000")!
        result = DateUtils.compare(from: date1, with: date2)
        XCTAssert(result == DateUtils.TimeDifference(direction: .before,
                                                     unit: .second,
                                                     value: 59,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        date2 = formatter.date(from: "2020-01-31 20:27:48 +0000")!
        result = DateUtils.compare(from: date1, with: date2)
        XCTAssert(result == DateUtils.TimeDifference(direction: .before,
                                                     unit: .minute,
                                                     value: 1,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        date2 = formatter.date(from: "2020-01-31 20:26:49 +0000")!
        result = DateUtils.compare(from: date1, with: date2)
        XCTAssert(result == DateUtils.TimeDifference(direction: .before,
                                                     unit: .minute,
                                                     value: 1,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        date2 = formatter.date(from: "2020-01-31 20:26:43 +0000")!
        result = DateUtils.compare(from: date1, with: date2)
        XCTAssert(result == DateUtils.TimeDifference(direction: .before,
                                                     unit: .minute,
                                                     value: 2,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        date2 = formatter.date(from: "2020-01-31 20:21:43 +0000")!
        result = DateUtils.compare(from: date1, with: date2)
        XCTAssert(result == DateUtils.TimeDifference(direction: .before,
                                                     unit: .minute,
                                                     value: 7,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        date2 = formatter.date(from: "2020-01-31 19:29:43 +0000")!
        result = DateUtils.compare(from: date1, with: date2)
        XCTAssert(result == DateUtils.TimeDifference(direction: .before,
                                                     unit: .minute,
                                                     value: 59,
                                                     deltaSeconds: 0))
    }

    func testRealCaseFutureHourDay() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"

        var date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        var date2 = formatter.date(from: "2020-01-31 4:28:46 +0000")!
        var result = DateUtils.compare(from: date1, with: date2)
        XCTAssert(result == DateUtils.TimeDifference(direction: .before,
                                                     unit: .hour,
                                                     value: 16,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        date2 = formatter.date(from: "2020-01-30 20:28:48 +0000")!
        result = DateUtils.compare(from: date1, with: date2)
        XCTAssert(result == DateUtils.TimeDifference(direction: .before,
                                                     unit: .day,
                                                     value: 1,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        date2 = formatter.date(from: "2020-01-30 20:28:42 +0000")!
        result = DateUtils.compare(from: date1, with: date2)
        XCTAssert(result == DateUtils.TimeDifference(direction: .before,
                                                     unit: .day,
                                                     value: 1,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        date2 = formatter.date(from: "2020-01-30 08:28:48 +0000")!
        result = DateUtils.compare(from: date1, with: date2)
        XCTAssert(result == DateUtils.TimeDifference(direction: .before,
                                                     unit: .day,
                                                     value: 1,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        date2 = formatter.date(from: "2020-01-30 02:28:48 +0000")!
        result = DateUtils.compare(from: date1, with: date2)
        XCTAssert(result == DateUtils.TimeDifference(direction: .before,
                                                     unit: .day,
                                                     value: 1,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-01-31 00:00:01 +0000")!
        date2 = formatter.date(from: "2020-01-29 00:00:01 +0000")!
        result = DateUtils.compare(from: date1, with: date2)
        XCTAssert(result == DateUtils.TimeDifference(direction: .before,
                                                     unit: .day,
                                                     value: 2,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-01-31 00:00:01 +0000")!
        date2 = formatter.date(from: "2020-01-29 00:00:02 +0000")!
        result = DateUtils.compare(from: date1, with: date2)
        XCTAssert(result == DateUtils.TimeDifference(direction: .before,
                                                     unit: .day,
                                                     value: 2,
                                                     deltaSeconds: 0))

    }

    func testRealCaseDayMonthYear() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"

        var date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        var date2 = formatter.date(from: "2020-01-30 20:28:48 +0000")!
        var result = DateUtils.compare(from: date1, with: date2)
        XCTAssert(result == DateUtils.TimeDifference(direction: .before,
                                                     unit: .day,
                                                     value: 1,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        date2 = formatter.date(from: "2020-01-28 23:28:48 +0000")!
        result = DateUtils.compare(from: date1, with: date2)
        XCTAssert(result == DateUtils.TimeDifference(direction: .before,
                                                     unit: .day,
                                                     value: 3,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        date2 = formatter.date(from: "2020-01-20 23:28:48 +0000")!
        result = DateUtils.compare(from: date1, with: date2)
        XCTAssert(result == DateUtils.TimeDifference(direction: .before,
                                                     unit: .week,
                                                     value: 1,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        date2 = formatter.date(from: "2019-01-20 23:28:48 +0000")!
        result = DateUtils.compare(from: date1, with: date2)
        XCTAssert(result == DateUtils.TimeDifference(direction: .before,
                                                     unit: .year,
                                                     value: 1,
                                                     deltaSeconds: 0))
    }

    func testRealCasePastSecondMinutes() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"

        var date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        var date2 = formatter.date(from: "2020-01-31 20:28:46 +0000")!
        var result = DateUtils.compare(from: date2, with: date1)
        XCTAssert(result == DateUtils.TimeDifference(direction: .after,
                                                     unit: .second,
                                                     value: 2,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        date2 = formatter.date(from: "2020-01-31 20:27:49 +0000")!
        result = DateUtils.compare(from: date2, with: date1)
        XCTAssert(result == DateUtils.TimeDifference(direction: .after,
                                                     unit: .second,
                                                     value: 59,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        date2 = formatter.date(from: "2020-01-31 20:27:48 +0000")!
        result = DateUtils.compare(from: date2, with: date1)
        XCTAssert(result == DateUtils.TimeDifference(direction: .after,
                                                     unit: .minute,
                                                     value: 1,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        date2 = formatter.date(from: "2020-01-31 20:26:49 +0000")!
        result = DateUtils.compare(from: date2, with: date1)
        XCTAssert(result == DateUtils.TimeDifference(direction: .after,
                                                     unit: .minute,
                                                     value: 1,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        date2 = formatter.date(from: "2020-01-31 20:26:43 +0000")!
        result = DateUtils.compare(from: date2, with: date1)
        XCTAssert(result == DateUtils.TimeDifference(direction: .after,
                                                     unit: .minute,
                                                     value: 2,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        date2 = formatter.date(from: "2020-01-31 20:21:43 +0000")!
        result = DateUtils.compare(from: date2, with: date1)
        XCTAssert(result == DateUtils.TimeDifference(direction: .after,
                                                     unit: .minute,
                                                     value: 7,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        date2 = formatter.date(from: "2020-01-31 19:29:43 +0000")!
        result = DateUtils.compare(from: date2, with: date1)
        XCTAssert(result == DateUtils.TimeDifference(direction: .after,
                                                     unit: .minute,
                                                     value: 59,
                                                     deltaSeconds: 0))
    }

    func testRealCasePastHourDay() {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"

        var date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        var date2 = formatter.date(from: "2020-01-31 4:28:46 +0000")!
        var result = DateUtils.compare(from: date2, with: date1)
        XCTAssert(result == DateUtils.TimeDifference(direction: .after,
                                                     unit: .hour,
                                                     value: 16,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        date2 = formatter.date(from: "2020-01-30 20:28:48 +0000")!
        result = DateUtils.compare(from: date2, with: date1)
        XCTAssert(result == DateUtils.TimeDifference(direction: .after,
                                                     unit: .day,
                                                     value: 1,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        date2 = formatter.date(from: "2020-01-30 20:28:42 +0000")!
        result = DateUtils.compare(from: date2, with: date1)
        XCTAssert(result == DateUtils.TimeDifference(direction: .after,
                                                     unit: .day,
                                                     value: 1,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        date2 = formatter.date(from: "2020-01-30 08:28:48 +0000")!
        result = DateUtils.compare(from: date2, with: date1)
        XCTAssert(result == DateUtils.TimeDifference(direction: .after,
                                                     unit: .day,
                                                     value: 1,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        date2 = formatter.date(from: "2020-01-30 02:28:48 +0000")!
        result = DateUtils.compare(from: date2, with: date1)
        XCTAssert(result == DateUtils.TimeDifference(direction: .after,
                                                     unit: .day,
                                                     value: 1,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-01-31 00:00:01 +0000")!
        date2 = formatter.date(from: "2020-01-29 00:00:01 +0000")!
        result = DateUtils.compare(from: date2, with: date1)
        XCTAssert(result == DateUtils.TimeDifference(direction: .after,
                                                     unit: .day,
                                                     value: 2,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-01-31 00:00:01 +0000")!
        date2 = formatter.date(from: "2020-01-29 00:00:02 +0000")!
        result = DateUtils.compare(from: date2, with: date1)
        XCTAssert(result == DateUtils.TimeDifference(direction: .after,
                                                     unit: .day,
                                                     value: 2,
                                                     deltaSeconds: 0))

    }

    func testRealCasePastDayMonthYear() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"

        var date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        var date2 = formatter.date(from: "2020-01-30 20:28:48 +0000")!
        var result = DateUtils.compare(from: date2, with: date1)
        XCTAssert(result == DateUtils.TimeDifference(direction: .after,
                                                     unit: .day,
                                                     value: 1,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        date2 = formatter.date(from: "2020-01-28 23:28:48 +0000")!
        result = DateUtils.compare(from: date2, with: date1)
        XCTAssert(result == DateUtils.TimeDifference(direction: .after,
                                                     unit: .day,
                                                     value: 3,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        date2 = formatter.date(from: "2020-01-20 23:28:48 +0000")!
        result = DateUtils.compare(from: date2, with: date1)
        XCTAssert(result == DateUtils.TimeDifference(direction: .after,
                                                     unit: .week,
                                                     value: 1,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        date2 = formatter.date(from: "2019-01-20 23:28:48 +0000")!
        result = DateUtils.compare(from: date2, with: date1)
        XCTAssert(result == DateUtils.TimeDifference(direction: .after,
                                                     unit: .year,
                                                     value: 1,
                                                     deltaSeconds: 0))
    }

    func testEdgeCases() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"

        var date1 = formatter.date(from: "2020-02-02 11:59:59 +0000")!
        var date2 = formatter.date(from: "2020-02-01 15:28:48 +0000")!
        var result = DateUtils.compare(from: date1, with: date2,
                                       minUnit: .day,
                                       maxUnit: .day)
        XCTAssert(result == DateUtils.TimeDifference(direction: .before,
                                                     unit: .day,
                                                     value: 1,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-02-05 11:59:59 +0000")!
        date2 = formatter.date(from: "2020-02-05 02:28:48 +0000")!
        result = DateUtils.compare(from: date1,
                                   with: date2,
                                   minUnit: .day,
                                   maxUnit: .day)
        XCTAssert(result == DateUtils.TimeDifference(direction: .before,
                                                     unit: .day,
                                                     value: 0,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-02-05 11:59:59 +0000")!
        date2 = formatter.date(from: "2020-02-01 15:28:48 +0000")!
        result = DateUtils.compare(from: date1, with: date2)
        XCTAssert(result == DateUtils.TimeDifference(direction: .before,
                                                     unit: .day,
                                                     value: 4,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        date2 = formatter.date(from: "2020-01-31 04:59:59 +0000")!
        result = DateUtils.compare(from: date1,
                                   with: date2,
                                   minUnit: .day,
                                   maxUnit: .day)
        XCTAssert(result == DateUtils.TimeDifference(direction: .before,
                                                     unit: .day,
                                                     value: 0,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-01-31 20:28:48 +0000")!
        date2 = formatter.date(from: "2019-11-26 04:59:59 +0000")!
        result = DateUtils.compare(from: date1,
                                   with: date2,
                                   minUnit: .day,
                                   maxUnit: .day)
        XCTAssert(result == DateUtils.TimeDifference(direction: .before,
                                                     unit: .day,
                                                     value: 66,
                                                     deltaSeconds: 0))
    }

    /**
     * Examples from doc.
     * https://docs.google.com/document/d/11FFq0reA1zx58xjXxCPHCFNztbAZxrDEDCnv6VDGm6I/edit#heading=h.us13ae7igef0
     */
    func testEDealerDoc() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"

        var date1 = formatter.date(from: "2020-02-01 23:59:00 +0000")!
        var date2 = formatter.date(from: "2020-02-02 00:01:01 +0000")!
        var result = DateUtils.compare(from: date1, with: date2, secondCompareOnly: true)
        XCTAssert(result == DateUtils.TimeDifference(direction: .after,
                                                     unit: .minute,
                                                     value: 2,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-02-01 23:59:00 +0000")!
        date2 = formatter.date(from: "2020-02-03 00:01:01 +0000")!
        result = DateUtils.compare(from: date1,
                                   with: date2,
                                   secondCompareOnly: true)
        XCTAssert(result == DateUtils.TimeDifference(direction: .after,
                                                     unit: .day,
                                                     value: 1,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-02-01 00:00:00 +0000")!
        date2 = formatter.date(from: "2020-02-01 23:59:00 +0000")!
        result = DateUtils.compare(from: date1,
                                   with: date2,
                                   secondCompareOnly: true)
        XCTAssert(result == DateUtils.TimeDifference(direction: .after,
                                                     unit: .hour,
                                                     value: 23,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-02-01 16:00:00 +0000")!
        date2 = formatter.date(from: "2020-02-03 15:59:00 +0000")!
        result = DateUtils.compare(from: date1,
                                   with: date2,
                                   secondCompareOnly: true)
        XCTAssert(result == DateUtils.TimeDifference(direction: .after,
                                                     unit: .day,
                                                     value: 1,
                                                     deltaSeconds: 0))

        date1 = formatter.date(from: "2020-02-01 00:00:00 +0000")!
        date2 = formatter.date(from: "2020-02-01 23:59:00 +0000")!
        result = DateUtils.compare(from: date1,
                                   with: date2,
                                   minUnit: .day,
                                   maxUnit: .day,
                                   secondCompareOnly: true)
        XCTAssert(result == DateUtils.TimeDifference(direction: .after,
                                                     unit: .day,
                                                     value: 0,
                                                     deltaSeconds: 0))
    }
}
