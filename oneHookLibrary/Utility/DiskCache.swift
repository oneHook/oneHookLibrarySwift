import UIKit

public struct DiskCache {

    /// - component: A file-path/file-name. i.e. "object.json" or "dir1/dir2/object.json"
    @discardableResult
    public static func save<T: Codable>(_ entity: T, to location: Location = .applicationSupport, as component: String) throws -> URL {
        guard let url = url(location: location, component: component) else {
            throw DiskCacheError.invalidUrl(location: location, component: component)
        }

        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
        let data = try JSONEncoder().encode(entity)
        try data.write(to: url)
        return url
    }

    @discardableResult
    public static func save(image: UIImage, to location: Location = .applicationSupport, as component: String) throws -> URL {
        guard let url = url(location: location, component: component) else {
            throw DiskCacheError.invalidUrl(location: location, component: component)
        }
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            throw DiskCacheError.invalidImage(location: location, component: component)
        }
        try data.write(to: url)
        return url
    }

    /// Returns nil if the file does not exist
    public static func retrieve<T: Codable>(_ component: String,
                                            from location: Location = .applicationSupport,
                                            as type: T.Type? = nil) throws -> T? {
        guard let url = url(location: location, component: component) else {
            throw DiskCacheError.invalidUrl(location: location, component: component)
        }

        guard FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }

        let data = try Data.init(contentsOf: url)
        return try JSONDecoder().decode(T.self, from: data)
    }

    public static func retrieveContents<T: Codable>(of component: String? = nil,
                                                    from location: Location = .applicationSupport,
                                                    as type: T.Type? = nil) throws -> [T] {
        var result = [T]()

        guard let url = url(location: location, component: component ?? "", isDirectory: true) else {
            throw DiskCacheError.invalidUrl(location: location, component: component ?? "")
        }

        guard FileManager.default.fileExists(atPath: url.path) else {
            return result
        }

        let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: nil)

        while let fileURL = enumerator?.nextObject() as? URL {
            let data = try Data.init(contentsOf: fileURL)
            if let decoded = try? JSONDecoder().decode(T.self, from: data) {
                result.append(decoded)
            }
        }

        return result
    }

    public static func remove(_ component: String, from location: Location = .applicationSupport) throws {
        guard let url = url(location: location, component: component) else {
            throw DiskCacheError.invalidUrl(location: location, component: component)
        }

        try FileManager.default.removeItem(at: url)
    }

    public static func remove(_ url: URL) throws {
        try FileManager.default.removeItem(at: url)
    }

    public static func removeContents(of path: String? = nil, from location: Location = .applicationSupport) throws {
        guard let url = url(location: location, component: path ?? "", isDirectory: true) else {
            throw DiskCacheError.invalidUrl(location: location, component: path ?? "")
        }

        let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: nil)

        while let fileURL = enumerator?.nextObject() as? URL {
            try FileManager.default.removeItem(at: fileURL)
        }
    }

    private static func url(location: Location, component: String, isDirectory: Bool = false) -> URL? {
        location.url?.appendingPathComponent(component, isDirectory: isDirectory)
    }
}

public extension DiskCache {
    enum DiskCacheError: Error {
        case invalidUrl(location: Location, component: String)
        case invalidImage(location: Location, component: String)
    }

    enum Location: CaseIterable {
        case documents
        case caches
        case applicationSupport
        case temporary

        var url: URL? {
            switch self {
            case .documents: return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            case .caches: return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
            case .applicationSupport: return FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            case .temporary:
                if #available(iOS 10.0, *) {
                    return FileManager.default.temporaryDirectory
                } else {
                    return URL(string: NSTemporaryDirectory())
                }
            }
        }
    }
}
