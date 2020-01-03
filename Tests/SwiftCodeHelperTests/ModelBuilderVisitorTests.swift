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

    func testCanLoadFieldOfAClass() {
        let builder = SystemModelBuilder()
        let visitor = SystemModellingVisitor(builder: builder)
        let parser = SourceFileParser(filePath: "./testResources/swift/ClassWithOneField.swift", visitor: visitor)

        parser.parse()

        guard let clz = builder.systemModel.classes.first(where: { clz in 
            return clz.name == "ClassWithOneField"
        }) else {
            XCTFail("Could not get class")
            return
        }

        XCTAssertEqual(1, clz.properties.count)

    }

    func testCanPickUpAFieldThatIsAProtocol() {

        let builder = SystemModelBuilder()
        let visitor = SystemModellingVisitor(builder: builder)
        
        var parser = SourceFileParser(filePath: "./testResources/swift/ClassThatHasInstanceOfInterfaceImpl.swift", visitor: visitor)
        parser.parse()

        parser = SourceFileParser(filePath: "./testResources/swift/Driver.swift", visitor: visitor)
        parser.parse()

        guard let clz = builder.systemModel.classes.first(where: { clz in 
            return clz.name == "ClassThatHasInstanceOfInterfaceImpl"
        }) else {
            XCTFail("Could not get class")
            return
        }

        XCTAssertEqual(1, clz.properties.count)
        XCTAssertEqual(clz.properties[0].name, "driver")
        XCTAssertEqual(clz.properties[0].type.name, "Driver")

    }

    func testCanDetectExtensionSpecifyingThatClassImplementsProtocol() {
        let builder = SystemModelBuilder()
        let visitor = SystemModellingVisitor(builder: builder)
        
        var parser = SourceFileParser(filePath: "./testResources/swift/ClassWithOneField.swift", visitor: visitor)
        parser.parse()

        parser = SourceFileParser(filePath: "./testResources/swift/Driver.swift", visitor: visitor)
        parser.parse()

        parser = SourceFileParser(filePath: "./testResources/swift/SimpleClassExtension.swift", visitor: visitor)
        parser.parse()

        guard let clz = builder.systemModel.classes.first(where: { clz in 
            return clz.name == "ClassWithOneField"
        }) else {
            XCTFail("Could not get class")
            return
        }

        XCTAssertEqual(1, clz.interfaces.count)
        XCTAssertEqual("Driver", clz.interfaces[0].name)

    }

    func testRecognizesDifferentExtensionsForDifferentTypes() {
        let builder = SystemModelBuilder()
        let visitor = SystemModellingVisitor(builder: builder)
        
        var parser = SourceFileParser(filePath: "./testResources/swift/ClassWithOneField.swift", visitor: visitor)
        parser.parse()

        parser = SourceFileParser(filePath: "./testResources/swift/util/CosmicCalculator.swift", visitor: visitor)
        parser.parse()

        parser = SourceFileParser(filePath: "./testResources/swift/Driver.swift", visitor: visitor)
        parser.parse()

        parser = SourceFileParser(filePath: "./testResources/swift/SimpleClassExtension.swift", visitor: visitor)
        parser.parse()

        parser = SourceFileParser(filePath: "./testResources/swift/util/CosmicExtension.swift", visitor: visitor)
        parser.parse()

        guard let clz = builder.systemModel.classes.first(where: { clz in 
            return clz.name == "ClassWithOneField"
        }) else {
            XCTFail("Could not get class")
            return
        }

        XCTAssertEqual(1, clz.interfaces.count)
        XCTAssertEqual("Driver", clz.interfaces[0].name)

        guard let cosmic = builder.systemModel.classes.first(where: { clz in 
            return clz.name == "CosmicCalculator"
        }) else {
            XCTFail("Could not get class")
            return
        }

        XCTAssertEqual(1, cosmic.interfaces.count)
        XCTAssertEqual("Driver", cosmic.interfaces[0].name)
    }

    func testDetectsLetProperties() {
        let builder = SystemModelBuilder()
        let visitor = SystemModellingVisitor(builder: builder)
        let parser = SourceFileParser(filePath: "./testResources/swift/util/CosmicCalculator.swift", visitor: visitor)

        parser.parse()

        guard let clz = builder.systemModel.classes.first(where: { clz in 
            return clz.name == "CosmicCalculator"
        }) else {
            XCTFail("Could not get class")
            return
        }

        XCTAssertEqual(2, clz.propertiesForDisplay.count, "Should be 2 properties")

    }

    func testPropertyAcquiresOptionalFields() {
        let builder = SystemModelBuilder()
        let visitor = SystemModellingVisitor(builder: builder)
        let parser = SourceFileParser(filePath: "./testResources/swift/ClassWithOptionalField.swift", visitor: visitor)

        parser.parse()

        guard let clz = builder.systemModel.classes.first(where: { clz in 
            return clz.name == "ClassWithOptionalField"
        }) else {
            XCTFail("Could not get class")
            return
        }

        XCTAssertEqual(1, clz.propertiesForDisplay.count)
        let property = clz.propertiesForDisplay[0]

        XCTAssertEqual("name", property.name)
        XCTAssertEqual("String", property.type)
    }

    static var allTests = [
        ("Can load a class from a swift file", testCanLoadAClassFromASwiftFile),
        ("Can load a field on a class", testCanLoadFieldOfAClass),
        ("Can pick up protocol fields", testCanPickUpAFieldThatIsAProtocol),
        ("Can detect class extension for protocol", testCanDetectExtensionSpecifyingThatClassImplementsProtocol),
        ("Can properly differentiate between extensions", testRecognizesDifferentExtensionsForDifferentTypes),
        ("Can detect let constants declared as class properties", testDetectsLetProperties),
        ("Property identifies optional fields' types", testPropertyAcquiresOptionalFields),
    ]

}