import CommandLineKit

/// Configuration for executing the program.  This class handles determining exactly what is being parsed
public class CommandLineArgumentsConfiguration: RunConfiguration {

    public private(set) var path: String

    public init() throws {

        //  Set up flags etc
        let flags = Flags()
        let filePathArg = flags.string("f", "path", description: "Path containing source files to be parsed")

        //  Try parsing the command from the user
        if flags.parsingFailure() != nil || !filePathArg.wasSet {
            print("USAGE:  \(flags.usageDescription())")
            throw Errors.InvalidUserConfiguration(message: "One or more missing parameters")
        }

        guard let filePathVal = filePathArg.value, !filePathVal.isEmpty else {
            //  Should not happen...
            print("That's weird!  File path arg was set but has no value!")
            throw Errors.UnknownErrorOccurred(message: "Unexpected:  Could not get file path from provided arguments!")
        }

        self.path = filePathVal

    }

}