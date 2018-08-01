//
//  FloorPlanController.swift
//  RulAR
//
//  Created by Violerine on 28/07/18.
//  Copyright © 2018 Michael Cangcianno. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

class WallPlanController : UIViewController, UIScrollViewDelegate{
    var shape : CAShapeLayer!
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(newWidth, newHeight))
        image.draw(in: CGRect(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    let button = UIButton()
    let label = UILabel()
    let labelInfo = UILabel()
    var coordinatesonArray = UserDefaults.standard.array(forKey: "coordinates") as? [Array<Any>]
    var coordinates : [SCNVector3]!
    @IBOutlet weak var PreviewScroll: UIScrollView!
    
    @IBOutlet weak var PreviewBoard: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PreviewScroll.delegate = self
        PreviewScroll.minimumZoomScale = 1.0
        PreviewScroll.maximumZoomScale = 10.0
        PreviewScroll.alwaysBounceVertical = true
        PreviewScroll.isScrollEnabled = true
        coordinates = []
        for coordinate in coordinatesonArray! {
            coordinates.append(SCNVector3Make(coordinate[0] as! Float,coordinate[1] as! Float,coordinate[2] as! Float))
        }
        drawPreview()
    }
    
    func drawPreview(){
        let minX = coordinates.min { a, b in a.x < b.x }?.x
        let minY = coordinates.min { a, b in a.y < b.y }?.y
        let maxX = (coordinates.max { a, b in a.x < b.x }?.x)! - minX!
        let maxY = (coordinates.max { a, b in a.y < b.y }?.y)! - minY!
        
        PreviewBoard.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        shape = CAShapeLayer()
        PreviewBoard.layer.addSublayer(shape)
        shape.opacity = 0.5
        shape.lineWidth = 4
        shape.lineJoin = kCALineJoinMiter
        shape.strokeColor = UIColor.gray.cgColor
        shape.fillColor = UIColor(hue: 0, saturation: 0, brightness: 0.7, alpha: 1).cgColor
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: (Int(((coordinates[0].x - minX!) * 128 / maxX).rounded())), y: Int(((coordinates[0].y - minY!) * 128 / maxY).rounded())))
        
        
        
        for coordinate in coordinates {
            print("x: \((Int(((coordinate.x - minX!) * 128 / maxX).rounded()))), y: \((Int(((coordinate.y - minY!) * 128 / maxY).rounded())))")
            path.addLine(to: CGPoint(x: (Int(((coordinate.x - minX!) * 128 / maxX).rounded())), y: (Int(((coordinate.y - minY!) * 128 / maxY).rounded()))))
            
        }
        path.close()
        shape.path = path.cgPath
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return PreviewBoard
    }
    
    @IBAction func wallpaperButton(_ sender: Any) {
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
            let areaNow = UserDefaults.standard.integer(forKey:"currentArea")
            let totalPrice = Float(areaNow * 1 * 100000)
            let totalPriceString = String(totalPrice)
            labelInfo.text = "Size per block : 1 x 1 m\nPrice per block : Rp. 100.000,00\nPrice by measurement : " + totalPriceString
            labelInfo.textColor = UIColor.black
            labelInfo.font = UIFont(name: "Cooperplate-Bold", size: 22)
            labelInfo.lineBreakMode = .byWordWrapping
            labelInfo.numberOfLines = 4
            self.view.addSubview(labelInfo)
            self.view.addSubview(label)
            let image = self.resizeImage(image: UIImage(named: "wallpaper.png")!, newWidth: 10)
            self.shape.fillColor = UIColor(patternImage: image).cgColor
            print("SELECTED tile button")
        }
        print(button.isSelected)
    }
    
    @IBAction func paintButton(_ sender: Any) {
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
            let areaNow = UserDefaults.standard.integer(forKey:"currentArea")
            let totalPrice = Float(areaNow * 25 * 30000)
            let totalPriceString = String(totalPrice)
            labelInfo.text = "Size per block : 1 x 1 m\nPrice per block : Rp. 30.000,00\nPrice by measurement : " + totalPriceString
            labelInfo.textColor = UIColor.black
            labelInfo.font = UIFont(name: "Cooperplate-Bold", size: 22)
            labelInfo.lineBreakMode = .byWordWrapping
            labelInfo.numberOfLines = 4
            self.view.addSubview(labelInfo)
            self.view.addSubview(label)
            let image = self.resizeImage(image: UIImage(named: "paint.png")!, newWidth: 10)
            self.shape.fillColor = UIColor(patternImage: image).cgColor
            print("STONE BUTTON IS SELECTED")
        }
    }
    
    @IBAction func brickButton(_ sender: Any) {
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
            let areaNow = UserDefaults.standard.integer(forKey:"currentArea")
            let totalPrice = Float(areaNow * 1 * 200000)
            let totalPriceString = String(totalPrice)
            labelInfo.text = "Size per block : 1 x 1 m\nPrice per block : Rp. 200.000,00\nPrice by measurement : " + totalPriceString
            labelInfo.textColor = UIColor.black
            labelInfo.font = UIFont(name: "Cooperplate-Bold", size: 22)
            labelInfo.lineBreakMode = .byWordWrapping
            labelInfo.numberOfLines = 4
            self.view.addSubview(labelInfo)
            self.view.addSubview(label)
            let image = self.resizeImage(image: UIImage(named: "brick.png")!, newWidth: 10)
            self.shape.fillColor = UIColor(patternImage: image).cgColor
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
