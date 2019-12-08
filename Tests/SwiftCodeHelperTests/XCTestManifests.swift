import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(FontTests.allTests),
        testCase(UMLGraphCodeBuilderTests.allTests),
        testCase(UMLClassRepresentationTests.allTests),
    ]
}
#endif
