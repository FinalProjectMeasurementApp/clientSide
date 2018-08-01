//
//  FloorPlanController.swift
//  RulAR
//
//  Created by Violerine on 28/07/18.
//  Copyright © 2018 Michael Cangcianno. All rights reserved.
//

import Foundation
import UIKit

class WallPlanController : UIViewController{
    let button = UIButton()
    let label = UILabel()
    let labelInfo = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func wallpaperButton(_ sender: Any) {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "id_ID")
        
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
            let areaPerBlock = Float(1)
            let pricePerBlock = Float(100000)
            let areaNow = UserDefaults.standard.float(forKey:"shapeArea")
            let totalPrice = areaNow / areaPerBlock * pricePerBlock as NSNumber
            let totalPriceString = formatter.string(from: totalPrice)
            labelInfo.text = "Size per block : 1 x 1 m\nPrice per block : Rp100.000,00\nTotal Price : " + totalPriceString! + ",00"
            labelInfo.textColor = UIColor.black
            labelInfo.font = UIFont(name: "Cooperplate-Bold", size: 22)
            labelInfo.lineBreakMode = .byWordWrapping
            labelInfo.numberOfLines = 4
            self.view.addSubview(labelInfo)
            self.view.addSubview(label)
            print("SELECTED tile button")
        }
        print(button.isSelected)
    }
    
    @IBAction func paintButton(_ sender: Any) {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "id_ID")
        
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
            labelInfo.frame = CGRect(x: 50, y: 300, width: 400, height: 400)
            let areaPerBlock = Float(1)
            let pricePerBlock = Float(30000)
            let areaNow = UserDefaults.standard.float(forKey:"shapeArea")
            let totalPrice = areaNow / areaPerBlock * pricePerBlock as NSNumber
            let totalPriceString = formatter.string(from: totalPrice)
            labelInfo.text = "Size per block : 1 x 1 m\nPrice per block : Rp30.000,00\nTotal Price : " + totalPriceString! + ",00"
            labelInfo.textColor = UIColor.black
            labelInfo.font = UIFont(name: "Cooperplate-Bold", size: 22)
            labelInfo.lineBreakMode = .byWordWrapping
            labelInfo.numberOfLines = 4
            self.view.addSubview(labelInfo)
            self.view.addSubview(label)
            print("STONE BUTTON IS SELECTED")
        }
    }
    
    @IBAction func brickButton(_ sender: Any) {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "id_ID")
        
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
            let areaPerBlock = Float(1)
            let pricePerBlock = Float(200000)
            let areaNow = UserDefaults.standard.float(forKey:"shapeArea")
            let totalPrice = areaNow / areaPerBlock * pricePerBlock as NSNumber
            let totalPriceString = formatter.string(from: totalPrice)
            labelInfo.text = "Size per block : 1 x 1 m\nPrice per block : Rp200.000,00\nTotal Price : " + totalPriceString! + ",00"
            labelInfo.textColor = UIColor.black
            labelInfo.font = UIFont(name: "Cooperplate-Bold", size: 22)
            labelInfo.lineBreakMode = .byWordWrapping
            labelInfo.numberOfLines = 4
            self.view.addSubview(labelInfo)
            self.view.addSubview(label)
            print("SELECTED tile button")
        }
    }
    
    @IBAction func newMeasurement(_ sender: Any) {
        UserDefaults.standard.set("wall",forKey:"cameraType")
        
        let inputVc = self.storyboard?.instantiateViewController(withIdentifier: "inputModel") as! InputController
        print("inputVc",inputVc)
        self.navigationController?.pushViewController(inputVc, animated: true)
    }
    
}
