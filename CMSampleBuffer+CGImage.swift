//
//  CMSampleBuffer+CGImage.swift
//  HearMeOut
//
//  Created by Yuri Mario Gianoli on 21/05/24.
//

import AVFoundation
import CoreImage

extension CMSampleBuffer {
    var cgImage: CGImage? {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(self) else {
            return nil
        }
        
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        
        return context.createCGImage(ciImage, from: ciImage.extent)
    }
}
