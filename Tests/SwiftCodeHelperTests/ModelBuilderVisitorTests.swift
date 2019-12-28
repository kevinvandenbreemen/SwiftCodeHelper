import XCTest
@testable import SwiftCodeHelper
import SwiftSoftwareSystemModel

class ModelBuilderVisitorTests: XCTestCase {

    func testCanLoadAClassFromASwiftFile() {
        let builder = SystemModelBuilder()
        let visitor = SystemModellingVisitor(builder: builder)
        let parser = SourceFileParser(filePath: "./testResources/swift/test.swift", visitor: visitor)

        parser.parse()

        XCTAssertEqual(1, builder.systemModel.classes.count)

    }

    static var allTests = [
        ("Can load a class from a swift file", testCanLoadAClassFromASwiftFile)
    ]

}