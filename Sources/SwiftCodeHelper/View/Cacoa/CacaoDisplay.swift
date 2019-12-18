import Cacao
import Logging
import Foundation
import SwiftSoftwareSystemModel

public class CacaoDisplay: ModelDisplay {

    private var logger: Logger
    
    public init() {
        self.logger = Logger.init(label: "Cocoa.CocoaDisplay")
        self.logger.logLevel = .debug
    }

    public func display(model: SystemModel) {
        logger.debug("Display updating model to \(model)")

        let viewController = DrawingViewController.init(model: model)
        var options = CacaoOptions()
        options.windowName = "Software System Model Display"

        logger.debug("Starting the app!")
        UIApplicationMain(delegate: CacaoAppDelegate.init(drawingViewController: viewController), options: options)
    }

}