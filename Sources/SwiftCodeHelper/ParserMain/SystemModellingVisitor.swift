import AST
import Logging
import SwiftSoftwareSystemModel

class VisitorContext {

    var inMethodDeclarations: Bool = false
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
        logger.logLevel = .debug
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

    public func visit(_ extensionDeclaration: ExtensionDeclaration) throws -> Bool {

        if let inheritanceClause = extensionDeclaration.typeInheritanceClause {
            let className = extensionDeclaration.type.description
            logger.debug("Extension of \(extensionDeclaration.type): \(inheritanceClause.typeInheritanceList)")
            inheritanceClause.typeInheritanceList.forEach({ identifier in 
                builder.addImplements(type: className, implements: identifier.description)
            })
        }

        
        return true
    }
    
    public func visit(_ constant: ConstantDeclaration) throws -> Bool {

        if let currentType = context.currentType, !context.inMethodDeclarations, let patternInitializer = constant.initializerList.first(where: {initializer in 
            initializer.pattern is IdentifierPattern
        }), let typeAnnotation = (patternInitializer.pattern as! IdentifierPattern).typeAnnotation {

            let propertyName = (patternInitializer.pattern as! IdentifierPattern).identifier.description
            let propertyType = typeAnnotation.type.description

            logger.debug("[\(currentType)] add const '\(propertyName)' of type '\(propertyType)'")

            builder.addProperty(ofType: propertyType, to: currentType, named: propertyName)

        }

        return true
    }

    public func visit(_ declaration: VariableDeclaration) throws -> Bool {

        let body: VariableDeclaration.Body = declaration.body
        switch body {
        case .codeBlock(let identifier, let typeAnnotation, let codeBlock):
            logger.debug("Code block - ident=\(identifier), typeAnno=\(typeAnnotation)")
        case .getterSetterBlock(let identifier, let typeAnnotation, let codeBlock):
            logger.debug("getter setter block - ident=\(identifier), typeAnno=\(typeAnnotation)")
        case .getterSetterKeywordBlock(let identifier, let typeAnnotation, let getterSetterKeywordBlock):
            logger.debug("Code block - ident=\(identifier), typeAnno=\(typeAnnotation)")
        case .initializerList(let patternInitializer):
            logger.debug("Initializer list with \(patternInitializer)")
            logger.debug("Pattern = \(patternInitializer[0].pattern) - a \(type(of: patternInitializer[0].pattern))")
            logger.debug("Location = \(patternInitializer[0].pattern.sourceLocation.identifier)")
            if let targetClass = context.currentType, let identifierPat = patternInitializer[0].pattern as? IdentifierPattern, let typeAnnotation = identifierPat.typeAnnotation {
             
                var optionalWrappedType: String? = nil
                if let optionalType = typeAnnotation.type as? OptionalType {
                    logger.debug("Optional - wrapped is :  \(optionalType.wrappedType)")
                    optionalWrappedType = optionalType.wrappedType.description
                }

                let propertyName = identifierPat.identifier.description
                let propertyType = optionalWrappedType == nil ? typeAnnotation.type.description : optionalWrappedType!

                logger.info("Adding property '\(propertyName): \(propertyType)' to class \(targetClass)")

                builder.addProperty(ofType: propertyType, to: targetClass, named: propertyName)

            }
        case .willSetDidSetBlock(let identifier, let annotation, let expression, let willSetDidSetBlock):
            logger.debug("Will set did set block - identifier=\(identifier)")
        }

        return true

    }

}