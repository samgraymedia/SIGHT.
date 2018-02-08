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
//timer
var introTimer = Timer()
class BlindViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    //speaker
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    override func viewDidLoad() {
        super.viewDidLoad()
        optionsTimer.invalidate()
        //start timer
        introTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(runTimeCode), userInfo: nil, repeats: false)
        
        
    }
    
    //timer funcation
    @objc func runTimeCode() {
        myUtterance = AVSpeechUtterance(string: "Okay, you've selected the blind option, in order for me to start recorginising the objects around you I need you to start my inbuilt camera. Using your finger or thumb, please swipe to the left to open the camera")
        myUtterance.rate = 0.5
        synth.speak(self.myUtterance)
    }
    
}



