//
//  FullViewController.swift
//  SIGHT
//
//  Created by Samuel Gray on 01/12/2017.
//  Copyright © 2017 Samuel Gray. All rights reserved.
//


import UIKit
import AVKit
import Vision
import AVFoundation

class ImpairedSightViewController: UIViewController, UINavigationControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    
  
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    var speak = Timer()
    
    
    @IBOutlet weak var identifierLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //stop intro timer.
        introTimer.invalidate()
        //run the speak timer
        self.speak = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(speakNow), userInfo: nil, repeats: true)
        
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        
        
        setupIdentifierConfidenceLabel()
        
        
    }

    
    fileprivate func setupIdentifierConfidenceLabel() {
        view.addSubview((identifierLabel))
        identifierLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32).isActive = true
        identifierLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        identifierLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        identifierLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else { return }
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
            
            
            guard let results = finishedReq.results as? [VNClassificationObservation] else { return }
            guard let firstObservation = results.first else { return }
            DispatchQueue.main.async {
                var str = "\(firstObservation.identifier)"
                
                if let dotRange = str.range(of: ",") {
                    str.removeSubrange(dotRange.lowerBound..<str.endIndex)
                }
                
                self.identifierLabel.text = str
                self.myUtterance = AVSpeechUtterance(string: str)
                self.myUtterance.rate = 0.5
                
            }
            
            
            
            
            
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
    //the function that starts the speaking, called by the speak timer
    @objc func speakNow(){
        
        self.synth.speak(self.myUtterance)
    }

    
    
    
    
    
    
    
    
    
}


