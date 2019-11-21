import SwiftCodeHelper

let consoleDoc = ConsoleDocumentingVisitor()

let parser = SourceFileParser(filePath: "./testResources/swift/test.swift", visitor: consoleDoc)
print("Built a parser!")

parser.parse()



