import AST

/// Prints out details about a file to the console
public class ConsoleDocumentingVisitor: ASTVisitor {

    public init(){}

    public func visit(_ classDeclaration: ClassDeclaration) throws -> Bool {
        print("Class Decl:  \(classDeclaration.name)")
        return true
    }

    public func visit(_ initializer: InitializerDeclaration) throws -> Bool {
        let debugString = 
        """
        Init:
        modifier:\t\(initializer.modifiers)
        args:\t\(initializer.parameterList)
        """
        print(debugString)
        return true
    }
}