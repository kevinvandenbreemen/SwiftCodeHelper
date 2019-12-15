public class SystemModelBuilder {

    public let systemModel: SystemModel

    
    public init(systemModel model: SystemModel = SystemModel()) {
        self.systemModel = model
    }
    
    func addClass(clz: Class) {
        self.systemModel.addClass(clz: clz)
    }

    func addInterface(interface: Interface) {
        self.systemModel.addInterface(interface: interface)
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

        }

    }

}