import SwiftSoftwareSystemModel
import Logging

public class ClassCoder {

    let clz: Class
    private var logger: Logger 
    
    public init(for clz: Class) {
        self.clz = clz
        self.logger = Logger.init(label: "ClassCoder")
    }
    
    public func generateCode() -> String {

        logger.debug("Class:  [\(clz.name)]\n======================================")

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
                properties += "\(property.type.name) \(property.name);\n"
            })
        }

        let propertiesForDisplay = clz.propertiesForDisplay.filter({prop in 
            return clz.properties.first(where: {p in 
                return p.name == prop.name
            }) == nil
        })
        logger.debug("Including properties for display as follows:\n\(propertiesForDisplay)")
        propertiesForDisplay.forEach({forDisplay in 

            var typeName = forDisplay.type
            if let additionalDetails = forDisplay.additionalDetails {
                if additionalDetails.tuple {
                    typeName = "Tuple"
                }
            }            

            properties += "\(typeName) \(forDisplay.name);\n"
        })

        return 
"""
\(implementation)
class \(clz.name) {
    \(properties)
}
"""
    }
}