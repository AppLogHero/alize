import PhotosUI
import SwiftUI
import Foundation
import Bases
import PhotosDomain

struct Photo {
    let id: UUID = UUID()
    let image: Image
}

enum ViewState<DataModel> {
    case success(_ model: DataModel)
    case failure
    case loading
    case none
}

final class GalleryViewModel: ViewModel {
    typealias DataModel = GalleryDataModel
    
    private let useCases: GalleryUseCasesProtocol
    
    @Published var viewState: ViewState<GalleryDataModel> = .none
    
    init(useCases: GalleryUseCasesProtocol) {
        self.useCases = useCases
        self.useCases.delegate = self
    }
    
    func updateState(_ state: ViewState<GalleryDataModel>) {
        DispatchQueue.main.async {
            self.viewState = state
        }
    }
 
    func requestLibraryAccess() {
        self.updateState(.loading)
        self.useCases.requestLibraryAccess { status in
            switch status {
            case .denied:
                self.updateState(.failure)
            case .authoried:
                self.useCases.getPhotoDataModels()
            }
        }
    }
    
    func requestAsset(for model: PhotoDataModel, size: CGSize, completion: @escaping(Image?) -> Void) async {
        await self.useCases.requestAsset(for: model, size: size, completion: completion)
    }
    
    func refresh(with data: Result<GalleryDataModel, Error>) {
        switch data {
        case .success(let model):
            self.updateState(.success(model))
        case .failure(let failure):
            self.updateState(.failure)
        }
    }
}
