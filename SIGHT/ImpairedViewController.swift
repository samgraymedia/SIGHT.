//
//  ImpairedViewController.swift
//  SIGHT
//
//  Created by Samuel Gray on 03/05/2018.
//  Copyright © 2018 Samuel Gray. All rights reserved.
//

import UIKit
import AVKit
import Vision
import AVFoundation


class ImapiredViewController: UIViewController, UINavigationControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    @IBOutlet weak var identifierLabel: UILabel!
    @IBOutlet weak var cameraView: UIView!
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    var speak = Timer()
    var str = ""
    var previewLayer: AVCaptureVideoPreviewLayer!
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
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = cameraView.bounds
        previewLayer.videoGravity = .resizeAspectFill
        cameraView.layer.addSublayer(previewLayer)
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = cameraView.bounds
    }
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else { return }
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
            
            
            guard let results = finishedReq.results as? [VNClassificationObservation] else { return }
            guard let firstObservation = results.first else { return }
            DispatchQueue.main.async {
                self.str = "\(firstObservation.identifier)"
                
                if let dotRange = self.str.range(of: ",") {
                    self.str.removeSubrange(dotRange.lowerBound..<self.str.endIndex)
                }
            }
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    @objc func speakNow(){
        self.identifierLabel.text = self.str
        self.myUtterance = AVSpeechUtterance(string: self.str)
        self.myUtterance.rate = 0.5
        self.synth.speak(self.myUtterance)
    }
    
    @IBAction func home(_ sender: Any) {
          dismiss(animated: true, completion: nil)
            self.speak.invalidate()
        
    }
    

    
}
