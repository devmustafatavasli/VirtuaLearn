import Foundation
import SwiftUI
import ARKit

@Observable
final class AppState {
    var isARSupported: Bool = false
    var selectedCategory: SubjectCategory? = nil
    var isLanguageEnglish: Bool = false // Toggle for Turkish/English content
    
    init() {
        checkDeviceCapabilities()
    }
    
    private func checkDeviceCapabilities() {
        self.isARSupported = ARWorldTrackingConfiguration.isSupported
    }
}
