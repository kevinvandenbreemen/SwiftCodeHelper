import Cacao
import Foundation

enum Font: String {
    case courier
}

class FontHelper {
    private init(){}

    static func font(for name: Font, size: CGFloat) -> UIFont {
        return UIFont(name: name.rawValue, size: size)!
    }
}