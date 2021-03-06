import SwiftSoftwareSystemModel

public class ConsoleDebuggingModelDisplay: ModelDisplay {

    public init(){}

    public func display(model: SystemModel) -> Bool {

        var output: String = "Software System Model\n===========================\n"

        model.classes.forEach { clz in

        
            let topAndBottom = String( "+\(String(repeating: "-", count: (clz.name.count + 4)) )+" )
            let midLevel = "|  \(clz.name)  |"

            output += ("\(topAndBottom)\n\(midLevel)\n\(topAndBottom)\n\n")

        }

        output += "\n==============================="

        print(output)

        return true

    }

}