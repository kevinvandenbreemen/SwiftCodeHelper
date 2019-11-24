import Cacao

class CacaoDriver {

    private(set) var drawingViewController: DrawingViewController
    
    init(drawingViewController: DrawingViewController) {
        self.drawingViewController = drawingViewController
    }

    func startup() {
        var options = CacaoOptions()
        options.windowName = "Software System Model Display"

        UIApplicationMain(delegate: CacaoAppDelegate.init(drawingViewController: drawingViewController), options: options)
    }

}