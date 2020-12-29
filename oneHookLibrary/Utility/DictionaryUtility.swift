import Foundation

extension Dictionary {
    /// To print dictionaries nicely use `print(dictionary.toJSONString()!)`
    public func toJSONString(options: JSONSerialization.WritingOptions = .prettyPrinted) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: options) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }
}
