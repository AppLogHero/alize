import UIKit
import SwiftUI
import Gallery
import PhotosDomain

struct RootViewRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = RootController
    
    func makeUIViewController(context: Context) -> RootController {
        return RootController()
    }
    
    func updateUIViewController(_ uiViewController: RootController, context: Context) {}
}

final class RootController: UITabBarController {
    
    // MARK: - Dependencies container
    private let photosLibraryService: PhotosLibraryService = PhotosLibraryService()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        // MARK: - TEMP
        self.viewControllers = [
            GalleryBuilder.createModule(
                payLoad: GalleryPayload(
                    photosLibrearyService: self.photosLibraryService
                )
            )
        ]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
