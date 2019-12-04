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

}