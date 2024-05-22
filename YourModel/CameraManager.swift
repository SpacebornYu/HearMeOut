import Foundation
import AVFoundation
import Vision

class CameraManager: NSObject, ObservableObject {
     let captureSession = AVCaptureSession()
    private var deviceInput: AVCaptureDeviceInput?
    private var videoOutput: AVCaptureVideoDataOutput?
    private let systemPreferredCamera = AVCaptureDevice.default(for: .video)
    private var sessionQueue = DispatchQueue(label: "video.preview.session")
    
    private var handPoseRequest = VNDetectHumanHandPoseRequest()
    private let handPoseClassifier: ASLHandClassifier
    
    @Published var handPrediction: String?
    @Published var predictionResult: String?
    @Published var errorMessage: String?
    
    private var isAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            
            var isAuthorized = status == .authorized
            
            if status == .notDetermined {
                isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }
            
            return isAuthorized
        }
    }
    
    private var addToPreviewStream: ((CGImage) -> Void)?
    
    lazy var previewStream: AsyncStream<CGImage> = {
        AsyncStream { continuation in
            addToPreviewStream = { cgImage in
                continuation.yield(cgImage)
            }
        }
    }()
    
    override init() {
        do {
            handPoseClassifier = try ASLHandClassifier(configuration: MLModelConfiguration())
            
            super.init()
            
            Task {
                await configureSession()
                await startSession()
            }
        } catch {
            fatalError("Failed to load MLModel")
        }
    }

    private func configureSession() async {
        guard await isAuthorized,
              let systemPreferredCamera,
              let deviceInput = try? AVCaptureDeviceInput(device: systemPreferredCamera)
        else { return }
        
        captureSession.beginConfiguration()
        
        defer {
            self.captureSession.commitConfiguration()
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)
        
        guard captureSession.canAddInput(deviceInput) else {
            print("Unable to add device input to capture session.")
            return
        }
        
        guard captureSession.canAddOutput(videoOutput) else {
            print("Unable to add video output to capture session.")
            return
        }
        
        captureSession.addInput(deviceInput)
        captureSession.addOutput(videoOutput)
    }
    
    private func startSession() async {
        guard await isAuthorized else { return }
        captureSession.startRunning()
    }
    
    private func buildInputAttribute(recognizedPoints: [VNHumanHandPoseObservation.JointName : VNRecognizedPoint]) -> MLMultiArray {
        let attributeArray = buildRow(recognizedPoint: recognizedPoints[.wrist]) +
        buildRow(recognizedPoint: recognizedPoints[.thumbCMC]) +
        buildRow(recognizedPoint: recognizedPoints[.thumbMP]) +
        buildRow(recognizedPoint: recognizedPoints[.thumbIP]) +
        buildRow(recognizedPoint: recognizedPoints[.thumbTip]) +
        buildRow(recognizedPoint: recognizedPoints[.indexMCP]) +
        buildRow(recognizedPoint: recognizedPoints[.indexPIP]) +
        buildRow(recognizedPoint: recognizedPoints[.indexDIP]) +
        buildRow(recognizedPoint: recognizedPoints[.indexTip]) +
        buildRow(recognizedPoint: recognizedPoints[.middleMCP]) +
        buildRow(recognizedPoint: recognizedPoints[.middlePIP]) +
        buildRow(recognizedPoint: recognizedPoints[.middleDIP]) +
        buildRow(recognizedPoint: recognizedPoints[.middleTip]) +
        buildRow(recognizedPoint: recognizedPoints[.ringMCP]) +
        buildRow(recognizedPoint: recognizedPoints[.ringPIP]) +
        buildRow(recognizedPoint: recognizedPoints[.ringDIP]) +
        buildRow(recognizedPoint: recognizedPoints[.ringTip]) +
        buildRow(recognizedPoint: recognizedPoints[.littleMCP]) +
        buildRow(recognizedPoint: recognizedPoints[.littlePIP]) +
        buildRow(recognizedPoint: recognizedPoints[.littleDIP]) +
        buildRow(recognizedPoint: recognizedPoints[.littleTip])
        
        let attributeBuffer = UnsafePointer(attributeArray)
        let mlArray = try! MLMultiArray(shape: [1, 3, 21], dataType: MLMultiArrayDataType.float)
        
        mlArray.dataPointer.initializeMemory(as: Float.self, from: attributeBuffer, count: attributeArray.count)
        
        return mlArray
    }
    
    private func buildRow(recognizedPoint: VNRecognizedPoint?) -> [Float] {
        if let recognizedPoint = recognizedPoint {
            return [Float(recognizedPoint.x), Float(recognizedPoint.y), Float(recognizedPoint.confidence)]
        } else {
            return [0.0, 0.0, 0.0]
        }
    }
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        let handPoseRequest = VNDetectHumanHandPoseRequest()
        handPoseRequest.maximumHandCount = 1
        handPoseRequest.revision = VNDetectHumanHandPoseRequestRevision1
        
        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, options: [:])
        do {
            try handler.perform([handPoseRequest])
        } catch {
            assertionFailure("Hand Pose Request failed: \(error)")
        }
        
        guard let handObservation = handPoseRequest.results?.first else {
            return
        }
        
        guard let keypointsMultiArray = try? handObservation.keypointsMultiArray()
        else { fatalError() }
        do {
            let handPosePrediction = try handPoseClassifier.prediction(poses: keypointsMultiArray)
            DispatchQueue.main.async{
                self.handPrediction = handPosePrediction.label
            }
        } catch {
            captureSession.stopRunning()
            print("Error")
        }
        
        guard let currentFrame = sampleBuffer.cgImage else {
            print("Can't translate to CGImage")
            return
        }
        addToPreviewStream?(currentFrame)
    }
}
