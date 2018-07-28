//
//  InputController.swift
//  RulAR
//
//  Created by Violerine on 26/07/18.
//  Copyright © 2018 Michael Cangcianno. All rights reserved.
//

import Foundation
import UIKit

struct User: Codable {
    let username: String
}

class InputController : UIViewController{
    
    let postUser = User(username: "testing")
    
    var textValue : String!
    
    @IBOutlet weak var nameInput: UITextField!
//
    @IBAction func inputChanged(_ sender: UITextField) {
        print(sender.text!)
        textValue = sender.text!
        print("TEXT VALUE INPUT",textValue)
    }

    @IBAction func submitButton(_ sender: Any) {
        
        print("DAPET TEXT VALUENYA GA",textValue)
        print("button di pencet")
    }
}
