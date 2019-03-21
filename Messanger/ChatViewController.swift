//
//  ChatViewController.swift
//  Messanger
//
//  Created by Илья on 3/21/19.
//  Copyright © 2019 Илья. All rights reserved.
//

import UIKit
import MessageKit
import MessageInputBar
import LetterAvatarKit

class ChatViewController: MessagesViewController {

    private var messages: [Message] = []
    private var user: User?
    private var chatService: ChatService?
    private var textColor: UIColor = .black
    var userName: String?
    var isDarkMode: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupUser()
        setupChatService()
        setupChatUI()
    }
    
    //MARK: - Private methods
    private func setupDelegates(){
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
    
    private func setupUser(){
        user = User(name: userName ?? "DefaultName", color: .random)
    }
    
    private func setupChatService(){
        guard let currentUser = user else { return }
        chatService = ChatService(member: currentUser, onRecievedMessage: { [weak self] message in
            self?.messages.append(message)
            self?.messagesCollectionView.reloadData()
            self?.messagesCollectionView.scrollToBottom(animated: true)
        })
        chatService?.connect()
    }
    
    private func setupChatUI(){
        if isDarkMode {
            setupDarkModeUI()
            textColor = .white
        }
    }
    
    private func setupDarkModeUI(){
        messagesCollectionView.backgroundColor = #colorLiteral(red: 0.2407439053, green: 0.3631132841, blue: 0.5904530287, alpha: 1)
    }

}

//MARK: - Messages data source configuration
extension ChatViewController: MessagesDataSource{
    
    func currentSender() -> Sender {
        guard let currentUser = user else {
            fatalError("Error: User doesn't exist!")
        }
        return Sender(id: currentUser.name, displayName: currentUser.name)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let atributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: textColor]
        return NSAttributedString(string: message.sender.displayName, attributes: atributes)
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 12
    }
    
}

//MARK: - Messages layout configuration
extension ChatViewController: MessagesLayoutDelegate{
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
}

//MARK: - Messages display configuration
extension ChatViewController: MessagesDisplayDelegate{
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let message = messages[indexPath.section]
        let color = message.user.color
        avatarView.backgroundColor = color
    }
}

//MARK: - Input bar delegate
extension ChatViewController: MessageInputBarDelegate{
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        if !InternetConnection.isConnectedToNetwork(){
            self.present(UIAlertController.presentNoInternetAlertMessage(), animated: true, completion: nil)
            return
        }
        chatService!.sendMessage(message: text)
        inputBar.inputTextView.text = ""
    }
}
