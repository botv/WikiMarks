//
//  MLKitService.swift
//  LandmarkHistory
//
//  Created by Ben Botvinick on 7/16/18.
//  Copyright © 2018 Ben Botvinick. All rights reserved.
//

import UIKit
import Firebase

struct MLService {
    static func evaluateImage(for uiImage: UIImage, completion: @escaping ([VisionCloudLandmark]?) -> Void) {
        let vision = Vision.vision()
        let cloudDetector = vision.cloudLandmarkDetector()
        
        let visionImage = VisionImage(image: uiImage)
        
        cloudDetector.detect(in: visionImage) { landmarks, error in
            guard error == nil, let landmarks = landmarks else {
                print("landmark detection failed")
                return completion(nil)
            }
            
            completion(landmarks)
        }
    }
}
