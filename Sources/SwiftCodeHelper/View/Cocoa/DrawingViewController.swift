import Cacao
import Foundation
import Logging

/// Displays a vector drawing
class DrawingViewController: UIViewController, UIScrollViewDelegate {

    private var logger: Logger

    var titleView: UILabel!
    var contentScroller: UIScrollView!
    var sidePanelContainer: UIView!
    var diagram: DiagramView!
    private let model: SystemModel
    
    init(model: SystemModel) {

        self.model = model

        self.logger = Logger.init(label: "Cocao.DrawingViewController")
        self.logger.logLevel = .debug

        super.init()
        
    }
    

    override func loadView() {

        self.view = UIView(frame: CGRect.init(x: 0, y: 0, width: 800, height: 600))
        view.backgroundColor = .white

        let textView = setupTitle()
        self.titleView = textView
        view.addSubview(textView)

        let scrollerTemp = setupScrollingContent()
        view.addSubview(scrollerTemp)

        let sidePanel = setupSidePane()
        view.addSubview(sidePanel)

        self.diagram = DiagramView.init(frame: self.view.frame, model: model)
        self.contentScroller.addSubview(diagram)

        logger.debug("View Load Complete")
    }

    private func setupTitle() -> UILabel {
        let txtView = UILabel.init()
        txtView.font = UIFont.systemFont(ofSize: CGFloat(36))
        txtView.textAlignment = .center
        txtView.text = "Diagramming Module"
        return txtView
    }

    private func setupScrollingContent() -> UIScrollView {
        contentScroller = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: 800, height: 600))
        contentScroller.delegate = self

        return contentScroller
    }

    private func setupSidePane() -> UIView {
        self.sidePanelContainer = UIView.init()
        sidePanelContainer.backgroundColor = UIColor.init(red: 0.8, green: 0.8, blue: 0.8)
        return sidePanelContainer
    }

    override func viewWillLayoutSubviews() {

        let titleAreaMultiplier = CGFloat(0.1)
        let sideAreaMultiplier = CGFloat(0.2)

        let currentWindowArea = view.frame

        let titleArea = CGRect.init(x: 0, y: 0, width: currentWindowArea.width, height: currentWindowArea.height * titleAreaMultiplier)
        self.titleView.frame = titleArea
        
        let sideArea = CGRect.init(x: 0, y: currentWindowArea.height * titleAreaMultiplier, width: currentWindowArea.width * sideAreaMultiplier, 
            height: (currentWindowArea.height - (currentWindowArea.height * titleAreaMultiplier)))
        self.sidePanelContainer.frame = sideArea

        let scrollingArea = CGRect.init(x: (currentWindowArea.width * sideAreaMultiplier), y: currentWindowArea.height * titleAreaMultiplier, 
            width: currentWindowArea.width * (1 - sideAreaMultiplier), height: (currentWindowArea.height - (currentWindowArea.height * titleAreaMultiplier)) )
        self.contentScroller.frame = scrollingArea

        self.contentScroller.contentSize = self.diagram.intrinsicContentSize
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("Scroll")
    }

}