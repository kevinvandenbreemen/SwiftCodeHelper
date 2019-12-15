public class SystemModelBuilder {

    public let systemModel: SystemModel

    /// Name of a class to list of its implemented interfaces
    private var classNameToImplementedInterfaceNames: [String: [String]]
    
    public init(systemModel model: SystemModel = SystemModel()) {
        self.systemModel = model
        self.classNameToImplementedInterfaceNames = [:]
    }
    
    func addClass(clz: Class) {
        self.systemModel.addClass(clz: clz)
    }

    func addInterface(interface: Interface) {
        self.systemModel.addInterface(interface: interface)

        for (className, interfaces) in classNameToImplementedInterfaceNames {
            if let _ = interfaces.first(where: {ifc in 
                ifc == interface.name
            }), var alreadyExistingClass = systemModel.classes.first(where: {clz in 
                clz.name == className
            }) {
                alreadyExistingClass.implements(interface: interface)
                systemModel.classes.removeAll(where: {clz in 
                    clz.name == alreadyExistingClass.name
                })
                systemModel.addClass(clz: alreadyExistingClass)
            }
        }

    }

    /// Alert this builder that the class with the given name implements the given interface
    func addImplements(
        type className: String,     //  Note that I use a string here, not a Class as we want to be able to handle extension declarations in separate files
        implements interfaceName: String) {

        let existingClassOpt = systemModel.classes.first(where: {clz in 
            clz.name == className
        })
        let existingInterfaceOpt = systemModel.interfaces.first(where: {ifc in
            ifc.name == interfaceName
        })

        //  Two scenarios:
        //  1:  The class and the interface are already registered
        if var existingClass = existingClassOpt {

            //  Two sub-scenarios: 
            //  1:  Interface already registered
            if let existingInterface = existingInterfaceOpt {
                
                existingClass.implements(interface: existingInterface)
                systemModel.classes.removeAll(where: {clz in 
                    clz.name == existingClass.name
                })
                systemModel.addClass(clz: existingClass)

            }

            //  2:  Interface not yet registered
            else {
                if classNameToImplementedInterfaceNames[existingClass.name] == nil {
                    classNameToImplementedInterfaceNames[existingClass.name] = []
                }
                classNameToImplementedInterfaceNames[existingClass.name]!.append(interfaceName)
            }

        }

    }

}