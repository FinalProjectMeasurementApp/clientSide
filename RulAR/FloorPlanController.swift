//
//  FloorPlanController.swift
//  RulAR
//
//  Created by Violerine on 28/07/18.
//  Copyright © 2018 Michael Cangcianno. All rights reserved.
//

import Foundation
import UIKit

class FloorPlanController : UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func woodButton(_ sender: Any) {
        let button = UIButton()
        print("BUTTON",button)
        print("BUTTON SEBELOM",button.isSelected)
        button.isSelected = true
        
        if button.isSelected == true {
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.black.cgColor
            print("MASUK SINI Ga")
        }
        print(button.isSelected)
    }
    
    
}
