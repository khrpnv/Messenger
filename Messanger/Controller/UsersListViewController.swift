//
//  UsersListViewController.swift
//  Messanger
//
//  Created by Илья on 3/22/19.
//  Copyright © 2019 Илья. All rights reserved.
//

import UIKit
import MessageKit

class UsersListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var chatService: ChatService?
    var isDarkModeOn: Bool = false
    
    private var dataSource: [User] = []{
        didSet{
            tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupObservers()
        setupDataSource()
    }
    
    //MARK: - Setup methods
    func setupDelegates(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(updateUsersList), name: .NewUserJoinedChat, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateUsersList), name: .UserLeftChat, object: nil)
    }
    
    func setupDataSource(){
        dataSource = chatService?.getCurrentUsers() ?? []
    }

}

//MARK: - Table view configuration
extension UsersListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserTableViewCell else {
            fatalError("Error: Cell doesn`t exist")
        }
        cell.updateCell(user: dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

//MARK: - Notifications
extension UsersListViewController{
    
    @objc private func updateUsersList(){
        setupDataSource()
    }
    
}
