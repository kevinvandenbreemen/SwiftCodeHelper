import AST
import Logging
import SwiftSoftwareSystemModel

public class SystemModellingVisitor: ASTVisitor {

    private var logger: Logger

    private let builder: SystemModelBuilder
    
    public init(builder: SystemModelBuilder = SystemModelBuilder() ) {
        self.builder = builder
        
        self.logger = Logger.init(label: String(describing: SystemModellingVisitor.self))
        self.logger.logLevel = .debug
    }
    
    public func visit(_ classDeclaration: ClassDeclaration)  throws -> Bool {

        logger.debug("Class declaration:\n******************\n\(classDeclaration)")

        let className = String(describing: classDeclaration.name)
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
    

}