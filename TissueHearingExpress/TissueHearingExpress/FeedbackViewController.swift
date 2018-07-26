//
//  FeedbackViewController.swift
//  TissueHearingExpress
//
//  Created by Jenny Wu on 10/7/18.
//  Copyright © 2018 Jenny Wu. All rights reserved.
//

import UIKit
import MessageUI

class FeedbackViewController: UIViewController {
    var enteredEmail: String!

    @IBOutlet weak var textField: UITextField!
    
    @IBAction func feedbackBtnTapped(_ sender: UIButton) {
        enteredEmail = textField.text?.lowercased()
        if !MFMailComposeViewController.canSendMail() {
            let ac = UIAlertController(title: "警告", message: "你的郵件帳號尚未設定，請先行至系統設定郵件帳號，再重試．", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "確定", style: .default))
            self.present(ac, animated: true)
            return
        }
        let composeVC = MFMailComposeViewController()
        
        // Configure the fields of the interface.
        composeVC.setToRecipients(["abchearing899@gmail.com"])
        composeVC.setSubject("天籟列車2020調適軟件 意見回饋")
        composeVC.setMessageBody("", isHTML: false)
        
        // Present the view controller modally.
        present(composeVC, animated: true)
    }
    
    func mailComposeController(controller: MFMailComposeViewController,
                               didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        textField.keyboardType = .emailAddress
        textField.clearButtonMode = .whileEditing
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
