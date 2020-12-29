import Foundation

public class FileUtility {
    
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
