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
    private var currentUsers: [ScaledroneMember] = []
    
    init(member: User, onRecievedMessage: @escaping (Message)-> Void) {
        self.messageCallback = onRecievedMessage
        self.scaledrone = Scaledrone(
            channelID: "yDjBvdCIONUKsTAQ",
            data: member.toJSON)
        scaledrone.delegate = self
    }
    
    func connect() {
        scaledrone.connect()
    }
    
    func disconnect(){
        scaledrone.disconnect()
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
        room?.observableDelegate = self
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

//MARK: - Observable room delegate
extension ChatService: ScaledroneObservableRoomDelegate{
    
    func scaledroneObservableRoomDidConnect(room: ScaledroneRoom, members: [ScaledroneMember]) {
        currentUsers = members
        NotificationCenter.default.post(name: .StartUserAmount, object: nil)
    }
    
    func scaledroneObservableRoomMemberDidJoin(room: ScaledroneRoom, member: ScaledroneMember) {
        newUserJoined(member: member)
    }
    
    func scaledroneObservableRoomMemberDidLeave(room: ScaledroneRoom, member: ScaledroneMember) {
        userLeftChat(member: member)
    }
    
    
}

//MARK: - Methods for getting current users` list
extension ChatService{
    
    //MARK: - Storage methods
    private func newUserJoined(member: ScaledroneMember){
        currentUsers.append(member)
        NotificationCenter.default.post(name: .NewUserJoinedChat, object: nil)
    }
    
    private func userLeftChat(member: ScaledroneMember){
        var index = 0
        for currentMember in currentUsers{
            if currentMember.id == member.id{
                break
            } else {
                index+=1
            }
        }
        currentUsers.remove(at: index)
        NotificationCenter.default.post(name: .UserLeftChat, object: nil)
    }
    
    //MARK: - Public methods
    func getCurrentUsers() -> [User]{
        var usersList:[User] = []
        for currentUser in currentUsers{
            if let user = User(fromJSON: currentUser.clientData as Any){
                usersList.append(user)
            }
        }
        return usersList
    }
    
    func getAmountOfOnlineUsers() -> Int{
        return currentUsers.count
    }
    
}
