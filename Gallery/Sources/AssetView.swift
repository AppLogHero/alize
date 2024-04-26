import SwiftUI
import PhotosDomain

struct AssetView: View {
    
    @State private var asset: Image = Image("photo.on.rectangle.angled")
    
    private let size: CGSize
    private let model: PhotoDataModel
    
    private unowned let viewModel: GalleryViewModel
    
    init(viewModel: GalleryViewModel, model: PhotoDataModel, size: CGSize) {
        self.size = size
        self.model = model
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            asset
                .resizable()
                .frame(width: size.width, height: size.height)
                .aspectRatio(contentMode: .fill)
        }
        .task {
            await viewModel.requestAsset(for: model, size: size) { image in
                if let image = image {
                    asset = image
                } else {
                    asset = Image("photo.on.rectangle.angled")
                }
            }
        }
    }
}
