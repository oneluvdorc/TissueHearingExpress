//
//  FinalViewController.swift
//  TissueHearingExpress
//
//  Created by Jenny Wu on 13/7/18.
//  Copyright © 2018 Jenny Wu. All rights reserved.
//

import UIKit

class FinalViewController: UIViewController {

    var selectedUser: User?
    let dc = DetailTestViewController()
    var usersLi = Array<User>()
    let freqDict = [
        250: 26,
        500: 75,
        1000: 123,
        2000: 172,
        4000: 219,
        8000: 267
    ]
    let volDict = [
        10: 33,
        20: 74,
        30: 113,
        40: 155,
        50: 198,
        60: 238,
        70: 280,
        80: 320,
        90: 362
    ]

    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var left250: UIImageView!
    @IBOutlet weak var left500: UIImageView!
    @IBOutlet weak var left1000: UIImageView!
    @IBOutlet weak var left2000: UIImageView!
    @IBOutlet weak var left4000: UIImageView!
    @IBOutlet weak var left8000: UIImageView!
    
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var right250: UIImageView!
    @IBOutlet weak var right500: UIImageView!
    @IBOutlet weak var right1000: UIImageView!
    @IBOutlet weak var right2000: UIImageView!
    @IBOutlet weak var right4000: UIImageView!
    @IBOutlet weak var right8000: UIImageView!
    
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func infoShowTapped(_ sender: UIButton) {
        infoView.isHidden = false
    }
    
    @IBAction func infoLeaveTapped(_ sender: UIButton) {
        infoView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoView.isHidden = true
        let defaults = UserDefaults.standard
        if let savedTempUser = defaults.object(forKey: "tempUser") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                let tempUser = try jsonDecoder.decode(User.self, from: savedTempUser)
                if (tempUser.checkData()) {
                    setDotLocations(user: tempUser)
                    drawLines()
                }
                var usersLi = Array<User>()
                if let savedUsers = defaults.object(forKey: "users") as? Data {
                    do {
                        usersLi = try jsonDecoder.decode([User].self, from: savedUsers)
                        print("loaded users list")
                        usersLi.append(tempUser)
                    } catch { print("failed to load users list") }
                }
                let jsonEncoder = JSONEncoder()
                if let savedData = try? jsonEncoder.encode(usersLi) {
                    defaults.set(savedData, forKey: "users")
                    print("saved new user")
                    defaults.removeObject(forKey: "tempUser")
                } else { print("failed to save new user") }
            } catch { print("failed to load temp user") }
        } else {
            if selectedUser != nil {
                if (selectedUser?.checkData())! {
                    setDotLocations(user: selectedUser!)
                    drawLines()
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.scaleBy(x: 1.6, y: 1.2)
            ctx.cgContext.translateBy(x: -2, y: 0)
            
            ctx.cgContext.move(to: left250.center)
            ctx.cgContext.addLine(to: left500.center)
            ctx.cgContext.addLine(to: left1000.center)
            ctx.cgContext.addLine(to: left2000.center)
            ctx.cgContext.addLine(to: left4000.center)
            ctx.cgContext.addLine(to: left8000.center)
            ctx.cgContext.setLineWidth(8)
            ctx.cgContext.setStrokeColor(UIColor.blue.cgColor)
            ctx.cgContext.strokePath()
            
            ctx.cgContext.translateBy(x: 0, y: 5)
            ctx.cgContext.move(to: right250.center)
            ctx.cgContext.addLine(to: right500.center)
            ctx.cgContext.addLine(to: right1000.center)
            ctx.cgContext.addLine(to: right2000.center)
            ctx.cgContext.addLine(to: right4000.center)
            ctx.cgContext.addLine(to: right8000.center)
            ctx.cgContext.setLineWidth(8)
            ctx.cgContext.setStrokeColor(UIColor.red.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = img
        
    }
    
    func setDotLocations(user: User) {
        let left = user.getLeftResults()
        var image = UIImageView()
        for item in left {
            switch item.key {
            case 250:
                image = left250
            case 500:
                image = left500
            case 1000:
                image = left1000
            case 2000:
                image = left2000
            case 4000:
                image = left4000
            case 8000:
                image = left8000
            default:
                print("error")
            }
            image.frame = CGRect(x: freqDict[item.key]!, y: volDict[item.value]!, width: 38, height: 39)
        }
        // print overall result in left label
        var sum = 0
        for item in left.values {
            sum += item
        }
        var result = sum / 6
        if result <= 25 {
            leftLabel.text = "聽力正常"
        } else if result > 25 && result <= 40 {
            leftLabel.text = "輕度聽損"
        } else if result > 40 && result <= 55 {
            leftLabel.text = "中度聽損"
        } else if result > 55 && result <= 70 {
            leftLabel.text = "中重度聽損"
        } else if result > 70 && result <= 90 {
            leftLabel.text = "重度聽損"
        } else {
            leftLabel.text = "極重度聽損"
        }
        
        let right = user.getRightResults()
        for item in right {
            switch item.key {
            case 250:
                image = right250
            case 500:
                image = right500
            case 1000:
                image = right1000
            case 2000:
                image = right2000
            case 4000:
                image = right4000
            case 8000:
                image = right8000
            default:
                print("error")
            }
            image.frame = CGRect(x: freqDict[item.key]!, y: volDict[item.value]!, width: 38, height: 39)
        }
        // print overall result in right label
        sum = 0
        for item in right.values {
            sum += item
        }
        result = sum / 6
        if result <= 25 {
            rightLabel.text = "聽力正常"
        } else if result > 25 && result <= 40 {
            rightLabel.text = "輕度聽損"
        } else if result > 40 && result <= 55 {
            rightLabel.text = "中度聽損"
        } else if result > 55 && result <= 70 {
            rightLabel.text = "中重度聽損"
        } else if result > 70 && result <= 90 {
            rightLabel.text = "重度聽損"
        } else {
            rightLabel.text = "極重度聽損"
        }
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
