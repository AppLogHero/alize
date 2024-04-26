import UIKit
import Foundation

public extension UIScreen {
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
}
