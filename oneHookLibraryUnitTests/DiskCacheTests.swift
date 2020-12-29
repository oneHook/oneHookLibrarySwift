import XCTest
@testable import oneHookLibrary

// swiftlint:disable force_try
class DiskCacheTests: XCTestCase {
    struct A: Codable { // swiftlint:disable:this type_name
        let id: String
    }

    struct B: Codable { // swiftlint:disable:this type_name
        let name: String
    }

    func testSave() {
        DiskCache.Location.allCases.forEach {
            save(to: $0)
        }
    }

    func testOverwrite() {
        DiskCache.Location.allCases.forEach {
            overwrite(to: $0)
        }
    }

    func testSubdirectorySave() {
        DiskCache.Location.allCases.forEach {
            save(path: UUID().uuidString + "/", to: $0)
        }
    }

    func testSubdirectoryOverwrite() {
        DiskCache.Location.allCases.forEach {
            overwrite(path: UUID().uuidString + "/", to: $0)
        }
    }

    func testRetrieveContentsOf() {
        do {
            try DiskCache.Location.allCases.forEach {
                let path = UUID().uuidString + "/"
                save(path: path, to: $0)
                save(path: path, to: $0)
                save(path: path, to: $0)
                let name = UUID().uuidString
                try! DiskCache.save(B(name: name), to: $0, as: name)
                let contents = try DiskCache.retrieveContents(of: path, from: $0, as: A.self)
                XCTAssertEqual(contents.count, 3)
            }
            XCTAssertTrue(true)
        } catch {
            XCTFail(#function)
        }
    }

    func testRemove() {
        do {
            try DiskCache.Location.allCases.forEach {
                let filename = save(path: nil, to: $0)
                try DiskCache.remove(filename, from: $0)
            }
            XCTAssertTrue(true)
        } catch {
            XCTFail(#function)
        }
    }

    func testRemoveContentsOfRoot() {
        do {
            try DiskCache.Location.allCases.forEach {
                let url = $0.url!
                let startCount = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: []).count
                save(path: nil, to: $0)
                save(path: UUID().uuidString + "/", to: $0)
                let addCount = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: []).count
                XCTAssertEqual(startCount + 2, addCount)
                try DiskCache.removeContents(from: $0)
                let clearCount = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: []).count
                XCTAssertEqual(clearCount, 0)
            }
        } catch {
            XCTFail(#function)
        }
    }

    func testRemoveContentsOfSubdirectory() {
        do {
            try DiskCache.Location.allCases.forEach {
                let path = UUID().uuidString + "/"
                let url = $0.url!.appendingPathComponent(path, isDirectory: true)
                let startCount = (try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: []).count) ?? 0
                save(path: path, to: $0)
                save(path: path + UUID().uuidString + "/", to: $0)
                let addCount = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: []).count
                XCTAssertEqual(startCount + 2, addCount)
                try DiskCache.removeContents(of: path, from: $0)
                let clearCount = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: []).count
                XCTAssertEqual(clearCount, 0)
            }
        } catch {
            XCTFail(#function)
        }
    }

    @discardableResult
    private func save(path: String? = nil, to location: DiskCache.Location) -> String {
        let id = UUID().uuidString
        let filename = (path ?? "") + UUID().uuidString

        try! DiskCache.save(A(id: id), to: location, as: filename)
        let found: A = try! DiskCache.retrieve(filename, from: location)!

        XCTAssertEqual(found.id, id)

        return filename
    }

    private func overwrite(path: String? = nil, to location: DiskCache.Location) {
        let id1 = UUID().uuidString
        let id2 = UUID().uuidString
        let filename = (path ?? "") + UUID().uuidString

        try! DiskCache.save(A(id: id1), to: location, as: filename)
        try! DiskCache.save(A(id: id2), to: location, as: filename)
        let found: A = try! DiskCache.retrieve(filename, from: location)!

        XCTAssertEqual(found.id, id2)
    }
}
// swiftlint:enable force_try
