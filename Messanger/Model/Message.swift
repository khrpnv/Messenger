//
//  Message.swift
//  Messanger
//
//  Created by Илья on 3/21/19.
//  Copyright © 2019 Илья. All rights reserved.
//

import Foundation
import UIKit
import MessageKit

struct Message{
    let user: User
    let messageText: String
    let messageID: String
}

// MARK: - Message extension
extension Message: MessageType{
    var sender: Sender {
        return Sender(id: user.name, displayName: user.name)
    }
    
    var messageId: String {
        return messageID
    }
    
    var sentDate: Date {
        return Date()
    }
    
    var kind: MessageKind {
        return .text(messageText)
    }
}
