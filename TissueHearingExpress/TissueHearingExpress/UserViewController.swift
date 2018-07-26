//
//  UserViewController.swift
//  TissueHearingExpress
//
//  Created by Jenny Wu on 10/7/18.
//  Copyright © 2018 Jenny Wu. All rights reserved.
//

import UIKit


class UserViewController: UIViewController {
    var age: Int = 0
    var name: String = ""
    var gender: Int = 0
    var type: Int = 0
    
    @IBOutlet weak var inputName: UITextField!
    @IBOutlet weak var inputAge: UITextField!
    @IBOutlet weak var inputGender: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.title == "檢測資料" {
            name = "我的檢測資料"
            type = 0
        } else if self.title == "聽力圖資料"{
            name = "我的聽力圖資料"
            type = 1
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        inputAge.keyboardType = UIKeyboardType.numberPad
        
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createUser(_ sender: UIButton) {        
        if inputAge.text != "" {
            age = Int(inputAge.text!)!
        }
        
        if inputName.text != "" {
                name = inputName.text!
        }
        
        let user = User(name: name, age: age, gender: gender, type: type)
        user.tempSaveUser()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
