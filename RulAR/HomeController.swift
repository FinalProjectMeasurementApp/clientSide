//
//  HomeController.swift
//  RulAR
//
//  Created by Violerine on 26/07/18.
//  Copyright © 2018 Michael Cangcianno. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
//struct Course{
//    let id: Int
//    let name: String
//    let link: String
//    let imageUrl: String
//    let number_of_lessons: Int
//}



struct Shape: Decodable{
    let _id: String
    let name: String
    let area: Int
    let perimeter: Int
    let coordinates:[SCNVector3]
    let createdAt: String
    let updatedAt: String
}

class HomeController : UIViewController{
    override func viewDidLoad() {
        
        print("MUNCUL GA DISINI")
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        let jsonUrl = "http://localhost:8000/shape/"
        guard let url = URL(string: jsonUrl) else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do{
                print("masuk do ga")
                let shape = try
                    JSONDecoder().decode([Shape].self, from: data)
                print("shape nameeeeee ",shape)
                
            }catch let jsonErr {
                print("Erroor",jsonErr)
                print("response", response!)
            }

        }.resume()
    }
    
    @IBAction func triggerNavigate(_ sender: Any) {
        let inputVc = self.storyboard?.instantiateViewController(withIdentifier: "inputModel") as! InputController
        self.navigationController?.pushViewController(inputVc, animated: true)
    }
    
    @IBAction func floorButton(_ sender: Any) {
        let toFloor = self.storyboard?.instantiateViewController(withIdentifier: "floorplan") as! FloorPlanController
        self.navigationController?.pushViewController(toFloor, animated: true)
        
    }
    @IBAction func wallButton(_ sender: Any) {
        let toWall = self.storyboard?.instantiateViewController(withIdentifier: "wallplan") as! WallPlanController
        self.navigationController?.pushViewController(toWall, animated: true)
    }
    
    
}

