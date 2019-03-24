//
//  UserTableViewCell.swift
//  Messanger
//
//  Created by Илья on 3/22/19.
//  Copyright © 2019 Илья. All rights reserved.
//

import UIKit
import LetterAvatarKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet private weak var ibUserAvatarView: UIImageView!
    @IBOutlet private weak var ibUserFullNameLabel: UILabel!
    
    var textLabelColor: UIColor?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func updateCell(user: User){
        ibUserAvatarView.setRounded()
        ibUserAvatarView.backgroundColor = user.color
        ibUserAvatarView.image = UIImage.makeLetterAvatar(withUsername: user.name)
        ibUserFullNameLabel.text = user.name
        ibUserFullNameLabel.textColor = textLabelColor
    }

}
