import AST

/// Prints out details about a file to the console
public class ConsoleDocumentingVisitor: ASTVisitor {

    public init(){}

    public func visit(_ classDeclaration: ClassDeclaration) throws -> Bool {

        let members = classDeclaration.members
        var memberString = "members:\n======================\n"

        members.forEach{ member in 
            switch member {
            case let .declaration(declaration):
                memberString += "\(type(of: declaration))\n"
            case let .compilerControl(compilerControlStatement):
                memberString += "Compiler Control: \(compilerControlStatement)\n"
            default:
                break
            }
        }

        print("Class Decl:  \(classDeclaration.name), members:  \(memberString)")
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