//
//  User.swift
//  Messanger
//
//  Created by Илья on 3/21/19.
//  Copyright © 2019 Илья. All rights reserved.
//

import UIKit

struct User{
    let name: String
    let color: UIColor
}

extension User {
    var toJSON: Any {
        return [
            "name": name,
            "color": color.hexString
        ]
    }
    
    init?(fromJSON json: Any) {
        guard
            let data = json as? [String: Any],
            let name = data["name"] as? String,
            let hexColor = data["color"] as? String
            else {
                print("Couldn't parse User")
                return nil
        }
        
        self.name = name
        self.color = UIColor(hex: hexColor)
    }
}
