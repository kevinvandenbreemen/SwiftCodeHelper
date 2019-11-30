import Cacao
import Logging

class CacaoAppDelegate: UIApplicationDelegate {
    
    var window: UIWindow?

    let logger = Logger(label: "AppDelegate")

    private let drawingViewController: DrawingViewController

    
    init(drawingViewController: DrawingViewController) {
        self.drawingViewController = drawingViewController
    }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)

        guard let window = window else {
            logger.error("Failed to create window")
            return false
        }

        window.rootViewController = drawingViewController
        window.makeKeyAndVisible()

        return true
    }

}
