import UIKit
import SwiftUI
import Foundation

public enum Components {
    enum Screen {
        static let width: CGFloat = UIScreen.main.bounds.width
    }
    
    enum Grid {
        static let fullSizeGridItem: GridItem = GridItem(.fixed(Screen.width / 3), spacing: 0)
        static let mediumSizeGridItem: GridItem = GridItem(.fixed(Screen.width / 4), spacing: 0)
        static let smallSizeGridItem: GridItem = GridItem(.fixed(Screen.width / 5), spacing: 0)
        
        enum GridShape {
            static let fullSize = (Screen.width / 3)
            static let mediumSize = (Screen.width / 4)
            static let smallSize = (Screen.width / 5)
        }
    }
}
