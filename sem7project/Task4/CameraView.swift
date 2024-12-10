//
//  CameraView.swift
//  sem7project
//
//  Created by Mary Grishchenko on 25.09.2024.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewControllerRepresentable {
    @Binding var capturedPhoto: UIImage?
    @Binding var photoTrigger: Bool
    @Binding var photoTaken: Bool
    
    // Coordinator class to manage AVCaptureSession
    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        var parent: CameraPreview
        var captureSession: AVCaptureSession
        var photoOutput: AVCapturePhotoOutput
        
        init(parent: CameraPreview) {
            self.parent = parent
            self.captureSession = AVCaptureSession()
            self.photoOutput = AVCapturePhotoOutput()
            super.init()
            setupCaptureSession()
        }
        
        func setupCaptureSession() {
            // Start AVCaptureSession
            captureSession.beginConfiguration()
            
            // Set video input device (camera)
            if let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
               let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
               captureSession.canAddInput(videoDeviceInput) {
                captureSession.addInput(videoDeviceInput)
            }
            
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }
            
            // Set the preview layer
            captureSession.commitConfiguration()
        }
        
        func startSession() {
            captureSession.startRunning()
        }
        
        func stopSession() {
            captureSession.stopRunning()
        }
        
        func takePhoto() {
            let settings = AVCapturePhotoSettings()
            photoOutput.capturePhoto(with: settings, delegate: self)
        }
        
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            guard let imageData = photo.fileDataRepresentation(),
                  let image = UIImage(data: imageData) else { return }
            
            DispatchQueue.main.async {
                self.parent.capturedPhoto = image
                self.parent.photoTaken = true
            }
        }
    }

    // Create the coordinator
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    // Make the UIViewController (which will have the camera preview)
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        
        // Create and configure preview layer
        let previewLayer = AVCaptureVideoPreviewLayer(session: context.coordinator.captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = viewController.view.frame
        
        // Add previewLayer to the view
        viewController.view.layer.addSublayer(previewLayer)
        
        // Start the camera session
        context.coordinator.startSession()
        
        return viewController
    }

    // Update UIViewController
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if photoTrigger {
            context.coordinator.takePhoto()
            photoTrigger = false
        }
    }
    
    // Cleanup when the view is removed
    static func dismantleUIViewController(_ uiViewController: UIViewController, coordinator: Coordinator) {
        coordinator.stopSession()
    }
}

/*
struct CameraView: View {
    var body: some View {
        @Binding var capturedPhoto: UIImage?
        @Binding var photoTaken: Bool
        CameraView()
    }
}
 */
/*
 struct CameraView_Previews: PreviewProvider {
 static var previews: some View {
 TestView()
 }
 }
 */
