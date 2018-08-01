//
//  Media.swift
//  RulAR
//
//  Created by Justinus Amadia Wijaya on 31/07/18.
//  Copyright © 2018 Michael Cangcianno. All rights reserved.
//

import UIKit

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "kyleleeheadiconimage234567.jpg"
        
        guard let data = UIImageJPEGRepresentation(image, 0.7) else { return nil }
        self.data = data
    }
    
}
