import UIKit
import SwiftUI
import Combine

// MARK: - Builder
public protocol Builder {
    associatedtype Payload
    static func createModule(payLoad: Payload) -> UIViewController
}

// MARK: - Router
public enum NavigationType {
    case push
    case modal
}

public protocol Route {
    var destination: UIViewController { get }
    var navigationType: NavigationType { get }
}

public final class Router<R: Route>: ObservableObject {
    
    private weak var controller: UIViewController?
    private var cancellables = Set<AnyCancellable>()
    
    @Published private var selectedRoute: R?
    
    public init() {
        self.$selectedRoute.sink { [weak self] route in
            guard let self = self, let route = route else {
                return
            }
            switch route.navigationType {
            case .push:
                self.controller?.navigationController?.pushViewController(route.destination, animated: true)
            case .modal:
                self.controller?.present(route.destination, animated: true)
            }
        }
        .store(in: &cancellables)
    }
    
    deinit {
        self.cancellables.removeAll()
    }
    
    public func navigateTo(_ route: R) {
        self.selectedRoute = route
    }
}

// MARK: - UseCases
open class UseCases<DataModel, R: Route, Delegate: UseCasesDelegate> {
    
    private(set) var dataModel: DataModel?
    
    private let router: Router<R>
    
    public var delegate: Delegate?
    
    public init(router: Router<R>) {
        self.router = router
    }
    
    public func navigateTo(_ route: R) {
        self.router.navigateTo(route)
    }
}

public protocol UseCasesDelegate {
    associatedtype DataModel
    func refresh(with data: Result<DataModel, Error>)
}

// MARK: - ViewModel
public protocol ViewModel: ObservableObject, UseCasesDelegate {}

// MARK: - Controller
public class BaseNavigationController: UINavigationController {}

public class BaseController<Content: View>: UIHostingController<Content> {
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
    }
}

public extension UIHostingController {
    func embedInNavigationController() -> BaseNavigationController {
        return BaseNavigationController(rootViewController: self)
    }
}

