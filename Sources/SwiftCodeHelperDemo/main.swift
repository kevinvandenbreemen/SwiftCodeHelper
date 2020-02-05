import SwiftSoftwareSystemModel
import SwiftCodeHelper
import Glibc

//  Grab the command line args
CommandLine.arguments.forEach{ arg in 
    print("Arg - \(type(of: arg)) = \(arg)")
}

let consoleDoc = ConsoleDocumentingVisitor()

let parser = SourceFileParser(filePath: "./testResources/swift/test.swift", visitor: consoleDoc)
print("Built a parser!")

parser.parse()


let modelBuilder = SystemModelBuilder()
let builder = SystemModellingVisitor(builder: modelBuilder)
do {
    let configuration: RunConfiguration = try CommandLineArgumentsConfiguration()
    let dirParser = try DirectoryParser(configuration: configuration, visitor: builder)
    dirParser.parse()
} catch let error {
    print(error)
    exit(1)
}

let display = UMLGraphCodeBuilder()
if !display.display(model:  modelBuilder.systemModel) {
    exit(1)
}