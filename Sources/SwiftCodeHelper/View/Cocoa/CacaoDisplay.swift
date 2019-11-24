import Cacao

public class CacaoDisplay: ModelDisplay {

    private lazy var driver: CacaoDriver = {
        let driver = CacaoDriver.init(drawingViewController: DrawingViewController())
        driver.startup()
        return driver
    }()
    
    public init() {
        
    }

    public func display(model: SystemModel) {
        self.driver.drawingViewController.updateModel(with: model)
    }

}