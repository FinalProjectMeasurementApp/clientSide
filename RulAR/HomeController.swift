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
    let coordinates: [SCNVector3]
}


class subclassedUIButton: UIButton {
    var shapeArea: Float?
    var shapeName: String?
    var shapeUrl : String?
    var shapeType : String?
}

var button = subclassedUIButton()
var label = UILabel()
var area = 0

class HomeController : UIViewController, UIScrollViewDelegate{

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var homeView: UIView!
    var coordinates: [SCNVector3]!
    
    
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
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2
        
        let logo = UIImage(named: "apple.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        super.viewDidLoad()
        
        let pref = query(address: "https://rular-server.mcang.ml/shape")
        self.navigationItem.setHidesBackButton(true, animated: false)
        scrollView.contentSize = CGSize(width: 200, height: 0)
        for (index, data) in shapeData.enumerated(){
            if index % 2 == 0{
                button = subclassedUIButton()
                label = UILabel()
                button.frame = CGRect(x: 200, y: 0+85*index, width: 150, height: 140)
                button.setTitle("KALO GENAP", for: .normal)
                button.titleLabel?.text = "kalo genap"
                button.titleLabel?.textAlignment = .center
                button.titleLabel?.textColor = UIColor.black
                button.backgroundColor = UIColor.darkGray
                button.isUserInteractionEnabled = true
                button.tag = index
                button.shapeName = data.name
                button.shapeArea = data.area
                button.shapeType = data.type
                button.shapeUrl = data.image
                button.layer.cornerRadius = 7
                button.layer.borderWidth = 2
                button.layer.borderColor = UIColor.black.cgColor
                let url = URL(string: data.image)
                let imageData = try? Data(contentsOf: url!)
                let imagePreview = UIImage(data: imageData!)
                button.setImage(imagePreview , for: UIControlState.normal)
                button.addTarget(self, action: #selector(previewShape(_:)), for: .touchUpInside)
                label.frame = CGRect(x: 200, y: 110+85*index, width: 150, height: 40)
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
            }
            //kalo ganjil
            else{
                button = subclassedUIButton()
                label = UILabel()
                button.frame = CGRect(x: 25, y: 0+85*(index-1), width: 150, height: 140)
                button.setTitle("KALO Ganjil", for: .normal)
                button.titleLabel?.text = "kalo ganjil"
                button.titleLabel?.textAlignment = .center
                button.titleLabel?.textColor = UIColor.black
                button.backgroundColor = UIColor.red
                button.isUserInteractionEnabled = true
                button.tag = index
                button.shapeName = data.name
                button.shapeArea = data.area
                button.shapeType = data.type
                button.shapeUrl = data.image
                button.layer.cornerRadius = 7
                button.layer.borderWidth = 2
                button.layer.borderColor = UIColor.black.cgColor
                let url = URL(string: data.image)
                let imageData = try? Data(contentsOf: url!)
                let imagePreview = UIImage(data: imageData!)
                button.setImage(imagePreview , for: UIControlState.normal)
                button.addTarget(self, action: #selector(previewShape(_:)), for: .touchUpInside)
                label.frame = CGRect(x: 25, y: 110+85*(index-1), width: 150, height: 40)
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

            }
            
            self.homeView.frame.size.height += 95
            scrollView.contentSize = homeView.frame.size

        }
        
    }
    

    @IBAction func previewShape(_ sender:subclassedUIButton!) {
        UserDefaults.standard.set(sender.shapeArea,forKey:"shapeArea")
        UserDefaults.standard.set(sender.shapeType, forKey:"shapeType")
        UserDefaults.standard.set(sender.shapeName, forKey:"shapeName")
        UserDefaults.standard.set(sender.shapeUrl, forKey:"shapeUrl")
        
        let addCoordinates = shapeData[sender.tag].coordinates
        var getAllCoordinates:Array<Any>
        getAllCoordinates = []
        for coordinate in addCoordinates {
            getAllCoordinates.append([coordinate.x,coordinate.y,coordinate.z])
        }
        
        UserDefaults.standard.set(getAllCoordinates, forKey: "coordinates")
        
        let toDetail = self.storyboard?.instantiateViewController(withIdentifier: "imageDetail") as! imageDetailController
        
        self.navigationController?.pushViewController(toDetail, animated: true)

    }
    
    
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

