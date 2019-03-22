//
//  UIView+extension.swift
//  Messanger
//
//  Created by Илья on 3/22/19.
//  Copyright © 2019 Илья. All rights reserved.
//

import UIKit

extension UIImageView{
    func setRounded(){
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
    }
}
