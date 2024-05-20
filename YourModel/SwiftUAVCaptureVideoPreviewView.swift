import UIKit
import SwiftUI
import AVFoundation
import Vision

class UIAVCaptureVideoPreviewView: UIView, AVCaptureVideoDataOutputSampleBufferDelegate {
    // Properties for AVCapture and Vision
    var recognitionInterval = 0
    var mlModel: VNCoreMLModel?
    var captureSession: AVCaptureSession!
    var resultLabel: UILabel!

    // Method to set the ML model
    func setModel() {
        do {
            mlModel = try VNCoreMLModel(for: MyHandPose().model) // Replace 'MyHandPose' with your actual model
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
    }

    // Method to set up the AVCapture session
    func setupSession() {
        captureSession = AVCaptureSession()
        captureSession.beginConfiguration()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else { return }
        guard captureSession.canAddInput(videoInput) else { return }
        captureSession.addInput(videoInput)
        
        // Output settings
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "VideoQueue"))
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        captureSession.commitConfiguration()
    }

    // Method to set up the preview layer and result label
    func setupPreview() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        previewLayer.frame = self.bounds
        previewLayer.videoGravity = .resizeAspectFill
        self.layer.addSublayer(previewLayer)
        
        resultLabel = UILabel()
        resultLabel.text = ""
        resultLabel.frame = CGRect(x: 30, y: UIScreen.main.bounds.height - 290, width: UIScreen.main.bounds.width - 60, height: 80)
        resultLabel.textColor = .black
        resultLabel.textAlignment = .center
        resultLabel.font = .boldSystemFont(ofSize: 20.0)
        resultLabel.backgroundColor = UIColor(white: 1, alpha: 0.7)
        self.addSubview(resultLabel)
        resultLabel.layer.cornerRadius = 25
        resultLabel.layer.masksToBounds = true

        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }

    // Method called for each frame captured by the camera
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if recognitionInterval < 20 {
            recognitionInterval += 1
            return
        }
        recognitionInterval = 0
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer), let model = mlModel else { return }

        let request = VNCoreMLRequest(model: model) { request, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let results = request.results as? [VNClassificationObservation] else {
                print("Error: Unable to get results")
                return
            }
            var displayText = ""
            for result in results.prefix(5) {
                displayText += "\(Int(result.confidence * 100))%" + result.identifier + "\n"
            }
            print(displayText)
            DispatchQueue.main.async {
                self.resultLabel.text = displayText
            }
        }
        do {
            guard let multiArray = self.arrayFromPixelBuffer(pixelBuffer) else {
                print("Error converting to multiarray")
                return
            }
            try perform(request, with: multiArray)
        } catch {
            print("Error performing request: \(error.localizedDescription)")
        }
    }

    // Converts CVPixelBuffer to MLMultiArray
    private func arrayFromPixelBuffer(_ pixelBuffer: CVPixelBuffer) -> MLMultiArray? {
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        guard let multiArray = try? MLMultiArray(shape: [1, 3, 21], dataType: .float32) else { return nil }

        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly) }

        guard let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer) else { return nil }
        let buffer = baseAddress.assumingMemoryBound(to: UInt8.self)

        for y in 0..<height {
            for x in 0..<width {
                let pixelIndex = y * width + x
                let offset = pixelIndex * 4 // Assuming BGRA
                let b = Float(buffer[offset]) / 255.0
                let g = Float(buffer[offset + 1]) / 255.0
                let r = Float(buffer[offset + 2]) / 255.0
                let index = NSNumber(value: pixelIndex)
                multiArray[[0, 0, index]] = NSNumber(value: r)
                multiArray[[0, 1, index]] = NSNumber(value: g)
                multiArray[[0, 2, index]] = NSNumber(value: b)
            }
        }
        return multiArray
    }

    // Perform method for the request with MLMultiArray
    private func perform(_ request: VNCoreMLRequest, with multiArray: MLMultiArray) throws {
        let handler = try VNCoreMLRequest(model: request.model)
        try VNImageRequestHandler(mlMultiArray: multiArray, options: [:]).perform([request])
    }
}

// SwiftUI wrapper for the custom UIView
struct SwiftUIAVCaptureVideoPreviewView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIAVCaptureVideoPreviewView {
        let view = UIAVCaptureVideoPreviewView()
        view.setModel()
        view.setupSession()
        view.setupPreview()
        return view
    }

    func updateUIView(_ uiView: UIAVCaptureVideoPreviewView, context: Context) { }
}
