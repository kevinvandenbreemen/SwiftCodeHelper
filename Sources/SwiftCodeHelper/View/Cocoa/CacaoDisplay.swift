import Cacao

public class CacaoDisplay: ModelDisplay {

    private lazy var driver: CacaoDriver = {
        let driver = CacaoDriver.init(drawingViewController: DrawingViewController())

        //  Fire up the UI
        driver.startup()
        return driver
    }()
    
    public init() {
        
    }

    public func display(model: SystemModel) {
        self.driver.update(with: model)
    }

}