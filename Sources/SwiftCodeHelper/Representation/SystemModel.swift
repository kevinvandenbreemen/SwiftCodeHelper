class SystemModel {

    private var classes: [Class]
    
    init() {
        self.classes = []
    }
    
    func addClass(clz: Class) {
        self.classes.append(clz)
    }

}