public class InterfaceCoder {

    private let interface: Interface

    public init(for interface: Interface) {
        self.interface = interface
    }

    public func generateCode() -> String {
        return
"""
interface \(interface.name) {

}
"""
    }

}