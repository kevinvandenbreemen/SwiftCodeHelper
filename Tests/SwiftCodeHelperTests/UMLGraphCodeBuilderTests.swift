import SwiftSoftwareSystemModel
import SwiftCodeHelper
import XCTest

class UMLGraphCodeBuilderTests: XCTestCase {

    func testGenerateSimpleClassDiagram() {

        //  Arrange
        let builder = SystemModelBuilderForTests()
        builder.addClass(named: "TestClass")
        builder.addClass(named: "OtherClass")

        let display = UMLGraphCodeBuilder()

        let model = builder.systemModel

        print("Code Generation Sanity Test\n\n==================\n")
        display.display(model: model)
        print("\n\n\n==================\n")

    }

    static var allTests = [
        ("Draws simple diagram with just a class", testGenerateSimpleClassDiagram)
    ]

}