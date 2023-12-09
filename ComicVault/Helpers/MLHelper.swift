//
//  MLHelper.swift
//  ComicVault
//
//  Created by Ayman Tauhid on 2023-12-09.
//

import Foundation
import Vision
import CoreML
import UIKit

class MLHelper : ObservableObject{
    @Published var classification = "XXXX"
    
    private var classificationRequest : VNCoreMLRequest?
    
    func createRequest(){
        do{
            //obtain the ML model instance
            let model = try VNCoreMLModel(for: ComicVaultML_1(configuration: MLModelConfiguration()).model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: {request, error in
                
                if (error == nil){
                    self.processClassification(for: request, error: error)
                }else{
                    print(#function, "No proceeding with classification. Error : \(error!)")
                }
            })
            
            request.imageCropAndScaleOption = .centerCrop
            self.classificationRequest = request
            
        }catch let err {
            print(#function, "Unable to create request due to error : \(err)")
        }
    }
    
    func processClassification(for request : VNRequest, error : Error?){
        
        DispatchQueue.main.async {
            guard let results = request.results else{
                self.classification = "Unable to classify image due to error \(error!)"
                return
            }
            
            let classificationList = results as! [VNClassificationObservation]
            
            if classificationList.isEmpty{
                print(#function, "No classification recevied")
                self.classification = "No matching category for the flower"
            }else{
                let topClassifications = classificationList.prefix(upTo: 4)
                
                let desctiptions = topClassifications.map{ category in
                    return String(format: "(%.2f) %@", category.confidence, category.identifier)
                }
                
                self.classification = "\(desctiptions.joined(separator: "\n"))"
                print(#function, "classification : \(self.classification)")
            }
        }
        
    }
    
    func updateClassification(for selectedImage : UIImage){
        
        guard let imageInput = CIImage(image: selectedImage) else{
            print(#function, "unable to obtain CIImage for processsing")
            self.classification = "unable to obtain CIImage for processsing"
            return
        }
        
        let handler = VNImageRequestHandler(ciImage: imageInput)
        
        do{
            //create request and process it
            try handler.perform([self.classificationRequest!])
        }catch{
            print(#function, "Unable to perform classification due to error : \(error)")
        }
    }
}
