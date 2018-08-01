//
//  imageDetailController.swift
//  RulAR
//
//  Created by Violerine on 01/08/18.
//  Copyright © 2018 Michael Cangcianno. All rights reserved.
//

import Foundation
import UIKit
let detailLabel = UILabel()


class imageDetailController : UIViewController{
    
    
    @IBOutlet weak var wallButton: UIButton!
    
    @IBOutlet weak var floorButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let shapeArea = UserDefaults.standard.string(forKey: "shapeArea")
        let shapeName = UserDefaults.standard.string(forKey: "shapeName")
        let shapeType = UserDefaults.standard.string(forKey: "shapeType")
        
        if shapeType == "floor"{
            wallButton.isHidden = true
        }else{
            floorButton.isHidden = true
            
        }
        
        detailLabel.frame = CGRect(x: 50, y: 270, width: 400, height: 400)
        detailLabel.text = " Model Name : " + shapeName! + "\n Model Area : " + shapeArea! + "\n Model Type : " + shapeType!
        detailLabel.textColor = UIColor.black
        detailLabel.font = UIFont(name: "Copperplate", size: 20)!
        detailLabel.lineBreakMode = .byWordWrapping
        detailLabel.numberOfLines = 4
        let url = URL(string: UserDefaults.standard.string(forKey: "shapeUrl")!)
        let imageData = try? Data(contentsOf: url!)
        let image = UIImage(data: imageData!)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 40, y: 80, width: 300, height: 300)
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(imageView)
        self.view.addSubview(detailLabel)
    }
    
    
    @IBAction func planWall(_ sender: Any) {
        let toPlanWall = self.storyboard?.instantiateViewController(withIdentifier: "wallplan") as! WallPlanController
        self.navigationController?.pushViewController(toPlanWall, animated: true)
    }
    
    @IBAction func planFloor(_ sender: Any) {
        let toPlanFloor = self.storyboard?.instantiateViewController(withIdentifier: "floorplan") as! FloorPlanController
        self.navigationController?.pushViewController(toPlanFloor, animated: true)
    }
    
}
