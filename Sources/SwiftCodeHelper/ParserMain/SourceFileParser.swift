import AST
import Parser
import Source

public class SourceFileParser {

    private let filePath: String

    public init(filePath: String){
        self.filePath = filePath
    }

    public func parse() {
        do {
            let sourceFile = try SourceReader.read(at: filePath)
            let parser = Parser(source: sourceFile)
            let topLevelDecl = try parser.parse()

            //  Now do the parsing
            for statement in topLevelDecl.statements {
                print("Statement:  \(statement)")
            }
        } catch let error {
            print("Error:  \(error)")
        }


    }

}