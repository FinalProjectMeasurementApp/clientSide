
import Foundation
import UIKit
import SceneKit
//struct Course{
//    let id: Int
//    let name: String
//    let link: String
//    let imageUrl: String
//    let number_of_lessons: Int
//}

struct Collection: Decodable{
    let _id: String
    let name: String
    let area: Int
    let perimeter: Int
    let coordinates:[String]
    let createdAt: String
    let updatedAt: String
}

class CollectionController : UIViewController{
    override func viewDidLoad() {
        print("MUNCUL GA DISINI")
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        let jsonUrl = "http://localhost:8000/shape/"
        guard let url = URL(string: jsonUrl) else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do{
                print("masuk do ga")
                let shape = try
                    JSONDecoder().decode([
                        Collection].self, from: data)
                print("shape nameeeeee ",shape)
                
            }catch let jsonErr {
                print("Erroor",jsonErr)
                print("response", response!)
            }
            
            }.resume()
    }
    
    @IBAction func triggerNavigate(_ sender: Any) {
        let inputVc = self.storyboard?.instantiateViewController(withIdentifier: "inputModel") as! InputController
        self.navigationController?.pushViewController(inputVc, animated: true)
    }
    
}

