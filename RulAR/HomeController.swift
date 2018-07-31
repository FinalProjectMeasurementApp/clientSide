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

struct Shape: Decodable{
    let _id: String
    let name: String
    let area: Float
    let perimeter: Int
    let image: String
    let createdAt: String
    let updatedAt: String
    let type: String
}

struct labelProps{
    let position: Int
    let word: String
}

var word1 = labelProps(position: 30, word: "meong")
var word2 = labelProps(position: 130, word: "booozzzz")
var word3 = labelProps(position: 230, word: "woof")


var button = UIButton()
var label = UILabel()
var count = 0
var area = 0
var typeData = ""
var areaData : Float!

class HomeController : UIViewController, UIScrollViewDelegate{
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is ImagePreviewController
        {
            let vc = segue.destination as? ImagePreviewController
//            vc?.coordinates = coordinates
//            vc?.lengths = lengths
//            vc?.area = areaValue
        }
    }
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var homeView: UIView!
    
    
    var shapeData: [Shape] = []
    
    func query(address: String) {
        let semaphore = DispatchSemaphore(value: 0)
        
        print("MUNCUL GA DISINI")
        self.navigationItem.setHidesBackButton(true, animated: false)
        let jsonUrl = "https://rular-server.mcang.ml/shape/"
        guard let url = URL(string: jsonUrl) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url)  { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do{
                print("masuk do ga")
                let shape = try JSONDecoder().decode([Shape].self, from: data)
                self.shapeData = shape
                semaphore.signal()
                
            }catch let jsonErr {
                print("Erroor",jsonErr)
                print("response", response!)
            }
        }

        task.resume()
        semaphore.wait()
    }
    
    @IBOutlet weak var wallPlannerButton: UIButton!
    
    @IBOutlet weak var floorPlannerButton: UIButton!
    
    override func viewDidLoad() {
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = true
        scrollView.isScrollEnabled = true
    
        
        super.viewDidLoad()
        let pref = query(address: "https://rular-server.mcang.ml/shape")
        self.navigationItem.setHidesBackButton(true, animated: false)
        scrollView.contentSize = CGSize(width: 200, height: 1000)
        for (index, data) in shapeData.enumerated(){
            count += 1
            print(count)
            if index % 2 == 0{
                button = UIButton()
                label = UILabel()
                button.frame = CGRect(x: 200, y: 0+90*index, width: 150, height: 150)
                button.setTitle("KALO GENAP", for: .normal)
                button.titleLabel?.text = "kalo genap"
                button.titleLabel?.textAlignment = .center
                button.titleLabel?.textColor = UIColor.black
                button.backgroundColor = UIColor.darkGray
                button.isUserInteractionEnabled = true
                button.tag = index
                button.layer.cornerRadius = 7
                button.layer.borderWidth = 2
                button.layer.borderColor = UIColor.black.cgColor
                let url = URL(string: data.image)
                let imageData = try? Data(contentsOf: url!)
                let imagePreview = UIImage(data: imageData!)
                button.setImage(imagePreview , for: UIControlState.normal)
                button.addTarget(self, action: #selector(previewShape(_:)), for: .touchUpInside)
                label.frame = CGRect(x: 200, y: 120+90*index, width: 150, height: 40)
                label.text = data.name + "\ntype: " + data.type
                label.lineBreakMode = .byWordWrapping
                label.numberOfLines = 2
                label.font = UIFont.systemFont(ofSize: 12)
                label.layer.borderWidth = 2
                label.layer.borderColor = UIColor.black.cgColor
                label.backgroundColor = UIColor.white
                label.textAlignment = .center
                self.scrollView.addSubview(button)
                self.scrollView.addSubview(label)
                typeData = data.type
                areaData = data.area
            }
            //kalo ganjil
            else{
                button = UIButton()
                label = UILabel()
                button.frame = CGRect(x: 25, y: 0+90*(index-1), width: 150, height: 150)
                button.setTitle("KALO Ganjil", for: .normal)
                button.titleLabel?.text = "kalo ganjil"
                button.titleLabel?.textAlignment = .center
                button.titleLabel?.textColor = UIColor.black
                button.backgroundColor = UIColor.red
                button.isUserInteractionEnabled = true
                button.tag = index
                button.layer.cornerRadius = 7
                button.layer.borderWidth = 2
                button.layer.borderColor = UIColor.black.cgColor
                let url = URL(string: data.image)
                let imageData = try? Data(contentsOf: url!)
                let imagePreview = UIImage(data: imageData!)
                button.setImage(imagePreview , for: UIControlState.normal)
                button.addTarget(self, action: #selector(previewShape(_:)), for: .touchUpInside)
                label.frame = CGRect(x: 25, y: 120+90*(index-1), width: 150, height: 40)
                label.text = data.name + "  type: " + data.type
                label.text = data.name + "\ntype: " + data.type
                label.lineBreakMode = .byWordWrapping
                label.numberOfLines = 2
                label.font = UIFont.systemFont(ofSize: 12)
                label.layer.borderWidth = 2
                label.layer.borderColor = UIColor.black.cgColor
                label.backgroundColor = UIColor.white
                label.textAlignment = .center
                self.scrollView.addSubview(button)
                self.scrollView.addSubview(label)
                typeData = data.type
                areaData = data.area
            }
            
            self.homeView.frame.size.height += 80
            scrollView.contentSize = homeView.frame.size

//            self.getPreview(button: button, coordinates: data.coordinates)
        }
        
    }

    @IBAction func previewShape(_ sender:UIButton!) {
        if(typeData == "floor"){
            let toFloor = self.storyboard?.instantiateViewController(withIdentifier: "floorplan") as! FloorPlanController
            self.navigationController?.pushViewController(toFloor, animated: true)
        }else{
            let toWall = self.storyboard?.instantiateViewController(withIdentifier: "wallplan") as! WallPlanController
            self.navigationController?.pushViewController(toWall, animated: true)
        }
    }
    

//    @IBAction func triggerNavigate(_ sender: Any) {
//        let inputVc = self.storyboard?.instantiateViewController(withIdentifier: "inputModel") as! InputController
//        print("inputVc",inputVc)
//        self.navigationController?.pushViewController(inputVc, animated: true)
//    }
    
    @IBAction func floorButton(_ sender: Any) {
        UserDefaults.standard.set("floor",forKey:"cameraType")
        let toCamera = self.storyboard?.instantiateViewController(withIdentifier: "inputModel") as! InputController
        self.navigationController?.pushViewController(toCamera, animated: true)
    }
    
    @IBAction func wallButton(_ sender: Any) {
        UserDefaults.standard.set("wall",forKey:"cameraType")
        let toCamera = self.storyboard?.instantiateViewController(withIdentifier: "inputModel") as! InputController
        self.navigationController?.pushViewController(toCamera, animated: true)
    }
    
}

