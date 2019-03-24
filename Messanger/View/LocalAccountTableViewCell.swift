//
//  LocalAccountTableViewCell.swift
//  Messanger
//
//  Created by Илья on 3/24/19.
//  Copyright © 2019 Илья. All rights reserved.
//

import UIKit

class LocalAccountTableViewCell: UITableViewCell {

    @IBOutlet private weak var ibUserNameLabel: UILabel!
    var textLabelColor: UIColor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateCellInfo(name: String){
        ibUserNameLabel.text = name
        ibUserNameLabel.textColor = textLabelColor
    }

}
