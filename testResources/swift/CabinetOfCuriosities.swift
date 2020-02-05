/// Class for testing various types of property declarations.  From now on I'm going to 
/// put any new types of properties I want to test parsing of into this class
class CabinetOfCuriosities {

    var tupleWithCalculator: (calculator: CosmicCalculator, name: String)
    let tupleWithCalculatorConst: (calculator: CosmicCalculator, name: String)

    var computedString: String {
        get {
            return "ComputedString"
        }
    }

    var implicitlyUnwrapped: String!

    var conformsToMultipleProtocols: AProtocol & Driver
    var conformsToMultipleProtocolsOpt: (AProtocol & Driver)?
    var optionalTuple: (calculator: CosmicCalculator, name: String)?

    var someFunction: (Bool) -> Void
    var someFunctionOpt: ((Bool) -> Void)?
    let someFunctionReq: (Bool) -> Void

    var array: [Driver]
    let arrayCnst: [Driver]
    let arrayOptCnst: [Driver]?
    var arrayOpt: [Driver]?
    var arrayOfTuple: [(calculator: CosmicCalculator, name: String)] 
    var arrayOfTupleOpt: [(calculator: CosmicCalculator, name: String)]?
    let arrayOfTupleCnst: [(calculator: CosmicCalculator, name: String)]

}