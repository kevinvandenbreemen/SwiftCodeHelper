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

    private func doParse(fileManager: FileManager, path: String) {
        do {
            logger.info("Loading contents of files in path '\(path)'....")
            let items = try fileManager.contentsOfDirectory(atPath: path)

            //  Step 2:  Iterate thru all the files

            var isDirectory: ObjCBool = false
            items.forEach{ file in 

                let path = "\(path)\(file)"

                if !fileManager.fileExists(atPath: path, isDirectory: &isDirectory) {
                    logger.error("Seems file at path \(path) does not exist!")
                    return
                }
                if isDirectory.boolValue {
                    doParse(fileManager: fileManager, path: "\(path)/")
                    return
                }

                logger.info("Parsing file \(path)")
                SourceFileParser(filePath: path, visitor: visitor).parse()

            }
        } catch let error {
            logger.critical("Failed to load contents of directory \(path) due to \n\(error)")
        }
    }

    public func parse() {

        //  Step 1:  Get all files
        let fileManager = FileManager.default

        doParse(fileManager: fileManager, path: config.path)
        
        
    }
    
}