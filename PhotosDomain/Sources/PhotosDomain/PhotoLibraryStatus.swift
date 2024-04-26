import Foundation

public enum PhotoLibraryStatus {
    case denied
    case authoried
    
    public var isAuthorized: Bool {
        switch self {
        case .denied:
            return false
        case .authoried:
            return true
        }
    }
}
