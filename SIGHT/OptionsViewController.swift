//
//  ViewController.swift
//  SIGHT
//
//  Created by Samuel Gray on 01/12/2017.
//  Copyright © 2017 Samuel Gray. All rights reserved.
//

import UIKit
import AVKit
import Vision
import AVFoundation
var optionsTimer = Timer()
class OptionsViewController: UIViewController {
    //speaker
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    @IBOutlet weak var fullsSghtBtn: UIButton!
    @IBOutlet weak var impairedBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            //around btns
        fullsSghtBtn.layer.cornerRadius = 5
        fullsSghtBtn.clipsToBounds = true
        impairedBtn.layer.cornerRadius = 5
        impairedBtn.clipsToBounds = true
        //start timer
        introTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(runTimeCode), userInfo: nil, repeats: false)
    }

    
    //timer funcation
    @objc func runTimeCode() {
        myUtterance = AVSpeechUtterance(string: "Hello, welcome to SIGHT, I'm your guide and I'll aid you through the use of the app. First you need to tell me what your impairment is. If you are able to see the options on the screen, pick one. If not using your finger or thumb, swipe in an upwards direction.")
        myUtterance.rate = 0.5
        synth.speak(self.myUtterance)
    }
    //skip intro button
    @IBAction func skipIntro(_ sender: Any) {
        synth.stopSpeaking(at: .word)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        synth.stopSpeaking(at: .word)
    }


}

