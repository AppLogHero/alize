import PhotosUI
import SwiftUI
import Foundation
import Bases
import PhotosDomain

enum GalleryError: Error {
    case emptyData
}

struct GalleryDataModel {
    let assets: [PhotoDataModel]
}

protocol GalleryUseCasesProtocol where Self: UseCases<GalleryDataModel, GalleryRoutes, GalleryViewModel> {
    func getPhotoDataModels()
    func requestLibraryAccess(_ completion: @escaping(PhotoLibraryStatus) -> Void)
    func requestAsset(for dataModel: PhotoDataModel, size: CGSize, completion: @escaping(Image?) -> Void) async
}

final class GalleryUseCases: UseCases<GalleryDataModel, GalleryRoutes, GalleryViewModel> {
    private unowned let photosLibraryService: PhotosLibraryService
    
    init(photosLibraryService: PhotosLibraryService, router: Router<GalleryRoutes>) {
        self.photosLibraryService = photosLibraryService
        super.init(router: router)
    }
}

extension GalleryUseCases: GalleryUseCasesProtocol {
    func requestLibraryAccess(_ completion: @escaping(PhotoLibraryStatus) -> Void) {
        self.photosLibraryService.requestAccess { status in
            #warning("need to check status documentation")
            switch status {
            case .notDetermined:
                print("not determined")
            case .restricted, .denied:
                completion(.denied)
            case .authorized, .limited:
                completion(.authoried)
            default:
                print("unknow case \(status)")
            }
        }
    }
    
    func getPhotoDataModels() {
        let dataModels = self.photosLibraryService.generatePhotoDataModels()
        self.delegate?.refresh(with: .success(GalleryDataModel(assets: dataModels)))
    }
    
    func requestAsset(for dataModel: PhotoDataModel, size: CGSize, completion: @escaping(Image?) -> Void) async {
        await self.photosLibraryService.requestAsset(for: dataModel, size: size) { result in
            print(result?.isLowerQuality)
            completion(result?.image)
        }
    }
}
