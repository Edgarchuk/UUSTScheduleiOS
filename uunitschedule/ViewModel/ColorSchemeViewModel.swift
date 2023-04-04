
import Combine
import SwiftUI
import Foundation

class ColorSchemeViewModel: ObservableObject {
    
    private var colorInt: Int {
        get {
            switch colorScheme {
            case .none:
                return 0
            case .light:
                return 1
            case .dark:
                return 2
            }
        }
        
        set(value) {
            switch value {
            case 1:
                colorScheme = .light
            case 2:
                colorScheme = .dark
            default:
                colorScheme = nil
            }
        }
    }
    
    @Published var colorScheme: ColorScheme? = nil {
        didSet {
            UserDefaults.standard.set(colorInt, forKey: "colorScheme")
        }
    }
    
    init() {
        colorInt = UserDefaults.standard.integer(forKey: "colorScheme")
    }
}
