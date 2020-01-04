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

            logger.debug("let property type=\(typeAnnotation.type), name=\((patternInitializer.pattern as! IdentifierPattern).identifier.description)")

            var optionalWrappedType: String? = nil
            if let optionalType = typeAnnotation.type as? OptionalType {
                logger.debug("Optional - wrapped is :  \(optionalType.wrappedType)")
                optionalWrappedType = optionalType.wrappedType.description
            }

            let propertyName = (patternInitializer.pattern as! IdentifierPattern).identifier.description
            let propertyType = optionalWrappedType == nil ? typeAnnotation.type.description : optionalWrappedType!

            logger.debug("[\(currentType)] add const '\(propertyName)' of type '\(propertyType)'")

            builder.addProperty(ofType: propertyType, to: currentType, named: propertyName, additionalDetails: PropertyDetails(
                    optional: optionalWrappedType != nil,
                    tuple: typeAnnotation.type is TupleType,
                    function: typeAnnotation.type is FunctionType
                ))

        }

        return true
    }

    private func handleProtocolCompositionVariableDeclaration(identifierPat: IdentifierPattern, protocolComposition: ProtocolCompositionType, optional: Bool = false) {

        guard let targetClass = context.currentType else {
            logger.error("Attempt to add protocol composition field declaration when no current class")
            return
        }

        let propertyName = identifierPat.identifier.description
        let propertyType = "ProtocolComposition"


        builder.addProperty(ofType: propertyType, to: targetClass, named: propertyName, additionalDetails: PropertyDetails(
                    optional: false,
                    tuple: false
                ))

    }

    private func handleOptionalPropertyDeclaration(identifierPat: IdentifierPattern, optionalType: OptionalType) {
        logger.debug("Optional - wrapped type is :  \(type(of: optionalType.wrappedType))")
        

        if let tupleType = optionalType.wrappedType as? TupleType {
            if tupleType.elements.count == 1 {
                if let composition = tupleType.elements[0].type as? ProtocolCompositionType {
                    handleProtocolCompositionVariableDeclaration(identifierPat: identifierPat, protocolComposition: composition)
                    return
                }
                if let _ = tupleType.elements[0].type as? FunctionType {
                    builder.addProperty(ofType: tupleType.elements[0].type.description, to: context.currentType!, named: identifierPat.identifier.description, additionalDetails: PropertyDetails(
                        optional: true,
                        tuple: false,
                        function: true
                    ))

                    return
                }
            }

            else {
                builder.addProperty(ofType: "Tuple", to: context.currentType!, named: identifierPat.identifier.description, additionalDetails: PropertyDetails(
                    optional: true,
                    tuple: true
                ))
                return
            }

        }

        if let protocolComposition = optionalType.wrappedType as? ProtocolCompositionType {
            logger.debug("Treating \(identifierPat.identifier.description) as an optional composite protocol type")
            handleProtocolCompositionVariableDeclaration(identifierPat: identifierPat, protocolComposition: protocolComposition, optional: true)
            return
        }

        builder.addProperty(ofType: optionalType.wrappedType.description, to: context.currentType!, named: identifierPat.identifier.description, additionalDetails: PropertyDetails(
                    optional: true,
                    tuple: false
                ))
    }

    private func handleUnwrappedOptionalPropertyDeclaration(identifierPat: IdentifierPattern, unwrappedOptional: ImplicitlyUnwrappedOptionalType) {
        logger.debug("Impl Unwrapped Optional - wrapped is :  \(unwrappedOptional.wrappedType)")

        if let protocolComposition = unwrappedOptional.wrappedType as? ProtocolCompositionType {
            logger.debug("Treating \(identifierPat.identifier.description) as an unwrapped optional composite protocol type")
            handleProtocolCompositionVariableDeclaration(identifierPat: identifierPat, protocolComposition: protocolComposition)
            return
        }

        builder.addProperty(ofType: unwrappedOptional.wrappedType.description, to: context.currentType!, named: identifierPat.identifier.description, additionalDetails: PropertyDetails(
                    optional: true,
                    tuple: false
                ))
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
             
                logger.debug("var property type=\(type(of: typeAnnotation.type)), name=\(identifierPat.identifier.description)")

                if let protocolComposition = typeAnnotation.type as? ProtocolCompositionType {
                    handleProtocolCompositionVariableDeclaration(identifierPat: identifierPat, protocolComposition: protocolComposition)
                    return true
                }

                if let optionalType = typeAnnotation.type as? OptionalType {
                    handleOptionalPropertyDeclaration(identifierPat: identifierPat, optionalType: optionalType)
                    return true
                }

                if let unwrappedOptional = typeAnnotation.type as? ImplicitlyUnwrappedOptionalType {
                    handleUnwrappedOptionalPropertyDeclaration(identifierPat: identifierPat, unwrappedOptional: unwrappedOptional)
                    return true
                }

                logger.debug("tuple?  \(typeAnnotation.type is TupleType)")

                let propertyName = identifierPat.identifier.description
                let propertyType = typeAnnotation.type.description

                logger.info("Adding property '\(propertyName): \(propertyType)' to class \(targetClass)")

                builder.addProperty(ofType: propertyType, to: targetClass, named: propertyName, additionalDetails: PropertyDetails(
                    optional: false,
                    tuple: (typeAnnotation.type is TupleType),
                    function: typeAnnotation.type is FunctionType
                ))

            }
        case .willSetDidSetBlock(let identifier, let annotation, let expression, let willSetDidSetBlock):
            logger.debug("Will set did set block - identifier=\(identifier)")
        }

        return true

    }

}