//
//  NSNotification.Name+extension.swift
//  Messanger
//
//  Created by Илья on 3/22/19.
//  Copyright © 2019 Илья. All rights reserved.
//

import Foundation

extension NSNotification.Name{
    static let NewUserJoinedChat = NSNotification.Name("NewUserJoinedChat")
    static let UserLeftChat = NSNotification.Name("UserLeftChat")
    static let StartUserAmount = NSNotification.Name("StartUserAmount")
}
