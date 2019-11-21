import AST
import Parser
import Source

public class SourceFileParser {

    private let visitor: ASTVisitor?

    private let filePath: String

    public init(filePath: String, visitor: ASTVisitor? = nil){
        self.filePath = filePath
        self.visitor = visitor
    }

    public func parse() {
        do {
            let sourceFile = try SourceReader.read(at: filePath)
            let parser = Parser(source: sourceFile)
            let topLevelDecl = try parser.parse()

            //  Now do the parsing
            if let visitor = self.visitor {
                print("Traversing the code with visitor of type \(type(of: visitor))")
                try visitor.traverse(topLevelDecl)
            } else {
                for statement in topLevelDecl.statements {
                    print("Statement:  \(statement)")
                }
            }
        } catch let error {
            print("Error:  \(error)")
        }


    }

}