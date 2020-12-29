import Foundation

public protocol TrackingProtocol {

    func recordAppErrorLong(_ description: String,
                            file: String,
                            line: Int,
                            makeAssertionFailure: Bool)

    func recordServerError(name: String,
                           error: Error,
                           statusCode: Int)

    func recordDecodeError(name: String,
                           error: Error,
                           statusCode: Int)

    func recordGeneralError(message: String,
                            makeAssertionFailure: Bool)

    func recordUser(id: String, username: String, email: String, displayName: String)
}

public extension TrackingProtocol {
    func recordAppError(_ description: String,
                        file: String = #function,
                        line: Int = #line,
                        makeAssertionFailure: Bool = true) {
        recordAppErrorLong(description, file: file, line: line, makeAssertionFailure: makeAssertionFailure)
    }
}

public class Tracking {
    public static var shared: TrackingProtocol?
}
