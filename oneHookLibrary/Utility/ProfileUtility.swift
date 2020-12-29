import os.log
import UIKit

public class ProfileUtility {
    #if DEBUG
    public static var ongoing = [String: CFTimeInterval]()
    #endif

    public static func logStart(name: String) {
        #if DEBUG
        ongoing[name] = CACurrentMediaTime()
        #endif
    }

    public static func logEnd(name: String) {
        #if DEBUG
        if let startTime = ongoing[name] {
            let duration = Int((CACurrentMediaTime() - startTime) * 1000)
            print("Profile \(name) took \(duration)")
        }
        #endif
    }
}
