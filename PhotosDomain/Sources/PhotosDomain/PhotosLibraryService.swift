import SwiftUI
import PhotosUI

public final class PhotosLibraryService {
    #warning("Need to be unowed")
    private let photosLibraryCache: PhotosLibraryCache
    
    private var fetchedAssets: PHFetchResult<PHAsset>?
    
    public init() {
        self.photosLibraryCache = PhotosLibraryCache(assetContentMode: .aspectFill)
    }
    
    public func requestAccess(_ completion: @escaping(PHAuthorizationStatus) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: completion)
    }
    
    private func fetchAssets() {
        self.fetchedAssets = PHAsset.fetchAssets(with: .none)
    }
    
    public func generatePhotoDataModels() -> [PhotoDataModel] {
        self.fetchAssets()
        var dataModels: [PhotoDataModel] = []
        self.fetchedAssets?.enumerateObjects({ asset, index, _ in
            dataModels.append(PhotoDataModel(index: index, asset: asset))
        })
        return dataModels
    }
    
    @discardableResult
    public func requestAsset(for asset: PhotoDataModel,
                             size: CGSize,
                             completion: @escaping ((image: Image?, isLowerQuality: Bool)?) -> Void) async -> PHImageRequestID? {
        return await self.photosLibraryCache.requestAsset(
            for: asset,
            size: size,
            completion: completion
        )
    }
}
