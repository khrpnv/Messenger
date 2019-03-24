//
//  ProfileViewController.swift
//  Messanger
//
//  Created by Илья on 3/21/19.
//  Copyright © 2019 Илья. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, LocalAccountProtocol {
    
    @IBOutlet private weak var ibUserPasswordTextField: UITextField!
    @IBOutlet private weak var ibUserNameTextField: UITextField!
    @IBOutlet private weak var ibDarkModeSwicth: UISwitch!
    @IBOutlet private weak var ibDarkModeLabel: UILabel!
    @IBOutlet private weak var ibNavigationBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ibUserNameTextField.delegate = self
        DataManager.instance.getUserDataFromFile()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? ChatViewController, segue.identifier == "startChating"{
            let userNameText = ibUserNameTextField.text ?? "Default Name"
            destVC.userName = userNameText
            destVC.isDarkMode = ibDarkModeSwicth.isOn
        }
        if let destVC = segue.destination as? LocalAccountsViewController, segue.identifier == "localAccountsInfo"{
            destVC.dataSource = DataManager.instance.logins
            destVC.delegate = self
            destVC.isDarkMode = ibDarkModeSwicth.isOn
        }
    }
    
    @IBAction private func logInButtonPressed(_ sender: Any) {
        let userName = ibUserNameTextField.text ?? ""
        if userName.isEmpty{
            ibUserNameTextField.layer.borderWidth = 1
            ibUserNameTextField.layer.cornerRadius = 5
            ibUserNameTextField.layer.borderColor = UIColor.red.cgColor
            return
        } else if !checkInternetConnection(){
            return
        } else if checkLogInData(){
            performSegue(withIdentifier: "startChating", sender: nil)
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        let userName = ibUserNameTextField.text ?? ""
        let password = ibUserPasswordTextField.text ?? ""
        if userName.isEmpty{
            ibUserNameTextField.alertTextFieldStyle()
            return
        } else if password.isEmpty{
            ibUserPasswordTextField.alertTextFieldStyle()
            return
        } else if !checkInternetConnection(){
            return
        } else if DataManager.instance.logins.count == 5{
            return
        } else {
            DataManager.instance.addNewAccount(login: userName, password: password)
            performSegue(withIdentifier: "startChating", sender: nil)
        }
    }
    
    func accountSelected(accountName: String) {
        ibUserNameTextField.text = accountName
        ibUserPasswordTextField.text = nil
    }

    @IBAction private func darkModeSwitchPressed(_ sender: Any) {
        if ibDarkModeSwicth.isOn{
            setupDarkModeUI()
        } else {
            setupLightModeUI()
        }
    }
    
    private func setupDarkModeUI(){
        view.backgroundColor = #colorLiteral(red: 0.1141847298, green: 0.2072634995, blue: 0.4036407769, alpha: 1)
        ibDarkModeLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        ibUserNameTextField.darkModeStyle(placeholder: "Full name")
        ibUserPasswordTextField.darkModeStyle(placeholder: "Password")
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1316523552, green: 0.2483583391, blue: 0.4827849269, alpha: 1)
        self.navigationController?.navigationBar.barStyle = .black
    }
    
    private func setupLightModeUI(){
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        ibDarkModeLabel.textColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        ibUserNameTextField.lightModeStyle(placeholder: "Full name")
        ibUserPasswordTextField.lightModeStyle(placeholder: "Password")
        self.navigationController?.navigationBar.barTintColor = nil
        self.navigationController?.navigationBar.barStyle = .default
    }
    
    private func checkInternetConnection() -> Bool{
        if InternetConnection.isConnectedToNetwork(){
            return true
        } else {
            self.present(UIAlertController.presentNoInternetAlertMessage(), animated: true, completion: nil)
            return false
        }
    }
    
    private func checkLogInData() -> Bool{
        let inputtedLogin = ibUserNameTextField.text ?? ""
        let inputtedPassword = ibUserPasswordTextField.text ?? ""
        if DataManager.instance.logins.contains(inputtedLogin){
            if inputtedPassword == DataManager.instance.passwords[DataManager.instance.logins.firstIndex(of: inputtedLogin) ?? 0]{
                return true
            }
        }
        return false
    }
}

extension ProfileViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
