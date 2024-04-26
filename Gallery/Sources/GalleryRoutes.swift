import UIKit
import Bases
import Foundation

enum GalleryRoutes: Route {
    case detail
    
    var destination: UIViewController {
        switch self {
        case .detail:
            return UIViewController()
        }
    }
    
    var navigationType: NavigationType {
        switch self {
        case .detail:
            return .push
        }
    }
}
