public class ClassCoder {

    let clz: Class
    
    public init(for clz: Class) {
        self.clz = clz
    }
    
    public func generateCode() -> String {

        var implementation: String? = nil
        if !clz.interfaces.isEmpty {
            implementation = "/**"
            clz.interfaces.forEach{ ifc in 
                implementation! += "\n * @extends \(ifc.name)"
            }
            implementation! += "\n */"
        }

        return 
"""
\(implementation ?? "")
class \(clz.name) {

}
"""
    }
}