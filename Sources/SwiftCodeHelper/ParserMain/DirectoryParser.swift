import AST
import Foundation
import Logging

/// Parses all files in the directory specified by the user
/// 
public class DirectoryParser {
    private var config: RunConfiguration
    private let visitor: ASTVisitor
    private let logger = Logger(label: "DirectoryParser")
    
    public init(configuration: RunConfiguration, visitor: ASTVisitor) throws {
        self.config = configuration
        self.visitor = visitor
    }

    public func parse() {

        //  Step 1:  Get all files
        let fileManager = FileManager.default
        
        do {
            logger.info("Loading contents of '\(config.path)'....")
            let items = try fileManager.contentsOfDirectory(atPath: config.path)

            //  Step 2:  Iterate thru all the files

            var isDirectory: ObjCBool = false
            items.forEach{ file in 

                let path = "\(config.path)\(file)"

                fileManager.fileExists(atPath: path, isDirectory: &isDirectory)
                if isDirectory.boolValue {
                    print("TODO - recurse in \(path)")
                    return
                }

                logger.info("Parsing file \(path)")
                SourceFileParser(filePath: path, visitor: visitor).parse()

            }
        } catch let error {
            logger.critical("Failed to load contents of directory \(config.path) due to \n\(error)")
        }
    }
    
}