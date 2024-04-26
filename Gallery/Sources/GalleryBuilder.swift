import UIKit
import Bases
import PhotosDomain

public struct GalleryPayload {
    unowned let photosLibrearyService: PhotosLibraryService
    
    public init(photosLibrearyService: PhotosLibraryService) {
        self.photosLibrearyService = photosLibrearyService
    }
}

public struct GalleryBuilder: Builder {
    public typealias Payload = GalleryPayload
    
    public static func createModule(payLoad: GalleryPayload) -> UIViewController {
        let router = Router<GalleryRoutes>()
        let useCases = GalleryUseCases(
            photosLibraryService: payLoad.photosLibrearyService,
            router: router
        )
        let viewModel = GalleryViewModel(useCases: useCases)
        let view = GalleryView(viewModel: viewModel)
        let controller = BaseController(rootView: view)
        return controller.embedInNavigationController()
    }
}
