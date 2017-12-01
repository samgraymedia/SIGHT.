//
//  BlindViewController.swift
//  SIGHT
//
//  Created by Samuel Gray on 01/12/2017.
//  Copyright © 2017 Samuel Gray. All rights reserved.
//

import UIKit
import AVKit
import Vision
import AVFoundation

class BlindViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    //timer
    var introTimer = Timer()
    //speaker
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    override func viewDidLoad() {
        super.viewDidLoad()
        //start timer
        introTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(runTimeCode), userInfo: nil, repeats: true)
        
        
    }
    
    //timer funcation
    @objc func runTimeCode() {
        myUtterance = AVSpeechUtterance(string: "Please swipe to the right to open the camera")
        myUtterance.rate = 0.5
        synth.speak(self.myUtterance)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



