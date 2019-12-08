import SwiftCodeHelper
import XCTest

class UMLInterfaceRepresentationTests: XCTestCase {

    func testRepresentEmptyInterface() {
        //  Arrange
        let clz = Interface(name: "I_Test")
        let interfaceCoder = InterfaceCoder(for: clz)

        //  Act
        let generatedCode = interfaceCoder.generateCode()

        //  Assert
        let expectedCode = 
"""
interface I_Test {

}
"""

        XCTAssertEqual(generatedCode, expectedCode)
    }

    static var allTests = [
        ("Generate code for a single interface", testRepresentEmptyInterface)
    ]

}