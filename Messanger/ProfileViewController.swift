//
//  ProfileViewController.swift
//  Messanger
//
//  Created by Илья on 3/21/19.
//  Copyright © 2019 Илья. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet private weak var ibUserNameTextField: UITextField!
    @IBOutlet private weak var ibDarkModeSwicth: UISwitch!
    @IBOutlet private weak var ibDarkModeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ibUserNameTextField.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? ChatViewController, segue.identifier == "startChating"{
            let userNameText = ibUserNameTextField.text ?? "Default Name"
            destVC.userName = userNameText
            destVC.isDarkMode = ibDarkModeSwicth.isOn
        }
    }
    
    @IBAction private func enterChatButtonPressed(_ sender: Any) {
        let userName = ibUserNameTextField.text ?? ""
        if userName.isEmpty{
            ibUserNameTextField.layer.borderWidth = 1
            ibUserNameTextField.layer.cornerRadius = 5
            ibUserNameTextField.layer.borderColor = UIColor.red.cgColor
            return
        } else if !checkInternetConnection(){
            return
        } else {
            performSegue(withIdentifier: "startChating", sender: nil)
        }
    }
    
    @IBAction private func darkModeSwitchPressed(_ sender: Any) {
        if ibDarkModeSwicth.isOn{
            setupDarkModeUI()
        } else {
            setupLightModeUI()
        }
    }
    
    private func setupDarkModeUI(){
        view.backgroundColor = #colorLiteral(red: 0.2407439053, green: 0.3631132841, blue: 0.5904530287, alpha: 1)
        ibDarkModeLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        ibUserNameTextField.backgroundColor = #colorLiteral(red: 0.1141847298, green: 0.2072634995, blue: 0.4036407769, alpha: 1)
        ibUserNameTextField.attributedPlaceholder = NSAttributedString(string: "Full name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        ibUserNameTextField.textColor = UIColor.white
    }
    
    private func setupLightModeUI(){
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        ibDarkModeLabel.textColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        ibUserNameTextField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        ibUserNameTextField.attributedPlaceholder = NSAttributedString(string: "Full name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        ibUserNameTextField.textColor = UIColor.black
    }
    
    private func checkInternetConnection() -> Bool{
        if InternetConnection.isConnectedToNetwork(){
            return true
        } else {
            self.present(UIAlertController.presentNoInternetAlertMessage(), animated: true, completion: nil)
            return false
        }
    }
}

extension ProfileViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
