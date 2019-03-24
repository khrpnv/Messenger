//
//  UITextField.swift
//  Messanger
//
//  Created by Илья on 3/23/19.
//  Copyright © 2019 Илья. All rights reserved.
//

import UIKit

extension UITextField{
    func darkModeStyle(placeholder: String){
        self.backgroundColor = #colorLiteral(red: 0.08464363962, green: 0.1582129598, blue: 0.3077071011, alpha: 1)
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        self.textColor = UIColor.white
    }
    
    func lightModeStyle(placeholder: String){
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        self.textColor = UIColor.black
    }
    
    func alertTextFieldStyle(){
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.red.cgColor
    }
}
