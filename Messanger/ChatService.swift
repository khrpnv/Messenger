//
//  ChatService.swift
//  Messanger
//
//  Created by Илья on 3/21/19.
//  Copyright © 2019 Илья. All rights reserved.
//

import Foundation
import Scaledrone

class ChatService{
    private let scaledrone: Scaledrone
    private let messageCallback: (Message)-> Void
    
    private var room: ScaledroneRoom?
    
    init(member: User, onRecievedMessage: @escaping (Message)-> Void) {
        self.messageCallback = onRecievedMessage
        self.scaledrone = Scaledrone(
            channelID: "VZ0bRmvuqInf4FAr",
            data: member.toJSON)
        scaledrone.delegate = self
    }
    
    func connect() {
        scaledrone.connect()
    }
    
    func sendMessage(message:String){
        room?.publish(message: message)
    }
}

//MARK: - Scaledrone delegate
extension ChatService: ScaledroneDelegate{
    func scaledroneDidConnect(scaledrone: Scaledrone, error: NSError?) {
        room = scaledrone.subscribe(roomName: "observable-room")
        room?.delegate = self
    }
    
    func scaledroneDidReceiveError(scaledrone: Scaledrone, error: NSError?) {
        print("Scaledrone error", error ?? "")
    }
    
    func scaledroneDidDisconnect(scaledrone: Scaledrone, error: NSError?) {
        print("Scaledrone disconnected", error ?? "")
    }
}

//MARK: - Room delegate
extension ChatService: ScaledroneRoomDelegate{
    func scaledroneRoomDidConnect(room: ScaledroneRoom, error: NSError?) {
        debugPrint("Connected to room!")
    }
    
    func scaledroneRoomDidReceiveMessage(room: ScaledroneRoom, message: Any, member: ScaledroneMember?) {
        guard let text = message as? String, let memberData = member?.clientData, let member = User(fromJSON: memberData) else {
            return
        }
        let message = Message(user: member, messageText: text, messageID: UUID().uuidString)
        messageCallback(message)
    }
}
