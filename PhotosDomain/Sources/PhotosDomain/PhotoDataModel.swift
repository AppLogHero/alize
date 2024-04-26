import Photos
import SwiftUI

public struct PhotoDataModel: Identifiable {
    public var id: String
    public var index: Int?
    public var asset: PHAsset?
    public var image: Image?
    
    public var isFavorite: Bool {
        return asset?.isFavorite ?? false
    }
    
    public var mediaType: PHAssetMediaType {
        return asset?.mediaType ?? .unknown
    }
    
    public init(index: Int?, asset: PHAsset) {
        self.id = asset.localIdentifier
        self.index = index
        self.asset = asset
    }
    
    public init(id: String) {
        self.id = id
        let fetchedAssets = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil)
        self.asset = fetchedAssets.firstObject
    }
}
