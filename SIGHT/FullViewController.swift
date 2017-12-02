//
//  FullViewController.swift
//  SIGHT
//
//  Created by Samuel Gray on 01/12/2017.
//  Copyright © 2017 Samuel Gray. All rights reserved.
//


import UIKit

class FullSightViewController: UIViewController, UINavigationControllerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func photoLibrary(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


