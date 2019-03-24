//
//  LocalAccountsViewController.swift
//  Messanger
//
//  Created by Илья on 3/24/19.
//  Copyright © 2019 Илья. All rights reserved.
//

import UIKit

class LocalAccountsViewController: UIViewController {

    var dataSource: [String] = []
    var cellData: String = ""
    var delegate: LocalAccountProtocol?
    var isDarkMode: Bool = false
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if isDarkMode{
            darkModeUI()
        } else {
            lightModeUI()
        }
    }
    
    private func darkModeUI(){
        tableView.backgroundColor = #colorLiteral(red: 0.1067128852, green: 0.1615819931, blue: 0.265824914, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1316523552, green: 0.2483583391, blue: 0.4827849269, alpha: 1)
        self.navigationController?.navigationBar.barStyle = .black
    }
    
    private func lightModeUI(){
        tableView.backgroundColor = nil
        self.navigationController?.navigationBar.barTintColor = nil
        self.navigationController?.navigationBar.barStyle = .default
    }

}

//MARK: - Table view configuration
extension LocalAccountsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "localAccountInfo", for: indexPath) as? LocalAccountTableViewCell else {
            fatalError("Error: Cell doesn`t exsit")
        }
        if isDarkMode {
            cell.textLabelColor = UIColor.white
        } else {
            cell.textLabelColor = UIColor.black
        }
        cell.updateCellInfo(name: dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellData = dataSource[indexPath.row]
        navigationController?.popViewController(animated: true)
        delegate?.accountSelected(accountName: cellData)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = tableView.backgroundColor
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            DataManager.instance.deleteAccount(at: indexPath.row)
            dataSource = DataManager.instance.logins
            tableView.reloadSections(IndexSet(integer: 0), with: .left)
        }
    }
    
}

