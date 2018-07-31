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


class HomeController : UIViewController{
    var shapeData: [Shape] = []
    
    func query(address: String) {
        let url = URL(string:address)
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: url!)  { (data, response, error) in
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
//        return result
    }
    
    override func viewDidLoad() {
        print("MUNCUL GA DISINI")
        super.viewDidLoad()
        let pref = query(address: "https://rular-server.mcang.ml/shape")
        print("SHAPE",shapeData)
        self.navigationItem.setHidesBackButton(true, animated: false)
        for (index, data) in shapeData.enumerated(){
            print("DATAAA",data)
            count += 1
            print(count)
            //kalo genap
            if index % 2 == 0{
                button = UIButton()
                label = UILabel()
                button.frame = CGRect(x: 200, y: 230+80*index, width: 150, height: 150)
                button.setTitle("KALO GENAP", for: .normal)
                button.titleLabel?.text = "kalo genap"
                button.titleLabel?.textAlignment = .center
                button.titleLabel?.textColor = UIColor.black
                button.backgroundColor = UIColor.darkGray
                button.isUserInteractionEnabled = true
                button.tag = index
                button.addTarget(self, action: #selector(previewShape(_:)), for: .touchUpInside)
                print("DATA AREA", data.area)
                self.view.addSubview(button)
            }
            //kalo ganjil
            else{
                label = UILabel()
                button = UIButton()
                button.frame = CGRect(x: 30, y: 230+80*(index-1), width: 150, height: 150)
                button.setTitle("KALO Ganjil", for: .normal)
                button.titleLabel?.text = "kalo ganjil"
                button.titleLabel?.textAlignment = .center
                button.titleLabel?.textColor = UIColor.black
                button.backgroundColor = UIColor.red
                button.isUserInteractionEnabled = true
                button.tag = index
                button.addTarget(self, action: #selector(previewShape(_:)), for: .touchUpInside)
                print("DATA AREA", data.area)
                self.view.addSubview(button)
            }
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
        self.navigationController?.pushViewController(inputVc, animated: true)
    }
    
    func getPreview (button: UIButton, coordinates: [SCNVector3]) {
        let minX = coordinates.min { a, b in a.x < b.x }?.x
        let minY = coordinates.min { a, b in a.z < b.z }?.z
        let maxX = (coordinates.max { a, b in a.x < b.x }?.x)! - minX!
        let maxY = (coordinates.max { a, b in a.z < b.z }?.z)! - minY!
        
        button.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let shape = CAShapeLayer()
        button.layer.addSublayer(shape)
        shape.opacity = 0.5
        shape.lineWidth = 2
        shape.lineJoin = kCALineJoinMiter
        shape.strokeColor = UIColor(hue: 0.786, saturation: 0.79, brightness: 0.53, alpha: 1.0).cgColor
        shape.fillColor = UIColor(hue: 0.786, saturation: 0.15, brightness: 0.89, alpha: 1.0).cgColor
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: (Int(((coordinates[0].x - minX!) * 150 / maxX).rounded())), y: Int(((coordinates[0].z - minY!) * 150 / maxY).rounded())))
        
        for coordinate in coordinates {
            path.addLine(to: CGPoint(x: (Int(((coordinate.x - minX!) * 150 / maxX).rounded())), y: (Int(((coordinate.z - minY!) * 150 / maxY).rounded()))))
            
        }
        print("hoihoiho",coordinates)
        if(coordinates.count > 1){
            path.close()
        }
        
        shape.path = path.cgPath
    }
    
    func functionBaru(){
        print("AAAAAA")
    }
    
    
}

