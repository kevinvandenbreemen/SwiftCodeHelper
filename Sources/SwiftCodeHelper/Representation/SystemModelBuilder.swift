public class SystemModelBuilder {

    private let systemModel: SystemModel

    
    public init(systemModel model: SystemModel = SystemModel()) {
        self.systemModel = model
    }
    
    func addClass(clz: Class) {
        self.systemModel.addClass(clz: clz)
    }

}