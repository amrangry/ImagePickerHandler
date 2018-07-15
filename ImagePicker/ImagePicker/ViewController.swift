//
//  ViewController.swift
//  ImagePicker
//
//  Created by Amr ELghadban on 7/15/18.
//  Copyright © 2018 ADKA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imagePreview: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func AddImageBtnPressed(_ sender: Any) {
        let imagePicker = ImagePickerHandler()
        imagePicker.pickerCancelTitle = "close"
        imagePicker.pickImage(self){ img in
            guard let image = img else {
                //user maybe cancel
                return
            }
            self.imagePreview.image = image
        }

    }

}

