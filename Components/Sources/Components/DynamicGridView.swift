import SwiftUI

public struct DynamicGridView<Data: RandomAccessCollection, ID: Identifiable, Content: View>: View where ID == Data.Element {
    
    @State private var totalZoom = 0
    @State private var currentZoom = 0.0
    @State private var shapesSize: CGFloat = Components.Grid.GridShape.smallSize
    
    @State private var dynamicColumns: [GridItem] = [
        Components.Grid.smallSizeGridItem,
        Components.Grid.smallSizeGridItem,
        Components.Grid.smallSizeGridItem,
        Components.Grid.smallSizeGridItem,
        Components.Grid.smallSizeGridItem
    ]
    
    private let data: Data
    private let content: (Data.Element, CGFloat) -> Content
    
    public init(_ data: Data, content: @escaping(Data.Element, CGFloat) -> Content) {
        self.data = data
        self.content = content
    }
    
    public var body: some View {
        ScrollView(
            content: {
                LazyVGrid(
                    columns: dynamicColumns,
                    spacing: 0,
                    content: {
                        ForEach(data) { element in
                            content(element, shapesSize)
                                .foregroundStyle(.red)
                                .frame(width: shapesSize, height: shapesSize)
                                .border(.black, width: 1)
                        }
                    }
                )
            }
        )
        .gesture(
            MagnifyGesture()
                .onChanged { value in
                    currentZoom = value.magnification - 1
                }
                .onEnded { value in
                    if currentZoom > 0 && totalZoom < 2 {
                        totalZoom += 1
                    } else {
                        totalZoom = totalZoom > 0 ? totalZoom - 1 : 0
                    }
                }
        )
        .accessibilityZoomAction { action in
            switch action.direction {
            case .zoomIn:
                totalZoom += 1
                print(totalZoom)
            case .zoomOut:
                totalZoom -= 1
                print(totalZoom)
            }
        }
        .onChange(of: totalZoom) {
            withAnimation {
                if totalZoom == 2 {
                    self.shapesSize = Components.Grid.GridShape.fullSize
                    self.dynamicColumns = [
                        Components.Grid.fullSizeGridItem,
                        Components.Grid.fullSizeGridItem,
                        Components.Grid.fullSizeGridItem
                    ]
                }
                if totalZoom == 1 {
                    self.shapesSize = Components.Grid.GridShape.mediumSize
                    self.dynamicColumns = [
                        Components.Grid.mediumSizeGridItem,
                        Components.Grid.mediumSizeGridItem,
                        Components.Grid.mediumSizeGridItem,
                        Components.Grid.mediumSizeGridItem
                    ]
                }
                if totalZoom == 0 {
                    self.shapesSize = Components.Grid.GridShape.smallSize
                    self.dynamicColumns = [
                        Components.Grid.smallSizeGridItem,
                        Components.Grid.smallSizeGridItem,
                        Components.Grid.smallSizeGridItem,
                        Components.Grid.smallSizeGridItem,
                        Components.Grid.smallSizeGridItem,
                    ]
                }
            }
        }
    }
}
