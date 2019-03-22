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

    @IBOutlet private weak var ibNavigationBarTitles: UINavigationItem!
    
    private var messages: [Message] = []
    private var user: User?
    private var chatService: ChatService?
    private var textColor: UIColor = .black
    var userName: String?
    var isDarkMode: Bool = false
    private var onlineUsersAmount: Int?{
        didSet{
            setTitles(onlineUsers: onlineUsersAmount ?? 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupUser()
        setupChatService()
        setupChatUI()
        setupObservers()
        setTitles(onlineUsers: 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent{
            chatService?.disconnect()
        }
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
    
    private func setupObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(updateUsersAmount), name: .NewUserJoinedChat, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateUsersAmount), name: .UserLeftChat, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateUsersAmount), name: .StartUserAmount, object: nil)
    }
    
    private func setTitles(onlineUsers: Int){
        var titleColor: UIColor = .black
        var subtitleColor: UIColor = .gray
        var messageText = "users"
        if isDarkMode {
            titleColor = .white
            subtitleColor = .lightGray
        }
        if onlineUsers == 1 {
            messageText = "user"
        }
        ibNavigationBarTitles.setTitle("Chat", subtitle: "\(onlineUsers) \(messageText) online", titleColor: titleColor, subtitleColor: subtitleColor)
    }
    
    private func setupDarkModeUI(){
        messagesCollectionView.backgroundColor = #colorLiteral(red: 0.2407439053, green: 0.3631132841, blue: 0.5904530287, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1316523552, green: 0.2483583391, blue: 0.4827849269, alpha: 1)
        self.navigationController?.navigationBar.barStyle = .black
        self.messageInputBar.backgroundView.backgroundColor = #colorLiteral(red: 0.1316523552, green: 0.2483583391, blue: 0.4827849269, alpha: 1)
        self.messageInputBar.inputTextView.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
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
        avatarView.image = UIImage.makeLetterAvatar(withUsername: message.sender.displayName)
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

//MARK: - Notifications
extension ChatViewController{
    
    @objc func updateUsersAmount(){
        onlineUsersAmount = chatService?.getAmountOfOnlineUsers() ?? 0
    }
    
}
