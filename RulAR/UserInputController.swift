//
//  UserInputController.swift
//  RulAR
//
//  Created by Violerine on 27/07/18.
//  Copyright © 2018 Michael Cangcianno. All rights reserved.
//

import Foundation
import UIKit


//let session = URLSession(configuration: .ephemeral)
//let task = session.dataTask(with: URL(string: "http://localhost:8000/user/add")!)
//
//var request = URLRequest(url: task)

class UserInputController : UIViewController{
    
    
    var usernameTextValue : String!
    
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

        guard let url = URL(string: "http://localhost:8000/user/add") else { fatalError("Could not create URL from components") }
        print(url)
        
        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        // Make sure that we include headers specifying that our request's HTTP body
        // will be JSON encoded
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

            // APIs usually respond with the data you just sent in your POST request
            if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                print("PRINT RESPONSE ", utf8Representation)

            } else {
                print("no readable data received in response")
            }
        }
        task.resume()
    }
    
    
    
    @IBAction func submitUsername(_ sender: UIButton) {
        print("MASUK DISINI BUTTON")
        
        let myPost = User(username: usernameTextValue)
        
        
        submitPost(post: myPost) { (error) in

            if let error = error {
                fatalError(error.localizedDescription)
            }

            print("kalo ini berhasil")
        }
        let homeVc = self.storyboard?.instantiateViewController(withIdentifier: "HomeId") as! HomeController
        self.navigationController?.pushViewController(homeVc, animated: true)
        
        UserDefaults.standard.set(usernameTextValue, forKey: "username")
        UserDefaults.standard.set(true, forKey: "userLogged")
        
        print("button Triggered",usernameTextValue )
        
    }
    
}
