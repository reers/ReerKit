//
//  Copyright © 2020 SwifterSwift
//  Copyright © 2022 reers.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#if canImport(Foundation)
import Foundation

public extension Reer where Base: FileManager {
    /// ReerKit: Read from a JSON file at a given path.
    ///
    /// - Parameters:
    ///   - path: JSON file path.
    ///   - readingOptions: JSONSerialization reading options.
    /// - Throws: Throws any errors thrown by Data creation or JSON serialization.
    /// - Returns: Optional dictionary.
    func jsonFromFile(
        atPath path: String,
        readingOptions: JSONSerialization.ReadingOptions = .allowFragments
    ) throws -> [String: Any]? {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let json = try JSONSerialization.jsonObject(with: data, options: readingOptions)

        return json as? [String: Any]
    }

    #if !os(Linux)
    /// ReerKit: Read from a JSON file with a given filename.
    ///
    /// - Parameters:
    ///   - filename: File to read.
    ///   - bundleClass: Bundle where the file is associated.
    ///   - readingOptions: JSONSerialization reading options.
    /// - Throws: Throws any errors thrown by Data creation or JSON serialization.
    /// - Returns: Optional dictionary.
    func jsonFromFile(
        withFilename filename: String,
        at bundleClass: AnyClass? = nil,
        readingOptions: JSONSerialization.ReadingOptions = .allowFragments
    ) throws -> [String: Any]? {
        // https://stackoverflow.com/questions/24410881/reading-in-a-json-file-using-swift

        // To handle cases that provided filename has an extension
        let name = filename.components(separatedBy: ".")[0]
        let bundle = bundleClass != nil ? Bundle(for: bundleClass!) : Bundle.main

        if let path = bundle.path(forResource: name, ofType: "json") {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let json = try JSONSerialization.jsonObject(with: data, options: readingOptions)

            return json as? [String: Any]
        }

        return nil
    }
    #endif

    /// ReerKit: Creates a unique directory for saving temporary files. The directory can be used to create multiple temporary files used for a common purpose.
    ///
    ///     let tempDirectory = try fileManager.createTemporaryDirectory()
    ///     let tempFile1URL = tempDirectory.appendingPathComponent(ProcessInfo().globallyUniqueString)
    ///     let tempFile2URL = tempDirectory.appendingPathComponent(ProcessInfo().globallyUniqueString)
    ///
    /// - Throws: An error if a temporary directory cannot be found or created.
    /// - Returns: A URL to a new directory for saving temporary files.
    func createTemporaryDirectory() throws -> URL {
        #if !os(Linux)
        let temporaryDirectoryURL: URL
        if #available(OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            temporaryDirectoryURL = base.temporaryDirectory
        } else {
            temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        }
        return try base.url(
            for: .itemReplacementDirectory,
            in: .userDomainMask,
            appropriateFor: temporaryDirectoryURL,
            create: true
        )
        #else
        let envs = ProcessInfo.processInfo.environment
        let env = envs["TMPDIR"] ?? envs["TEMP"] ?? envs["TMP"] ?? "/tmp"
        let dir = "/\(env)/file-temp.XXXXXX"
        var template = [UInt8](dir.utf8).map { Int8($0) } + [Int8(0)]
        guard mkdtemp(&template) != nil else { throw CocoaError.error(.featureUnsupported) }
        return URL(fileURLWithPath: String(cString: template))
        #endif
    }
}

#endif
