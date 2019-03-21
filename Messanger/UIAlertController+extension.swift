//
//  UIAlertController+extension.swift
//  Messanger
//
//  Created by Илья on 3/22/19.
//  Copyright © 2019 Илья. All rights reserved.
//

import UIKit

extension UIAlertController{
    static func presentNoInternetAlertMessage() -> UIAlertController{
        let alert = UIAlertController(title: "Internet Connection", message: "Your device is not connected to the Internet. Turn on cellular data or use Wi-Fi to access data.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        return alert
    }
}
