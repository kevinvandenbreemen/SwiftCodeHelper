import SwiftCodeHelper
import XCTest

class UMLClassRepresentationTests: XCTestCase {

    func testRepresentEmptyClass() {
        //  Arrange
        let clz = Class(name: "TestClass")
        let classCoder = ClassCoder(for: clz)

        //  Act
        let generatedCode = classCoder.generateCode()

        //  Assert
        let expectedCode = 
"""
class TestClass {

}
"""

        XCTAssertEqual(generatedCode, expectedCode)
    }

    static var allTests = [
        ("Generate code for a single class", testRepresentEmptyClass)
    ]

}