//
//  User.swift
//  TissueHearingExpress
//
//  Created by Jenny Wu on 10/7/18.
//  Copyright © 2018 Jenny Wu. All rights reserved.
//

import UIKit

class User: NSObject, Codable {
    var uName: String
    var uAge: Int
    var uGender: Int
    var uTime: String
    var uLeftResults = [Int: Int]()
    var uRightResults = [Int: Int]()
    var uType = 0
    var uLeftCoordinates = [Int: CGPoint]()
    var uRightCoordinates = [Int: CGPoint]()
    
    init(name: String, age: Int, gender: Int, type: Int) {
        uName = name
        uAge = age
        uGender = gender
        uType = type
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        uTime = String(result)
        
        print(uName, uAge, uGender, uTime)
    }
    
    func getName() -> String {
        return uName
    }
    
    func getAge() -> Int {
        return uAge
    }
    
    func getGender() -> Int {
        return uGender
    }
    
    func getTime() -> String {
        return uTime
    }
    
    func getType() -> Int {
        return uType
    }
    
    func getLeftCoordinates() -> [Int: CGPoint] {
        return uLeftCoordinates
    }
    
    func getRightCoordinates() -> [Int: CGPoint] {
        return uRightCoordinates
    }
    
    func getLeftResults() -> [Int: Int] {
        return uLeftResults
    }
    
    func getRightResults() -> [Int: Int] {
        return uRightResults
    }
    
    func writeLeftCoordinates(coordinates: [Int: CGPoint]) {
        uLeftCoordinates = coordinates
    }
    
    func writeRightCoordinates(coordinates: [Int: CGPoint]) {
        uRightCoordinates = coordinates
    }
    
    func writeLeftResults(results: [Int: Int]) {
        let save = [Int : Int](uniqueKeysWithValues: results.sorted{ $0.key < $1.key })
        uLeftResults = save
    }
    
    func writeRightResults(results: [Int: Int]) {
        let save = [Int : Int](uniqueKeysWithValues: results.sorted{ $0.key < $1.key })
        uRightResults = save
    }
    
    func checkCoordinates() -> Bool {
        if uLeftCoordinates == [:] || uRightCoordinates == [:] {
            return false
        }
        return true
    }
    
    func checkData() -> Bool {
        if uLeftResults == [:] || uRightResults == [:] {
            return false
        }
        return true
    }
    
    func tempSaveUser() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(self) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "tempUser")
            print("Saved temp user successfully")
        } else {
            print("Failed to save temp user")
        }
    }
    
}
