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
    var area = 0
    let button = UIButton()
    let label = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func woodButton(_ sender: Any) {
        button.isSelected = true
        
        if button.isSelected == true {
            label.frame = CGRect(x: 22, y: 140, width: 100, height: 140)
            label.text = ""
            label.textAlignment = .center
            label.textColor = UIColor.black
            label.backgroundColor = UIColor.clear
            label.layer.borderWidth = 1
            label.layer.borderColor = UIColor.black.cgColor
            label.font = UIFont(name: "Cooperplate-Bold", size: 22)
            self.view.addSubview(label)
        }
        print(button.isSelected)
    }

    
    @IBAction func tileButton(_ sender: Any) {
        
        button.isSelected = true
        if button.isSelected == true{
            label.frame = CGRect(x: 253, y: 140, width: 100, height: 140)
            label.text = ""
            label.textAlignment = .center
            label.textColor = UIColor.black
            label.backgroundColor = UIColor.clear
            label.layer.borderWidth = 1
            label.layer.borderColor = UIColor.black.cgColor
            label.font = UIFont(name: "Cooperplate-Bold", size: 22)
            self.view.addSubview(label)
            print("SELECTED tile button")
        }
    }
    
    
    
    @IBAction func stoneButton(_ sender: Any) {
        button.isSelected = true
        if button.isSelected == true{
                label.frame = CGRect(x: 137, y: 140, width: 100, height: 140)
                label.text = ""
                label.textAlignment = .center
                label.textColor = UIColor.black
                label.backgroundColor = UIColor.clear
                label.layer.borderWidth = 1
                label.layer.borderColor = UIColor.black.cgColor
                label.font = UIFont(name: "Cooperplate-Bold", size: 22)
                self.view.addSubview(label)
            print("STONE BUTTON IS SELECTED")
        }
    }
    

    
    
}
