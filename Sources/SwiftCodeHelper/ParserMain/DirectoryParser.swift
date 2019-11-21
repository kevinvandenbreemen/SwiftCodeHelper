import AST

/// Parses all files in the directory specified by the user
/// 
public class DirectoryParser {
    private var config: RunConfiguration
    private let visitor: ASTVisitor
    
    public init(configuration: RunConfiguration, visitor: ASTVisitor) throws {
        self.config = configuration
        self.visitor = visitor
    }

    func parse() {

    }
    
}