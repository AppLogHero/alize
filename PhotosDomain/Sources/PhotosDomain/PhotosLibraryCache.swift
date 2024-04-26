import Photos
import SwiftUI

public actor PhotosLibraryCache {
    private let cachingManager: PHCachingImageManager
    private var assetContentMode: PHImageContentMode
    private var cachedAssetIdentifiers: [String: Bool]
    
    private var cachedAssetCount: Int {
        return cachedAssetIdentifiers.keys.count
    }
    
    private lazy var requestOptions: PHImageRequestOptions = {
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        return options
    }()
    
    public init(cachingManager: PHCachingImageManager = PHCachingImageManager(),
         assetContentMode: PHImageContentMode = .aspectFit,
         cachedAssetIdentifiers: [String : Bool] = [:]) {
        self.cachingManager = cachingManager
        self.assetContentMode = assetContentMode
        self.cachedAssetIdentifiers = cachedAssetIdentifiers
        /// Maybe it could be great to allow it
        self.cachingManager.allowsCachingHighQualityImages = false
    }
    
    public func start(for assests: [PhotoDataModel], size: CGSize) {
        let assets = assests.compactMap({ $0.asset })
        assets.forEach { cachedAssetIdentifiers[$0.localIdentifier] = true }
        cachingManager.startCachingImages(
            for: assets,
            targetSize: size,
            contentMode: assetContentMode,
            options: requestOptions
        )
    }
    
    public func stop(for assets: [PhotoDataModel], size: CGSize) {
        let assets = assets.compactMap({ $0.asset })
        assets.forEach { cachedAssetIdentifiers.removeValue(forKey: $0.localIdentifier) }
        cachingManager.stopCachingImages(
            for: assets,
            targetSize: size,
            contentMode: assetContentMode,
            options: requestOptions
        )
    }
    
    public func stop() {
        cachingManager.stopCachingImagesForAllAssets()
    }
    
    public func requestAsset(for asset: PhotoDataModel,
                             size: CGSize,
                             completion: @escaping ((image: Image?, isLowerQuality: Bool)?) -> Void) -> PHImageRequestID? {
        guard let asset = asset.asset else {
            completion(nil)
            return nil
        }
        return cachingManager.requestImage(
            for: asset,
            targetSize: size,
            contentMode: assetContentMode,
            options: requestOptions,
            resultHandler: { asset, info in
                if let error = info?[PHImageErrorKey] as? Error {
                    print("CachedImageManager requestImage error: \(error.localizedDescription)")
                    completion(nil)
                } else if let cancelled = (info?[PHImageCancelledKey] as? NSNumber)?.boolValue, cancelled {
                    print("CachedImageManager request canceled")
                    completion(nil)
                } else if let asset = asset {
                    let isLowerQualityImage = (info?[PHImageResultIsDegradedKey] as? NSNumber)?.boolValue ?? false
                    let result = (image: Image(uiImage: asset), isLowerQuality: isLowerQualityImage)
                    completion(result)
                } else {
                    completion(nil)
                }
            }
        )
    }
    
    public func cancelRequest(for requestID: PHImageRequestID) {
        cachingManager.cancelImageRequest(requestID)
    }
}

public extension PhotosLibraryCache {
    enum PhotosLibraryCacheError: LocalizedError {
        case error(Error)
        case cancelled
        case failed
    }
}
