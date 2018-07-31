//
//  UserInputController.swift
//  RulAR
//
//  Created by Violerine on 27/07/18.
//  Copyright © 2018 Michael Cangcianno. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

//let session = URLSession(configuration: .ephemeral)
//let task = session.dataTask(with: URL(string: "https://rular-server.mcang.ml/user/add")!)
//
//var request = URLRequest(url: task)


struct UserIn: Decodable{
    let _id: String
    let username : String
}

extension SCNVector3: Codable {
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.init()
        self.x = try container.decode(Float.self)
        self.y = try container.decode(Float.self)
        self.z = try container.decode(Float.self)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(self.x)
        try container.encode(self.y)
        try container.encode(self.z)
    }
}

var labelStatus = false

var stringData = ""

class UserInputController : UIViewController{
    
    
    var usernameTextValue : String!
    var label = UILabel()

    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
    
        
        print("USERNAME in localstorage : ",UserDefaults.standard.string(forKey: "username") ?? "ga ada")
        print("STATUS USER", UserDefaults.standard.bool(forKey: "userLogged"))
    
        if UserDefaults.standard.bool(forKey: "userLogged") == true {
            //user is already logged in just navigate him to home screen
            let homeVc = self.storyboard?.instantiateViewController(withIdentifier: "HomeId") as! HomeController
            self.navigationController?.pushViewController(homeVc, animated: false)
        }
    }
    
    @IBOutlet weak var inputUsername: UITextField!
    
    @IBAction func userInputChange(_ sender: UITextField) {
        usernameTextValue = sender.text!
    }
    
    struct User: Codable{
        let username: String
    }
    
 
    func submitPost(post: User,completion:((Error?) -> Void)?) {

        guard let url = URL(string: "https://rular-server.mcang.ml/user/add") else { fatalError("Could not create URL from components") }
        print(url)
        
        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
    
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(post)
            // ... and set our request's HTTP body
            request.httpBody = jsonData
            print("Ini data stringnya", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        } catch {
            completion?(error)
        }

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                completion?(responseError!)
                return
            }
            let data = responseData
            
            do{
                let currentUser = try JSONDecoder().decode(UserIn.self, from: data!)
                print("DAPET GAA INI",currentUser._id)
                UserDefaults.standard.set(currentUser._id,forKey:"currentUserId")
            }catch let jsonErr {
                print("Erroor",jsonErr)
                print("response", response!)
            }

//            if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
//
//                print("PRINT RESPONSE ", utf8Representation)
//
//            } else {
//                print("no readable data received in response")
//            }
        }
        task.resume()
    }
    
    
    
    @IBAction func submitUsername(_ sender: UIButton) {
    

        
        if usernameTextValue == nil{
            label.frame = CGRect(x: 0, y: 550, width: self.view.frame.width, height: 120)
            label.text = "Username can not be empty "
            label.textAlignment = .center
            label.textColor = UIColor.black
//            label.backgroundColor = UIColor.darkGray
            label.font = UIFont(name: "Cooperplate-Bold", size: 22)
            self.view.addSubview(label)
            
        }else{
            let myPost = User(username: usernameTextValue)
            
            submitPost(post: myPost) { (error) in
                
                if let error = error {
                    fatalError(error.localizedDescription)
                }
            }
            let homeVc = self.storyboard?.instantiateViewController(withIdentifier: "HomeId") as! HomeController
            self.navigationController?.pushViewController(homeVc, animated: true)
            
            UserDefaults.standard.set(usernameTextValue, forKey: "username")
            UserDefaults.standard.set(true, forKey: "userLogged")
        }
        
        
    }
    
}
