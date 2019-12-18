@testable import SwiftSoftwareSystemModel
@testable import SwiftCodeHelper
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

    func testRepresentClassWithImplementation() {
        //  Arrange
        var clz = Class(name: "TestClass")
        let ifc = Interface(name: "Interface")
        clz.implements(interface: ifc)

        let classCoder = ClassCoder(for: clz)

        //  Act
        let generatedCode = classCoder.generateCode()

        //  Assert
        let expectedCode = 
"""
/**
 * @extends Interface
 */
class TestClass {

}
"""

        print("generated:\n\(generatedCode)\nexp:\n\(expectedCode)")

        XCTAssertEqual(generatedCode, expectedCode)
    }

    static var allTests = [
        ("Generate code for a single class", testRepresentEmptyClass),
        ("Generate code for a class that implements an interface", testRepresentClassWithImplementation),
    ]

}