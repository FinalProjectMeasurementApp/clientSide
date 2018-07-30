//
//  InputController.swift
//  RulAR
//
//  Created by Violerine on 26/07/18.
//  Copyright © 2018 Michael Cangcianno. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

struct User: Codable {
    let username: String
}



class InputController : UIViewController{

    override func viewDidLoad() {
//        let imageView = UIImageView(image: UIImage(named: "grid.png"))
//        imageView.frame = view.bounds
//        imageView.contentMode = UIViewContentMode.scaleAspectFill
//        view.addSubview(imageView)
//        
//        let shape = CAShapeLayer()
//        view.layer.addSublayer(shape)
//        shape.opacity = 0.5
//        shape.lineWidth = 2
//        shape.lineJoin = kCALineJoinMiter
//        shape.strokeColor = UIColor(hue: 0.786, saturation: 0.79, brightness: 0.53, alpha: 1.0).cgColor
//        shape.fillColor = UIColor(hue: 0.786, saturation: 0.15, brightness: 0.89, alpha: 1.0).cgColor
//        
//        let path = UIBezierPath()
//        path.move(to: CGPoint(x: 120, y: 20))
//        path.addLine(to: CGPoint(x: 230, y: 90))
//        path.addLine(to: CGPoint(x: 240, y: 250))
//        path.addLine(to: CGPoint(x: 40, y: 280))
//        path.addLine(to: CGPoint(x: 100, y: 150))
//        path.close()
//        shape.path = path.cgPath
//        
//        
//                            var myTextLayer = CATextLayer()
//                            myTextLayer.string = "My text"
//                            myTextLayer.foregroundColor = UIColor.black.cgColor
//                                 myTextLayer.frame = imageView.bounds
//        myTextLayer.position = CGPoint(x:200,y: 400)
//                    print(myTextLayer.frame)
//                            imageView.layer.addSublayer(myTextLayer)
    }
    
    let postUser = User(username: "testing")
    
    var textValue : String!
    
    @IBOutlet weak var nameInput: UITextField!
//
    @IBAction func inputChanged(_ sender: UITextField) {
        print(sender.text!)
        textValue = sender.text!
        print("TEXT VALUE INPUT",textValue)
    }

    @IBAction func submitButton(_ sender: Any) {
        
        print("DAPET TEXT VALUENYA GA",textValue)
        print("button di pencet")
    }
}
