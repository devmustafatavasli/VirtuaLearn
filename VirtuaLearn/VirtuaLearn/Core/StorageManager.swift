import Foundation

/// Handles storing and retrieving user-generated `.usdz` models in the App's Documents directory.
final class StorageManager {
    static let shared = StorageManager()
    
    // Using a private initializer to enforce Singleton pattern
    private init() {}
    
    /// Returns the URL pointing to the user's Documents directory
    var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    /// Moves a newly generated .usdz file from a temporary location to the Documents directory.
    /// - Parameters:
    ///   - tempUrl: The URL where ObjectCaptureSession temporarily saved the output.
    ///   - fileName: The desired filename (without extension). Should be unique (e.g., UUID string).
    /// - Returns: The relative path (filename + extension) to store in SwiftData.
    func saveGeneratedModel(from tempUrl: URL, fileName: String) throws -> String {
        let finalFileName = "\(fileName).usdz"
        let destinationUrl = documentsDirectory.appendingPathComponent(finalFileName)
        
        // Remove if file already exists with same name (though UUIDs prevent this)
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            try FileManager.default.removeItem(at: destinationUrl)
        }
        
        // Move the file
        try FileManager.default.moveItem(at: tempUrl, to: destinationUrl)
        
        // Exclude the file from iCloud backup to save user quota
        var resourceValues = URLResourceValues()
        resourceValues.isExcludedFromBackup = true
        var fileUrlToUpdate = destinationUrl
        try fileUrlToUpdate.setResourceValues(resourceValues)
        
        return finalFileName
    }
    
    /// Returns the absolute URL for a given custom relative path string
    func getModelURL(for relativePath: String) -> URL {
        return documentsDirectory.appendingPathComponent(relativePath)
    }
    
    /// Deletes a custom model from the Documents directory
    func deleteCustomModel(at relativePath: String) {
        let fileUrl = getModelURL(for: relativePath)
        
        do {
            if FileManager.default.fileExists(atPath: fileUrl.path) {
                try FileManager.default.removeItem(at: fileUrl)
                print("Successfully deleted custom `.usdz` model at \(relativePath)")
            } else {
                print("Model file not found at \(relativePath), nothing to delete.")
            }
        } catch {
            print("Failed to delete custom model at \(relativePath): \(error)")
        }
    }
}
