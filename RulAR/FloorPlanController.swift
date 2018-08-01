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
        
        let price = 11123.436 as NSNumber
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "id_ID")
        
    }
    
    
    @IBAction func woodButton(_ sender: Any) {
        
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
            let areaPerBlock = Float(0.4)
            let pricePerBlock = Float(150000)
            let areaNow = UserDefaults.standard.float(forKey:"shapeArea")
            let totalPrice = areaNow / areaPerBlock * pricePerBlock as NSNumber
            let totalPriceString = formatter.string(from: totalPrice)
            labelInfo.text = "Size per block : 200 cm x 20 cm\nPrice per block : Rp150.000,00\nTotal Price : " + totalPriceString! + ",00"
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

    @IBAction func stoneButton(_ sender: Any) {
        
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
            let areaPerBlock = Float(0.0625)
            let pricePerBlock = Float(150000)
            let areaNow = UserDefaults.standard.float(forKey:"shapeArea")
            let totalPrice = areaNow / areaPerBlock * pricePerBlock as NSNumber
            let totalPriceString = formatter.string(from: totalPrice)
            labelInfo.frame = CGRect(x: 50, y: 300, width: 400, height: 400)
            labelInfo.text = "Size per block : 50 cm x 50 cm\nPrice per block : Rp150.000,00\nTotal Price : " + totalPriceString! + ",00"
            labelInfo.textColor = UIColor.black
            labelInfo.font = UIFont(name: "Cooperplate-Bold", size: 22)
            labelInfo.lineBreakMode = .byWordWrapping
            labelInfo.numberOfLines = 4
            self.view.addSubview(label)
            self.view.addSubview((labelInfo))
            print("STONE BUTTON IS SELECTED")
        }
    }
    
    @IBAction func tileButton(_ sender: Any) {
        
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
            let areaPerBlock = Float(0.25)
            let pricePerBlock = Float(70000)
            let areaNow = UserDefaults.standard.float(forKey:"shapeArea")
            let totalPrice = areaNow / areaPerBlock * pricePerBlock as NSNumber
            print(areaPerBlock, pricePerBlock, areaNow)
            let totalPriceString = formatter.string(from: totalPrice)
            labelInfo.text = "Size per block : 50 cm x 50 cm\nPrice per block : Rp70.000,00\nTotal price : " + totalPriceString! + ",00"
            labelInfo.textColor = UIColor.black
            labelInfo.font = UIFont(name: "Cooperplate-Bold", size: 22)
            labelInfo.lineBreakMode = .byWordWrapping
            labelInfo.numberOfLines = 4
            
            self.view.addSubview((labelInfo))
            self.view.addSubview(label)
            print("SELECTED tile button")
        }
    }

    @IBAction func floorMeasure(_ sender: Any) {
        UserDefaults.standard.set("floor",forKey:"cameraType")
        let inputVc = self.storyboard?.instantiateViewController(withIdentifier: "inputModel") as! InputController
        print("inputVc",inputVc)
        self.navigationController?.pushViewController(inputVc, animated: true)
        
    }
    
    
}
