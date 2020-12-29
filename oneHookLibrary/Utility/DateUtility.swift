import Foundation

public extension Date {
    private var calendar: Calendar {
        Calendar.current
    }

    var startOfDay: Date {
        calendar.startOfDay(for: self)
    }

    var endOfDay: Date? {
        calendar.date(byAdding: DateComponents(day: 1, second: -1), to: startOfDay)
    }

    var startOfYear: Date? {
        calendar.date(from: calendar.dateComponents([.year], from: self))
    }

    var startOfWeek: Date? {
        guard let dateFromComponents = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else {
            return nil
        }
        return calendar.date(byAdding: .day, value: 1, to: dateFromComponents)
    }

    var endOfWeek: Date? {
        guard let dateFromComponents = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else {
            return nil
        }
        return calendar.date(byAdding: .day, value: 7, to: dateFromComponents)
    }

    var startOfMonth: Date? {
        calendar.date(from: calendar.dateComponents([.year, .month], from: self))
    }

    var endOfMonth: Date? {
        calendar.date(byAdding: DateComponents(month: 1, day: -1), to: self)
    }

    var dayOfMonth: Int? {
        calendar.dateComponents([.year, .month, .day], from: self).day
    }

    func add(hours: Int) -> Date? {
        calendar.date(byAdding: DateComponents(hour: hours), to: self)
    }

    func add(days: Int) -> Date? {
        calendar.date(byAdding: DateComponents(day: days), to: self)
    }

    func add(weeks: Int) -> Date? {
        calendar.date(byAdding: DateComponents(day: weeks * 7), to: self)
    }

    func add(months: Int) -> Date? {
        calendar.date(byAdding: DateComponents(month: months), to: self)
    }

    func isSameMonth(_ date: Date) -> Bool {
        startOfMonth == date.startOfMonth
    }

    func isSameDay(_ date: Date) -> Bool {
        startOfDay == date.startOfDay
    }

    var dateOnly: Date? {
        calendar.date(from: calendar.dateComponents([.year, .month, .day], from: self))
    }

    func keepingTime(changeToDate date: Date) -> Date? {
        let timeComponents = calendar.dateComponents([.hour, .minute, .second, .nanosecond], from: self)
        let dateComponents = calendar.dateComponents([.day, .month, .year], from: date)

        guard
            let hour = timeComponents.hour,
            let minute = timeComponents.minute,
            let second = timeComponents.second,
            let nanosecond = timeComponents.nanosecond,
            let day = dateComponents.day,
            let month = dateComponents.month,
            let year = dateComponents.year else {
                return nil
        }

        let mergedComponents = DateComponents(
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second,
            nanosecond: nanosecond
        )

        return calendar.date(from: mergedComponents)
    }
}

public class DateUtils {

    /**
     * Number of seconds in difference to
     * determine whether we consider now.
     */
    public static let nowThreshold = 5.0

    public static let secondsInMinute: TimeInterval = 60
    public static let secondsInHour: TimeInterval = 60 * 60
    public static let secondsInDay: TimeInterval = 60 * 60 * 24
    public static let secondsInWeek: TimeInterval = 60 * 60 * 24 * 7
    public static let secondsInMonth: TimeInterval = 60 * 60 * 24 * 31
    public static let secondsInYear: TimeInterval = 60 * 60 * 24 * daysInYear

    public static let daysInWeek: Double = 7
    public static let daysInMonth: Double = 31
    public static let daysInYear: Double = 365.25

    public enum Direction {
        case before
        case after
    }

    public enum Unit: Int {
        case second = 0
        case minute = 1
        case hour = 2
        case day = 3
        case week = 4
        case month = 5
        case year = 6
    }

    public struct TimeDifference {
        public let direction: Direction
        public let unit: Unit
        public let value: Int
        public let deltaSeconds: TimeInterval
    }

    public static func timeRoundingFunction(_ time: Double) -> Double {
        floor(time)
    }

    public static func compare(from datetime1: Date,
                               with datetime2: Date,
                               timeZone: TimeZone = TimeZone(identifier: "UTC")!,
                               minUnit: Unit = .second,
                               maxUnit: Unit = .year,
                               secondCompareOnly: Bool = false) -> TimeDifference {
        /* We need offset the given datetimes with timezone offset from UTC */
        let timeZoneOffset: TimeInterval = TimeInterval(timeZone.secondsFromGMT())
        let normalizedDatetime1 = datetime1.addingTimeInterval(timeZoneOffset)
        let normalizedDatetime2 = datetime2.addingTimeInterval(timeZoneOffset)

        let time1 = normalizedDatetime1.timeIntervalSince1970
        let time2 = normalizedDatetime2.timeIntervalSince1970

        let deltaSeconds = time2 - time1
        let direction: Direction = deltaSeconds > 0 ? .after : .before
        var unit: Unit = .second
        var value: Int = 0

        let absDeltaSeconds = fabs(deltaSeconds)

        if (absDeltaSeconds < Self.secondsInMinute &&
            minUnit.rawValue <= Unit.second.rawValue) ||
            Unit.second.rawValue == maxUnit.rawValue {
            unit = .second
            value = Int(absDeltaSeconds)
            return TimeDifference(direction: direction, unit: unit, value: value, deltaSeconds: deltaSeconds)
        }

        if (absDeltaSeconds < Self.secondsInHour &&
            minUnit.rawValue <= Unit.minute.rawValue) ||
            Unit.minute.rawValue == maxUnit.rawValue {
            unit = .minute
            value = Int(timeRoundingFunction(absDeltaSeconds / Self.secondsInMinute))
            return TimeDifference(direction: direction, unit: unit, value: value, deltaSeconds: deltaSeconds)
        }

        if (absDeltaSeconds < Self.secondsInDay &&
            minUnit.rawValue <= Unit.hour.rawValue) ||
            Unit.hour.rawValue == maxUnit.rawValue {
            unit = .hour
            value = Int(timeRoundingFunction(absDeltaSeconds / Self.secondsInHour))
            return TimeDifference(direction: direction, unit: unit, value: value, deltaSeconds: deltaSeconds)
        }

        if !secondCompareOnly {
            return Self.compareReal(datetime1: normalizedDatetime1,
                                    datetime2: normalizedDatetime2,
                                    deltaSeconds: deltaSeconds,
                                    value: value,
                                    direction: direction,
                                    unit: unit,
                                    minUnit: minUnit,
                                    maxUnit: maxUnit)
        }

        if (absDeltaSeconds < Self.secondsInWeek &&
            minUnit.rawValue <= Unit.day.rawValue) ||
            Unit.day.rawValue == maxUnit.rawValue {
            unit = .day
            value = Int(timeRoundingFunction(absDeltaSeconds / Self.secondsInDay))
            return TimeDifference(direction: direction, unit: unit, value: value, deltaSeconds: deltaSeconds)
        }

        if (absDeltaSeconds < Self.secondsInMonth &&
            minUnit.rawValue <= Unit.week.rawValue) ||
            Unit.week.rawValue == maxUnit.rawValue {
            unit = .week
            value = Int(timeRoundingFunction(absDeltaSeconds / Self.secondsInWeek))
            return TimeDifference(direction: direction, unit: unit, value: value, deltaSeconds: deltaSeconds)
        }

        if (absDeltaSeconds < Self.secondsInYear &&
            minUnit.rawValue <= Unit.month.rawValue) ||
            Unit.month.rawValue == maxUnit.rawValue {
            unit = .month
            value = Int(timeRoundingFunction(absDeltaSeconds / Self.secondsInMonth))
            return TimeDifference(direction: direction, unit: unit, value: value, deltaSeconds: deltaSeconds)
        }

        unit = .year
        value = Int(timeRoundingFunction(absDeltaSeconds / Self.secondsInYear))
        return TimeDifference(direction: direction, unit: unit, value: value, deltaSeconds: deltaSeconds)
    }

    /**
     This will produce a more realistic result.
     */
    //swiftlint:disable:next function_parameter_count
    private static func compareReal(datetime1 normalizedDatetime1: Date,
                                    datetime2 normalizedDatetime2: Date,
                                    deltaSeconds: Double,
                                    value: Int,
                                    direction: Direction,
                                    unit: Unit,
                                    minUnit: Unit,
                                    maxUnit: Unit) -> TimeDifference {
        let calendar = Calendar.current
        var unit = unit
        var value = value

        /* for weeks/days, we ignore time */
        let day1 = calendar.ordinality(of: .day, in: .era, for: normalizedDatetime1) ?? 0
        let day2 = calendar.ordinality(of: .day, in: .era, for: normalizedDatetime2) ?? 0
        let absDeltaDays = Double(abs(day1 - day2))
        if (absDeltaDays < Self.daysInWeek &&
            minUnit.rawValue <= Unit.day.rawValue) ||
            Unit.day.rawValue == maxUnit.rawValue {
            unit = .day
            value = Int(absDeltaDays)
            return TimeDifference(direction: direction, unit: unit, value: value, deltaSeconds: deltaSeconds)
        }

        if (absDeltaDays < Self.daysInMonth &&
            minUnit.rawValue <= Unit.week.rawValue) ||
            Unit.week.rawValue == maxUnit.rawValue {
            unit = .week
            value = Int(timeRoundingFunction(absDeltaDays / Self.daysInWeek))
            return TimeDifference(direction: direction, unit: unit, value: value, deltaSeconds: deltaSeconds)
        }

        /* for months/years, we ignore days in month */

        if (absDeltaDays < Self.daysInYear &&
            minUnit.rawValue <= Unit.month.rawValue) ||
            Unit.month.rawValue == maxUnit.rawValue {
            unit = .month
            let month1 = calendar.ordinality(of: .month, in: .year, for: normalizedDatetime1) ?? 0
            let month2 = calendar.ordinality(of: .month, in: .year, for: normalizedDatetime2) ?? 0
            var monthDiff = month1 - month2
            if monthDiff < 0 {
                monthDiff += 13
            }
            let absDeltaMonths = Double(monthDiff)
            value = Int(absDeltaMonths)
            return TimeDifference(direction: direction, unit: unit, value: value, deltaSeconds: deltaSeconds)
        }

        let year1 = calendar.ordinality(of: .year, in: .era, for: normalizedDatetime1) ?? 0
        let year2 = calendar.ordinality(of: .year, in: .era, for: normalizedDatetime2) ?? 0
        unit = .year
        value = Int(abs(year1 - year2))
        return TimeDifference(direction: direction, unit: unit, value: value, deltaSeconds: deltaSeconds)
    }
}

