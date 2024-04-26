import SwiftUI
import Components

struct GalleryView: View {
    @ObservedObject private var viewModel: GalleryViewModel
    
    init(viewModel: GalleryViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        switch self.viewModel.viewState {
        case .success(let model):
            VStack {
                DynamicGridView(model.assets) { asset, size in
                    AssetView(
                        viewModel: viewModel,
                        model: asset,
                        size: CGSize(
                            width: size,
                            height: size
                        )
                    )
                }
            }
        case .failure:
            Text("failure")
        case .loading:
            Text("loading")
        case .none:
            Text("none")
                .onAppear {
                    viewModel.requestLibraryAccess()
                }
        }
    }
}
