import SwiftSoftwareSystemModel

public class ClassCoder {

    let clz: Class
    
    public init(for clz: Class) {
        self.clz = clz
    }
    
    public func generateCode() -> String {

        var implementation: String = 
        """
        /**
         * @opt inferreltype composed
        """
        if !clz.interfaces.isEmpty {
            
            clz.interfaces.forEach{ ifc in 
                implementation += "\n * @extends \(ifc.name)"
            }
            
        }
        implementation += "\n */"

        var properties = ""
        if !clz.properties.isEmpty {
            clz.properties.forEach({property in 
                properties += "\(property.type.name) \(property.name);"
            })
        }

        return 
"""
\(implementation)
class \(clz.name) {
    \(properties)
}
"""
    }
}