import SwiftCodeHelper
import XCTest

class UMLGraphCodeBuilderTests: XCTestCase {

    func testGenerateSimpleClassDiagram() {

        //  Arrange
        let builder = SystemModelBuilderForTests()
        builder.addClass(named: "TestClass")

        let display = UMLGraphCodeBuilder()

        let model = builder.systemModel
        display.display(model: model)

    }

    static var allTests = [
        ("Draws simple diagram with just a class", testGenerateSimpleClassDiagram)
    ]

}