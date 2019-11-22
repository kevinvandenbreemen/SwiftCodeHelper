public class SystemModel {

    private var classes: [Class]
    
    public init() {
        self.classes = []
    }
    
    func addClass(clz: Class) {
        self.classes.append(clz)
    }

}