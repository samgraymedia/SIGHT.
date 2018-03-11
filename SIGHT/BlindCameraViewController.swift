//
//  BlindCameraViewController.swift
//  SIGHT
//
//  Created by Samuel Gray on 01/12/2017.
//  Copyright © 2017 Samuel Gray. All rights reserved.
//

import UIKit
import AVKit
import Vision
import AVFoundation

class BlindCameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var speak = Timer()
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    var str = "";
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //stop intro timer.
        introTimer.invalidate()
        //run the speak timer
        self.speak = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(speakNow), userInfo: nil, repeats: true)
        // here is where we start up the camera
        // for more details visit: https://www.letsbuildthatapp.com/course_video?id=1252
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



