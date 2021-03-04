import Foundation

public class FileUtility {

    public static func getOrCreatePrivateFileUrl(name: String) -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(name)
    }
    
    public static func getFileSize(url: URL) -> Int? {
        var fileSize: Int?
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: url.path)
            fileSize = attr[FileAttributeKey.size] as? Int
        } catch {

        }
        return fileSize
    }
}
