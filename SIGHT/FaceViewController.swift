//
//  FaceViewController
//  SIGHT
//
//  Created by Samuel Gray on 01/12/2017.
//  Copyright © 2018 Samuel Gray. All rights reserved.
//

import UIKit
import Vision
class FaceViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let image = UIImage(named: "sample2") else{return}
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        
        let scaleHeight = view.frame.width / image.size.width * image.size.height
        
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width ,height: scaleHeight)
        imageView.backgroundColor = .blue
        view.addSubview(imageView)
        
        let request = VNDetectFaceRectanglesRequest { (req, err) in
            if let err = err{
                print("failed to find any faces:*", err)
                return
            }
            req.results?.forEach({ (res) in
                DispatchQueue.main.async {
                    print(res)
                    guard let faceObservation = res as?
                        VNFaceObservation else{
                            return
                    }
                    let x = self.view.frame.width * faceObservation.boundingBox.origin.x
                    let height = scaleHeight * faceObservation.boundingBox.height
                    let y = scaleHeight * (1 - faceObservation.boundingBox.origin.y) -  height
                    let width = self.view.frame.width * faceObservation.boundingBox.width
                    
                    let redView = UIView()
                    redView.backgroundColor = .red
                    redView.alpha = 0.4
                    redView.frame = CGRect(x:x,y:y,width:width,height:height)
                    self.view.addSubview(redView)

                    
    
                    print(faceObservation.boundingBox)
                }
     
            })
        }
        guard let cgImage = image.cgImage else {return}
        
        DispatchQueue.global(qos: .background).async {
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do{
                try handler.perform([request])
            } catch let reqErr{
                print("failed to perform req", reqErr)
            }
        }
     

    }

}




