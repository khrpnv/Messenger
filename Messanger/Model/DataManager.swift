//
//  DataManager.swift
//  Messanger
//
//  Created by Илья on 3/23/19.
//  Copyright © 2019 Илья. All rights reserved.
//

import Foundation
import SwiftyJSON

final class DataManager{
    
    static let instance = DataManager()
    private init(){}
    
    private let fileName = "Data"
    private var userInfo: JSON = JSON()
    var logins: [String] = []
    var passwords: [String] = []
    
    //Private methods
    private var DocumentDirURL:URL{
        let url = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return url
    }
    
    private func fileURL(fileName: String, fileExtension: String) -> URL{
        return DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
    }
    
    private func writeDataToFile(writeString: String, to fileName: String, fileExtension: String = "json"){
        let url = fileURL(fileName: fileName, fileExtension: fileExtension)
        do{
            try writeString.write(to: url, atomically: true, encoding: .utf8)
        } catch let error as NSError{
            print("Error: " + error.localizedDescription)
        }
    }
    
    private func readDataFromFile(from fileName: String, fileExtension: String = "json") -> String{
        var readString = ""
        let url = fileURL(fileName: fileName, fileExtension: fileExtension)
        do{
            readString = try String(contentsOf: url)
        } catch let error as NSError{
            print("Error: " + error.localizedDescription)
        }
        return readString
    }
    
    private func getDataFromFileIntoJSON(){
        let jsonString = readDataFromFile(from: fileName)
        userInfo = JSON(parseJSON: jsonString)
    }
    
    private func convertDataFromJsonIntoArray(key: String) -> [String]{
        var dataStorage: [String] = []
        for data in userInfo[key]{
            let userData = data.1.rawString() ?? ""
            dataStorage.append(userData)
        }
        return dataStorage
    }
    
    //Public methods
    func addNewAccount(login: String, password: String){
        logins.append(login)
        passwords.append(password)
        createJSONFile()
    }
    
    func deleteAccount(at index: Int){
        logins.remove(at: index)
        passwords.remove(at: index)
        createJSONFile()
    }
    
    func createJSONFile(){
        let jsonData: JSON = JSON(["logins": logins, "passwords": passwords])
        guard let jsonString = jsonData.rawString() else { return }
        writeDataToFile(writeString: jsonString, to: fileName)
    }
    
    func getUserDataFromFile(){
        getDataFromFileIntoJSON()
        logins = convertDataFromJsonIntoArray(key: "logins")
        passwords = convertDataFromJsonIntoArray(key: "passwords")
    }
    

}

