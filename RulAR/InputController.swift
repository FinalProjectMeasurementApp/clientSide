//
//  InputController.swift
//  RulAR
//
//  Created by Violerine on 26/07/18.
//  Copyright © 2018 Michael Cangcianno. All rights reserved.
//

import Foundation
import UIKit

class InputController : UIViewController{

    
    var textValue : String!
    
    @IBOutlet weak var nameInput: UITextField!
//
    @IBAction func inputChanged(_ sender: UITextField) {
        print(sender.text!)
        textValue = sender.text!
    }
    
    
    @IBAction func submitButton(_ sender: Any) {
        print(textValue)
        print("button di pencet")

    }
}
