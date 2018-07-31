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
    let coordinates:[SCNVector3]
    let createdAt: String
    let updatedAt: String
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


class HomeController : UIViewController, UIScrollViewDelegate{
    
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
                print("shape nameeeeee ",shape)
                print(self.shapeData)
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
//        scrollView.contentSize = homeView.frame.size
        
        
             super.viewDidLoad()
        let pref = query(address: "https://rular-server.mcang.ml/shape")
        print("SHAPE",shapeData)
        self.navigationItem.setHidesBackButton(true, animated: false)
        scrollView.contentSize = CGSize(width: 200, height: 1000)
        for (index, data) in shapeData.enumerated(){
            print("DATAAA",data)
            count += 1
            print(count)
            if index % 2 == 0{
                button = UIButton()
                label = UILabel()
                button.frame = CGRect(x: 200, y: 0+80*index, width: 150, height: 150)
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
                button.addTarget(self, action: #selector(previewShape(_:)), for: .touchUpInside)
                print("DATA AREA", data.area)
                
                self.scrollView.addSubview(button)
            }
            //kalo ganjil
            else{
                label = UILabel()
                button = UIButton()
                button.frame = CGRect(x: 25, y: 0+80*(index-1), width: 150, height: 150)
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
                button.addTarget(self, action: #selector(previewShape(_:)), for: .touchUpInside)
                print("DATA AREA", data.area)
                self.scrollView.addSubview(button)
            }
            
            self.homeView.frame.size.height += 80
            scrollView.contentSize = homeView.frame.size
            print("HOMEVIEW",homeView.frame.size)

//            self.getPreview(button: button, coordinates: data.coordinates)
        }
        
    }

    @IBAction func previewShape(_ sender:UIButton!) {
        print("COOL FUNC")
//        let lol = shapeData[sender.tag].area
//        print("LOOOL",lol)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is FloorPlanController
        {
            let vc = segue.destination as? FloorPlanController
        }
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//            return shapeData.count
//    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath:
//        IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewModel
//
//        print("INI ISINYA APAAN SIH",indexPath.item)
//        print("SHAPE DATA DAPET GA DISINI",indexPath.item)
//
//        cell.myLabel.text = shapeData[indexPath.item].name
//        cell.myButton.titleLabel?.text = shapeData[indexPath.item].name
//        cell.myButton.addTarget(self, action: #selector(testingButton), for: .touchUpInside)
//        
//        return cell
//    }
    


    @IBAction func triggerNavigate(_ sender: Any) {
        let inputVc = self.storyboard?.instantiateViewController(withIdentifier: "inputModel") as! InputController
        print("inputVc",inputVc)
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

