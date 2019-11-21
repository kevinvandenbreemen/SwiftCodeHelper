import AST

/// Prints out details about a file to the console
public class ConsoleDocumentingVisitor: ASTVisitor {

    public init(){}

    func visit(classDeclaration: ClassDeclaration) throws -> Bool {
        print("Class Decl:  \(classDeclaration)")
        return true
    }
}