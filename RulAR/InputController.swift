//
//  InputController.swift
//  RulAR
//
//  Created by Violerine on 26/07/18.
//  Copyright © 2018 Michael Cangcianno. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

struct User: Codable {
    let username: String
}



class InputController : UIViewController{
     @IBOutlet weak var buttonEnterName: UIButton!

    override func viewDidLoad() {
        buttonEnterName.isHidden = true
    }
    
    let postUser = User(username: "testing")
    
    var textValue : String!
    
    @IBOutlet weak var nameInput: UITextField!
//
    @IBAction func inputChanged(_ sender: UITextField) {
        print(sender.text!)
        textValue = sender.text!
        print("TEXT VALUE INPUT",textValue)
        if textValue == "" {
            buttonEnterName.isHidden = true
        }else{
            buttonEnterName.isHidden = false
        }
        
    }
    
    
    @IBAction func submitName(_ sender: Any) {
        print("JANGAN ERROR"
        )
    }
    
       
    
}
