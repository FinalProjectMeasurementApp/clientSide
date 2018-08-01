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
    let labelInfo = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func woodButton(_ sender: Any) {
        button.isSelected = true
        
        if button.isSelected == true {
            label.frame = CGRect(x: 22, y: 253, width: 100, height: 140)
            label.text = ""
            label.textAlignment = .center
            label.textColor = UIColor.black
            label.backgroundColor = UIColor.clear
            label.layer.borderWidth = 1
            label.layer.borderColor = UIColor.black.cgColor
            label.font = UIFont(name: "Cooperplate-Bold", size: 22)
            labelInfo.frame = CGRect(x: 50, y: 300, width: 400, height: 400)
            let areaNow = UserDefaults.standard.integer(forKey:"currentArea")
            let totalPrice = Float(areaNow * 100 * 150000)
            let totalPriceString = String(totalPrice)
            labelInfo.text = "Size per block : 100 x 100 cm\nPrice per block : Rp. 150.000,00\nPrice by measurement : " + totalPriceString
            labelInfo.textColor = UIColor.black
            labelInfo.font = UIFont(name: "Cooperplate-Bold", size: 22)
            labelInfo.lineBreakMode = .byWordWrapping
            labelInfo.numberOfLines = 4
            self.view.addSubview(label)
            self.view.addSubview((labelInfo))
            self.view.addSubview(label)
        }
        print(button.isSelected)
    }

    
    @IBAction func tileButton(_ sender: Any) {
        
        button.isSelected = true
        if button.isSelected == true{
            label.frame = CGRect(x: 253, y: 253, width: 100, height: 140)
            label.text = ""
            label.textAlignment = .center
            label.textColor = UIColor.black
            label.backgroundColor = UIColor.clear
            label.layer.borderWidth = 1
            label.layer.borderColor = UIColor.black.cgColor
            label.font = UIFont(name: "Cooperplate-Bold", size: 22)
            labelInfo.frame = CGRect(x: 50, y: 300, width: 400, height: 400)
            let areaNow = UserDefaults.standard.integer(forKey:"currentArea")
            let totalPrice = Float(areaNow * 25 * 70000)
            let totalPriceString = String(totalPrice)
            labelInfo.text = "Size per block : 50 x 50 cm\nPrice per block : Rp. 70.000,00\nPrice by measurement : " + totalPriceString
            labelInfo.textColor = UIColor.black
            labelInfo.font = UIFont(name: "Cooperplate-Bold", size: 22)
            labelInfo.lineBreakMode = .byWordWrapping
            labelInfo.numberOfLines = 4
            
            self.view.addSubview((labelInfo))
            self.view.addSubview(label)
            print("SELECTED tile button")
        }
    }
    
    
    
    @IBAction func stoneButton(_ sender: Any) {
        
        button.isSelected = true
        if button.isSelected == true{
                label.frame = CGRect(x: 137, y: 253, width: 100, height: 140)
                label.text = ""
                label.textAlignment = .center
                label.textColor = UIColor.black
                label.backgroundColor = UIColor.clear
                label.layer.borderWidth = 1
                label.layer.borderColor = UIColor.black.cgColor
                label.font = UIFont(name: "Cooperplate-Bold", size: 22)
                let areaNow = UserDefaults.standard.integer(forKey:"currentArea")
                let totalPrice = Float(areaNow * 25 * 150000)
                let totalPriceString = String(totalPrice)
                labelInfo.frame = CGRect(x: 50, y: 300, width: 400, height: 400)
                labelInfo.text = "Size per block : 50 x 50 cm\nPrice per block : Rp. 150.000,00\nPrice by measurement : " + totalPriceString
                labelInfo.textColor = UIColor.black
                labelInfo.font = UIFont(name: "Cooperplate-Bold", size: 22)
                labelInfo.lineBreakMode = .byWordWrapping
                labelInfo.numberOfLines = 4
                self.view.addSubview(label)
                self.view.addSubview((labelInfo))
            print("STONE BUTTON IS SELECTED")
        }
    }
    
    


    @IBAction func floorMeasure(_ sender: Any) {
        UserDefaults.standard.set("floor",forKey:"cameraType")
        let inputVc = self.storyboard?.instantiateViewController(withIdentifier: "inputModel") as! InputController
        print("inputVc",inputVc)
        self.navigationController?.pushViewController(inputVc, animated: true)
        
    }
    
    
}
