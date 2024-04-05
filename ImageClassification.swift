////
////  ImageClassification.swift
////  HearMeOut
////
////  Created by Yuri Mario Gianoli on 25/03/24.
////
//import Foundation
//import UIKit
//import CoreML
//import Vision
//
//// MARK: - Image Classification
//class ImageClassification: ObservableObject {
//    @Published var classificationLabel: String = "Add a photo."
//    
//    
//    /// - Tag: MLModelSetup
//    lazy var classificationRequest: VNCoreMLRequest = {
//        do {
//            let modelURL = Bundle.main.url(forResource: "YourModel", withExtension: "mlmodel")!
//            let model = try VNCoreMLModel(for: MyHandPoseClassifier1(contentsOf: modelURL).model)
//
//            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
//                self?.processClassifications(for: request, error: error)
//            })
//            request.imageCropAndScaleOption = .centerCrop
//            return request
//        } catch {
//            fatalError("Failed to load Vision ML model: \(error)")
//        }
//    }()
//    
//    /// - Tag: PerformRequests
//    func updateClassifications(for image: UIImage) {
//        classificationLabel = "Classifying..."
//        
//        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
//        
//        DispatchQueue.global(qos: .userInitiated).async {
//            let handler = VNImageRequestHandler(ciImage: ciImage)
//            do {
//                try handler.perform([self.classificationRequest])
//            } catch {
//                /*
//                 This handler catches general image processing errors. The `classificationRequest`'s
//                 completion handler `processClassifications(_:error:)` catches errors specific
//                 to processing that request.
//                 */
//                print("Failed to perform classification.\n\(error.localizedDescription)")
//            }
//        }
//    }
//    
//    /// Updates the UI with the results of the classification.
//    /// - Tag: ProcessClassifications
//    func processClassifications(for request: VNRequest, error: Error?) {
//        DispatchQueue.main.async {
//            guard let results = request.results else {
//                self.classificationLabel = "Unable to classify image.\n\(error!.localizedDescription)"
//                return
//            }
//            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
//            let classifications = results as! [VNClassificationObservation]
//        
//            if classifications.isEmpty {
//                self.classificationLabel = "Nothing recognized."
//            } else {
//                // Display top classifications ranked by confidence in the UI.
//                let topClassifications = classifications.prefix(2)
//                let descriptions = topClassifications.map { classification in
//                    // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
//                   return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
//                }
//                self.classificationLabel = "Classification:\n" + descriptions.joined(separator: "\n")
//            }
//        }
//    }
//}
//
//
