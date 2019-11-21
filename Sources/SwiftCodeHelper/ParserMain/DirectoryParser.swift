

public class DirectoryParser {
    private var config: RunConfiguration
    
    public init() throws {
        guard let conf = RunConfiguration() else {
            throw Errors.InvalidUserConfiguration(message: "Invalid configuration specified by user")
        }

        self.config = conf
    }
    
}