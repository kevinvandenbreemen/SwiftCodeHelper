import CommandLineKit

/// Configuration for executing the program.  This class handles determining exactly what is being parsed
class RunConfiguration {

    private(set) var path: String!

    init?() {

        //  Set up flags etc
        let flags = Flags()
        let filePathArg = flags.string("f", "path", description: "Path containing source files to be parsed")

        //  Try parsing the command from the user
        if flags.parsingFailure() != nil || !filePathArg.wasSet {
            print("USAGE:  \(flags.usageDescription())")
            return nil
        }

        guard let filePathVal = filePathArg.value, !filePathVal.isEmpty else {
            //  Should not happen...
            print("That's weird!  File path arg was set but has no value!")
            return nil
        }

        self.path = filePathVal

    }

}