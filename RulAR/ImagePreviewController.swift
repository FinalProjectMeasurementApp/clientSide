//
//  ImagePreviewController.swift
//  RulAR
//
//  Created by Violerine on 29/07/18.
//  Copyright © 2018 Michael Cangcianno. All rights reserved.
//

import Foundation
import UIKit
import ARKit


class ImagePreviewController : UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var PreviewBoard: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var areaLabel: UILabel!
    
    var coordinates : [SCNVector3] = []
    var lengths : [Float] = []
    var area : Float = 0

    struct Model: Codable{
        let username: String
        let coordinates: [SCNVector3]
        let name: String
        let area: Float
        let perimeter: Int
        let lengths: [Float]
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        areaLabel.text = "Area: \((area*10000).rounded()/10000)m2"
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        drawPreview()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return PreviewBoard
    }
    
    @IBAction func saveData(_ sender: UIButton) {
        let usernameFromUserDefaults = UserDefaults.standard.string(forKey: "username")
        let myModel = Model(username: "5b5e92473d3d555ef0a4a320", coordinates: coordinates, name: "dasda", area: area, perimeter: 23, lengths: lengths)
        
        submitModel(post: myModel){ (error) in
            if let error = error{
                fatalError(error.localizedDescription)
            }
            
        }
    }
    
    func drawPreview() {
        let minX = coordinates.min { a, b in a.x < b.x }?.x
        let minY = coordinates.min { a, b in a.z < b.z }?.z
        let maxX = (coordinates.max { a, b in a.x < b.x }?.x)! - minX!
        let maxY = (coordinates.max { a, b in a.z < b.z }?.z)! - minY!
        
        PreviewBoard.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let shape = CAShapeLayer()
        PreviewBoard.layer.addSublayer(shape)
        shape.opacity = 0.5
        shape.lineWidth = 4
        shape.lineJoin = kCALineJoinMiter
        shape.strokeColor = UIColor.gray.cgColor
        shape.fillColor = UIColor(hue: 0, saturation: 0, brightness: 0.7, alpha: 1).cgColor
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: (Int(((coordinates[0].x - minX!) * 333 / maxX).rounded())), y: Int(((coordinates[0].z - minY!) * 333 / maxY).rounded())))
        
        var centerCoor: CGPoint
        var centerXText: Float
        var centerYText: Float
        
        centerXText = (((coordinates[0].x - minX!) + (coordinates[1].x - minX!))) * 333
        centerYText = (((coordinates[0].z - minY!) + (coordinates[1].z - minY!))) * 333
        
        centerCoor = CGPoint(x: Int((centerXText / maxX)+50)/2, y: Int((centerYText / maxY)+8)/2)
        
        
        let myTextLayer = CATextLayer()
        myTextLayer.string = "\((lengths[0]*100).rounded()/100)m"
        myTextLayer.foregroundColor = UIColor.black.cgColor
        myTextLayer.frame = CGRect(x:0.0,y:0.0,width:100,height:16)
        myTextLayer.position = centerCoor
        print(myTextLayer.frame)
        myTextLayer.fontSize = 16.0
        print(myTextLayer.position)
        PreviewBoard.layer.addSublayer(myTextLayer)
        
        for (index, coordinate) in coordinates.enumerated() {
            print("x: \((Int(((coordinate.x - minX!) * 333 / maxX).rounded()))), y: \((Int(((coordinate.z - minY!) * 333 / maxY).rounded())))")
            path.addLine(to: CGPoint(x: (Int(((coordinate.x - minX!) * 333 / maxX).rounded())), y: (Int(((coordinate.z - minY!) * 333 / maxY).rounded()))))
            
            if coordinates.count > 2 && index > 1 {
                
                centerXText = (((coordinate.x - minX!) + (coordinates[index-1].x - minX!))) * 333
                centerYText = (((coordinate.z - minY!) + (coordinates[index-1].z - minY!))) * 333
                
                centerCoor = CGPoint(x: Int((centerXText / maxX)+50)/2, y: Int((centerYText / maxY)+8)/2)
                
                print("center", centerCoor)
                
                let myTextLayer = CATextLayer()
                myTextLayer.string = "\((lengths[index-1]*100).rounded()/100)m"
                myTextLayer.foregroundColor = UIColor.black.cgColor
                myTextLayer.frame = CGRect(x:0.0,y:0.0,width:100,height:16)
                myTextLayer.position = centerCoor
                myTextLayer.fontSize = 16.0
                PreviewBoard.layer.addSublayer(myTextLayer)
            }
            
            if index == coordinates.count-1 {
                centerXText = (((coordinates[0].x - minX!) + (coordinates[coordinates.count-1].x - minX!))) * 333
                centerYText = (((coordinates[0].z - minY!) + (coordinates[coordinates.count-1].z - minY!))) * 333
                
                centerCoor = CGPoint(x: Int((centerXText / maxX)+50)/2, y: Int((centerYText / maxY)+8)/2)
                print("center",centerCoor)
                let myTextLayer = CATextLayer()
                myTextLayer.string = "\((lengths[index]*100).rounded()/100)m"
                myTextLayer.foregroundColor = UIColor.black.cgColor
                myTextLayer.frame = CGRect(x:0.0,y:0.0,width:100,height:16)
                myTextLayer.position = centerCoor
                myTextLayer.fontSize = 16.0
                PreviewBoard.layer.addSublayer(myTextLayer)
            }
            
            
        }
        path.close()
        shape.path = path.cgPath
        
    }
    
    func submitModel(post: Model,completion:((Error?)-> Void)?){
        guard let url = URL(string: "https://rular-server.mcang.ml/shape/add") else{
            fatalError("Couldn't create URL from components")
        }
        print("URL",url)
        
        var request = URLRequest(url:url)
        
        request.httpMethod="POST"
        
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        let encoder = JSONEncoder()
        do{
            let jsonData = try encoder.encode(post)
            request.httpBody = jsonData
            print("Ini data stringnya", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
            
        } catch{
            completion?(error)
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                completion?(responseError!)
                return
            }
            
            if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                print("PRINT RESPONSE ", utf8Representation)
                
            } else {
                print("no readable data received in response")
            }
        }
        task.resume()
    }
}
