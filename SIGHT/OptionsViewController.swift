//
//  ViewController.swift
//  SIGHT
//
//  Created by Samuel Gray on 01/12/2017.
//  Copyright © 2017 Samuel Gray. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
    @IBOutlet weak var fullsSghtBtn: UIButton!
    @IBOutlet weak var impairedBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            //around btns
        fullsSghtBtn.layer.cornerRadius = 5
        fullsSghtBtn.clipsToBounds = true
        impairedBtn.layer.cornerRadius = 5
        impairedBtn.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

