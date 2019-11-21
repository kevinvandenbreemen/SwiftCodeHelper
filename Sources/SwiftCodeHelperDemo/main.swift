import SwiftCodeHelper

let parser = SourceFileParser(filePath: "./testResources/swift/test.swift")
print("Built a parser!")

parser.parse()
