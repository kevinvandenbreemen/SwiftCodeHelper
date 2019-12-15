import XCTest
@testable import SwiftCodeHelper

class SystemModelBuilderTests: XCTestCase {

    func testDetectsInterfaceImplementation() {
        let builder = SystemModelBuilder()
        
        let ifc = Interface.init(name: "Interface")
        let clz = Class.init(name: "Implementor")

        builder.addInterface(interface: ifc)
        builder.addClass(clz: clz)

        builder.addImplements(type: "Implementor", implements: "Interface")

        let firstClass = builder.systemModel.classes[0]
        
        let interfaces = firstClass.interfaces
        guard interfaces.count == 1 else {
            XCTFail("Type \(firstClass.name) should have a single implemented interface")
            return
        }

        XCTAssertEqual(interfaces[0].name, ifc.name)
    }

    func testRegisteresInterfaceImplementationBeforeInterfaceEncountered() {
        let builder = SystemModelBuilder()
        
        let ifc = Interface.init(name: "Interface")
        let clz = Class.init(name: "Implementor")
        
        builder.addClass(clz: clz)
        builder.addImplements(type: "Implementor", implements: "Interface")
        builder.addInterface(interface: ifc)

        let firstClass = builder.systemModel.classes[0]
        
        let interfaces = firstClass.interfaces
        guard interfaces.count == 1 else {
            XCTFail("Type \(firstClass.name) should have a single implemented interface")
            return
        }

        XCTAssertEqual(interfaces[0].name, ifc.name)
    }


    static var allTests = [
        ("Adds existing interface to a class", testDetectsInterfaceImplementation),
        ("Adds interface to a class even when interface not yet encountered at time of implements decl", testRegisteresInterfaceImplementationBeforeInterfaceEncountered),

    ]

}