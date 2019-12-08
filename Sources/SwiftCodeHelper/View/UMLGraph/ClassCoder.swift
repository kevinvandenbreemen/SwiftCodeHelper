public class ClassCoder {

    let clz: Class
    
    public init(for clz: Class) {
        self.clz = clz
    }
    
    public func generateCode() -> String {
        return 
"""
class \(clz.name) {

}
"""
    }
}