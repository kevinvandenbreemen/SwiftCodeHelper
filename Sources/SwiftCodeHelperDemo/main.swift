import SwiftCodeHelper

//  Grab the command line args
CommandLine.arguments.forEach{ arg in 
    print("Arg - \(type(of: arg)) = \(arg)")
}

let consoleDoc = ConsoleDocumentingVisitor()

let parser = SourceFileParser(filePath: "./testResources/swift/test.swift", visitor: consoleDoc)
print("Built a parser!")

parser.parse()


do {
    let configuratino: RunConfiguration = try CommandLineArgumentsConfiguration()
    let dirParser = try DirectoryParser(configuration: configuratino, visitor: consoleDoc)
    dirParser.parse()
} catch let error {
    print(error)
}