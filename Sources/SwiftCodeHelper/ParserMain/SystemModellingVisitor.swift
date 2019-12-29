import AST
import Logging
import SwiftSoftwareSystemModel

class VisitorContext {

    var currentType: String? = nil

}

public class SystemModellingVisitor: ASTVisitor {

    private let context: VisitorContext

    private var logger: Logger

    private let builder: SystemModelBuilder
    
    public init(builder: SystemModelBuilder = SystemModelBuilder() ) {
        self.builder = builder
        self.context = VisitorContext()
        
        self.logger = Logger.init(label: String(describing: SystemModellingVisitor.self))
        self.logger.logLevel = .debug
    }
    
    public func visit(_ classDeclaration: ClassDeclaration)  throws -> Bool {

        logger.debug("Class declaration:\n******************\n\(classDeclaration)")

        let className = String(describing: classDeclaration.name)
        context.currentType = className
        let clz = Class(name: className)
        builder.addClass(clz: clz)

        if let inheritanceClause = classDeclaration.typeInheritanceClause {
            logger.debug("\(className):  Handling inheritance clause '\(inheritanceClause)'")
            inheritanceClause.typeInheritanceList.forEach{ typeIdentifier in
                let interfaceName = typeIdentifier.textDescription
                logger.debug("adding '\(className) implements \(interfaceName)'")
                builder.addImplements(type: className, implements: interfaceName)
            }
        }

        logger.debug("******************")

        return true
    }

    public func visit(_ protocolDeclaration: ProtocolDeclaration) throws -> Bool {
        let interfaceName = String(describing: protocolDeclaration.name)
        let interface = Interface(name: interfaceName)
        builder.addInterface(interface: interface)
        return true
    }
    
    public func visit(_ declaration: VariableDeclaration) throws -> Bool {

        print("FIELD Declaration:  \(declaration.textDescription)")
        print("FIELD Declaration:  \(declaration.description)")
        print("FIELD Declaration:  \(declaration.modifiers)")
        print("FIELD DecBody:  \(type(of: declaration.body)) -- \(declaration.body.textDescription)")

        var sourceFileLocation = declaration.sourceLocation.identifier

        let body: VariableDeclaration.Body = declaration.body
        switch body {
        case .codeBlock(let identifier, let typeAnnotation, let codeBlock):
            print("Code block - ident=\(identifier), typeAnno=\(typeAnnotation)")
        case .getterSetterBlock(let identifier, let typeAnnotation, let codeBlock):
            print("getter setter block - ident=\(identifier), typeAnno=\(typeAnnotation)")
        case .getterSetterKeywordBlock(let identifier, let typeAnnotation, let getterSetterKeywordBlock):
            print("Code block - ident=\(identifier), typeAnno=\(typeAnnotation)")
        case .initializerList(let patternInitializer):
            print("Initializer list with \(patternInitializer)")
            print("Pattern = \(patternInitializer[0].pattern) - a \(type(of: patternInitializer[0].pattern))")
            print("Location = \(patternInitializer[0].pattern.sourceLocation.identifier)")
            if let targetClass = context.currentType, let identifierPat = patternInitializer[0].pattern as? IdentifierPattern, let typeAnnotation = identifierPat.typeAnnotation {

                let propertyName = identifierPat.identifier.description
                let propertyType = typeAnnotation.type.description
                logger.info("Adding property '\(propertyName): \(propertyType)' to class \(targetClass)")

                builder.addProperty(ofType: propertyType, to: targetClass, named: propertyName)

            }
        case .willSetDidSetBlock(let identifier, let annotation, let expression, let willSetDidSetBlock):
            print("Will set did set block - identifier=\(identifier)")
        }

        return true

    }

}