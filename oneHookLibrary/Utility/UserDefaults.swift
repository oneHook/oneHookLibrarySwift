import Foundation

extension UserDefaults {
    public func save<T: Encodable>(_ object: T, forKey key: String) {
        if let encoded = try? JSONEncoder().encode(object) {
            self.set(encoded, forKey: key)
        }
    }

    public func retrieve<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = self.data(forKey: key) {
            return try? JSONDecoder().decode(T.self, from: data)
        }
        return nil
    }
}
