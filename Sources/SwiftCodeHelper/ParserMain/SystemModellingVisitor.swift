import AST

class SystemModellingVisitor: ASTVisitor {

    private let builder: SystemModelBuilder
    
    init(builder: SystemModelBuilder = SystemModelBuilder() ) {
        self.builder = builder
    }
    
    

}