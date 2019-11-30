import XCTest
@testable import SwiftCodeHelper

class FontTests: XCTestCase {

    func testCreatesCourierFont() {
        let font = FontHelper.font(for: .courier, size: 12.0)
        XCTAssertNotNil(font)
    }

    static var allTests = [
        ("Loads Courier Font", testCreatesCourierFont)
    ]

}