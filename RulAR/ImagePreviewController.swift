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
    @IBOutlet weak var ImageView: UIImageView!
    
    var coordinates : [SCNVector3] = []
    var lengths : [Float] = []
    var area : Float = 0

    struct Model: Codable{
        let username: String
        let coordinates: [SCNVector3]
        let name: String
        let area: Float
        let perimeter: Float
        let lengths: [Float]
        let image: Data
        let type: String
        
    }
    var image:UIImage!
    override func viewDidLoad(){
        super.viewDidLoad()
        drawPreview()
        areaLabel.text = "Area: \((area*10000).rounded()/10000)m2"
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        scrollView.alwaysBounceVertical = true
        scrollView.isScrollEnabled = true

        UIGraphicsBeginImageContextWithOptions(CGSize(380,388), false, 0);
        self.view.drawHierarchy(in: CGRect(5,-107,view.bounds.size.width,view.bounds.size.height), afterScreenUpdates: true)
        image = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        ImageView.image = image
//        print("dgsdshs",UIImagePNGRepresentation(image))
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return PreviewBoard
    }
    
    @IBAction func saveData(_ sender: UIButton) {
        self.callPost(url: URL(string: "https://rular-server.mcang.ml/shape/add")!, params: [
            "username": "5b5e92473d3d555ef0a4a320", "coordinates": coordinates, "name": "dasda", "area": area, "perimeter": 23, "lengths": lengths, "image": UIImagePNGRepresentation(image)!, "type": "Floor"
            ], finish: finishPost)
    }
    
    func finishPost (message:String, data:Data?) -> Void
    {
        do
        {
            if let jsonData = data
            {
                let parsedData = try JSONDecoder().decode(Model.self, from: jsonData)
                print(parsedData)
            }
        }
        catch
        {
            print("Parse Error: \(error)")
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
        
        path.move(to: CGPoint(x: (Int(((coordinates[0].x - minX!) * 320 / maxX).rounded())), y: Int(((coordinates[0].z - minY!) * 320 / maxY).rounded())))
        
        var centerCoor: CGPoint
        var centerXText: Float
        var centerYText: Float
        
        centerXText = (((coordinates[0].x - minX!) + (coordinates[1].x - minX!))) * 320
        centerYText = (((coordinates[0].z - minY!) + (coordinates[1].z - minY!))) * 320
        
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
            print("x: \((Int(((coordinate.x - minX!) * 320 / maxX).rounded()))), y: \((Int(((coordinate.z - minY!) * 320 / maxY).rounded())))")
            path.addLine(to: CGPoint(x: (Int(((coordinate.x - minX!) * 320 / maxX).rounded())), y: (Int(((coordinate.z - minY!) * 320 / maxY).rounded()))))
            
            if coordinates.count > 2 && index > 1 {
                
                centerXText = (((coordinate.x - minX!) + (coordinates[index-1].x - minX!))) * 320
                centerYText = (((coordinate.z - minY!) + (coordinates[index-1].z - minY!))) * 320
                
                centerCoor = CGPoint(x: Int((centerXText / maxX)+50)/2, y: Int((centerYText / maxY)+8)/2)
                
                let myTextLayer = CATextLayer()
                myTextLayer.string = "\((lengths[index-1]*100).rounded()/100)m"
                myTextLayer.foregroundColor = UIColor.black.cgColor
                myTextLayer.frame = CGRect(x:0.0,y:0.0,width:100,height:16)
                myTextLayer.position = centerCoor
                myTextLayer.fontSize = 16.0
                PreviewBoard.layer.addSublayer(myTextLayer)
            }
            
            if index == coordinates.count-1 {
                centerXText = (((coordinates[0].x - minX!) + (coordinates[coordinates.count-1].x - minX!))) * 320
                centerYText = (((coordinates[0].z - minY!) + (coordinates[coordinates.count-1].z - minY!))) * 320
                
                centerCoor = CGPoint(x: Int((centerXText / maxX)+50)/2, y: Int((centerYText / maxY)+8)/2)
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
    func getPostString(params:[String:Any]) -> String
    {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    
    func callPost(url:URL, params:[String:Any], finish: @escaping ((message:String, data:Data?)) -> Void)
    {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let postString = self.getPostString(params: params)
        request.httpBody = postString.data(using: .utf8)
        
        request.setValue("multipart/form-data", forHTTPHeaderField: "content-type")
        
        var result:(message:String, data:Data?) = (message: "Fail", data: nil)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if(error != nil)
            {
                result.message = "Fail Error not null : \(error.debugDescription)"
            }
            else
            {
                result.message = "Success"
                result.data = data
            }
            
            finish(result)
        }
        task.resume()
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
//            print("Ini data stringnya", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
            
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

extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }
    
}
extension CGSize{
    init(_ width:CGFloat,_ height:CGFloat) {
        self.init(width:width,height:height)
    }
}
extension CGPoint{
    init(_ x:CGFloat,_ y:CGFloat) {
        self.init(x:x,y:y)
    }
}
