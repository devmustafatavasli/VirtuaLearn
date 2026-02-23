import Foundation
import RealityKit
import SwiftUI
import os

@Observable
@MainActor
final class ObjectCaptureProcessModel {
    enum State {
        case notStarted
        case preparing
        case capturing
        case processing
        case success(savedFilePath: String)
        case failed(error: String)
        case notSupported
    }
    
    var currentState: State = .notStarted
    
    #if os(iOS) && !targetEnvironment(simulator)
    var session: ObjectCaptureSession?
    #endif
    
    private let storageManager = StorageManager.shared
    
    init() {
        checkHardwareSupport()
    }
    
    private func checkHardwareSupport() {
        #if os(iOS) && !targetEnvironment(simulator)
        if !ObjectCaptureSession.isSupported {
            currentState = .notSupported
        }
        #else
        // Simulator cannot run ObjectCaptureSession
        currentState = .notSupported
        #endif
    }
    
    func startCaptureSession() {
        #if os(iOS) && !targetEnvironment(simulator)
        guard ObjectCaptureSession.isSupported else { return }
        
        let newSession = ObjectCaptureSession()
        
        // Define where the raw capture data (images/depth) should go temporarily
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try? FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        
        var configuration = ObjectCaptureSession.Configuration()
        configuration.checkpointDirectory = tempDir.appendingPathComponent("Checkpoints")
        
        session = newSession
        currentState = .preparing // The user is reading instructions
        
        // We do not start the session until the user taps "Ready" in the UI
        #endif
    }
    
    func startCamera() {
        #if os(iOS) && !targetEnvironment(simulator)
        guard let session = session, case .preparing = currentState else { return }
        
        // Define directory to store capture images
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try? FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        
        session.start(imagesDirectory: tempDir)
        currentState = .capturing
        #endif
    }
    
    func finishCaptureAndProcess() {
        #if os(iOS) && !targetEnvironment(simulator)
        guard let session = session else { return }
        
        session.finish()
        currentState = .processing
        
        Task {
            // Actual photogrammetry processing happens here using PhotogrammetrySession
            // For a complete app, this involves tracking the file output and passing to StorageManager
            // Due to the complexity of PhotogrammetrySession, this is abstracted for MVP.
            // When processing finishes successfully:
            
            // simulate processing delay for now
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            
            // In a real implementation we would get the URL from PhotogrammetrySession
            // let tempUsdzUrl = ...
            // let savedFileName = try storageManager.saveGeneratedModel(from: tempUsdzUrl, fileName: UUID().uuidString)
            
            // For safety and compilation we transition to a failed state explaining the simulated missing piece
            self.currentState = .failed(error: "Photogrammetry processing requires local implementation of `PhotogrammetrySession` flow based on capturing images.")
        }
        #endif
    }
    
    func cleanup() {
        #if os(iOS) && !targetEnvironment(simulator)
        session?.cancel()
        session = nil
        #endif
        currentState = .notStarted
    }
}
