import AST

public class SystemModellingVisitor: ASTVisitor {

    private let builder: SystemModelBuilder
    
    public init(builder: SystemModelBuilder = SystemModelBuilder() ) {
        self.builder = builder
    }
    
    public func visit(_ classDeclaration: ClassDeclaration)  throws -> Bool {
        let className = String(describing: classDeclaration.name)
        let clz = Class(name: className)
        builder.addClass(clz: clz)
        return true
    }

    public func visit(_ protocolDeclaration: ProtocolDeclaration) throws -> Bool {
        let interfaceName = String(describing: protocolDeclaration.name)
        let interface = Interface(name: interfaceName)
        builder.addInterface(interface: interface)
        return true
    }
    

}