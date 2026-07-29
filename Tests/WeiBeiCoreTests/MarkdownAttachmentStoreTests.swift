import Foundation
import XCTest
@testable import WeiBeiCore

final class MarkdownAttachmentStoreTests: XCTestCase {
    /**
     * 验证 `.tif` 图片保留原扩展名并使用 TIFF MIME。
     */
    func testTIFFExtensionAndMIMEArePreserved() throws {
        let fileManager = FileManager.default
        let root = fileManager.temporaryDirectory
            .appendingPathComponent("weibei-tiff-attachment-\(UUID().uuidString)", isDirectory: true)
        defer { try? fileManager.removeItem(at: root) }
        let noteDirectory = root.appendingPathComponent("Notes", isDirectory: true)
        let attachmentDirectory = noteDirectory.appendingPathComponent(".weibei-assets", isDirectory: true)
        try fileManager.createDirectory(at: noteDirectory, withIntermediateDirectories: true)

        let attachment = try MarkdownAttachmentStore.save(
            data: Data([0x49, 0x49, 0x2A, 0x00]),
            originalName: "scan.TIF",
            mime: "image/tiff",
            attachmentDirectory: attachmentDirectory,
            markdownBaseURLString: noteDirectory.absoluteString
        )

        XCTAssertTrue(MarkdownAttachmentStore.isSupportedImageExtension("TIF"))
        XCTAssertEqual(MarkdownAttachmentStore.mimeType(forFileExtension: "tif"), "image/tiff")
        XCTAssertEqual(attachment.src, ".weibei-assets/scan.tif")
        XCTAssertTrue(fileManager.fileExists(atPath: attachmentDirectory.appendingPathComponent("scan.tif").path))
    }
}
