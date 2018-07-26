//
//  DetailViewController.swift
//  TissueHearingExpress
//
//  Created by Jenny Wu on 10/7/18.
//  Copyright © 2018 Jenny Wu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var left250: UIImageView!
    @IBOutlet weak var left500: UIImageView!
    @IBOutlet weak var left1000: UIImageView!
    @IBOutlet weak var left2000: UIImageView!
    @IBOutlet weak var left4000: UIImageView!
    @IBOutlet weak var left8000: UIImageView!
    var leftImages = Array<UIImageView>()
    
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var right250: UIImageView!
    @IBOutlet weak var right500: UIImageView!
    @IBOutlet weak var right1000: UIImageView!
    @IBOutlet weak var right2000: UIImageView!
    @IBOutlet weak var right4000: UIImageView!
    @IBOutlet weak var right8000: UIImageView!
    var rightImages = Array<UIImageView>()
    
    let freqDict = [
        250: 26,
        500: 75,
        1000: 123,
        2000: 172,
        4000: 219,
        8000: 267
    ]
    let volDict = [
        10: 39,
        20: 79,
        30: 119,
        40: 159,
        50: 199,
        60: 239,
        70: 279,
        80: 319,
        90: 359
    ]
    
    var selectedUser: User?
    var selectedIndex: Int?
    var tempUser: User?
    var selectedImage: UIImageView!
    var usersLi = [User]()
    
    var left = true
    var right = false
    
    var drag = false

    override func viewDidLoad() {
        super.viewDidLoad()
        drag = false
        infoView.isHidden = true
        leftButton.isEnabled = false
        rightButton.isEnabled = true
        
        leftImages = [left250, left500, left1000, left2000, left4000, left8000]
        rightImages = [right250, right500, right1000, right2000, right4000, right8000]
        
        let defaults = UserDefaults.standard
        if let savedTempUser = defaults.object(forKey: "tempUser") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                // temp user just inititalised
                tempUser = try jsonDecoder.decode(User.self, from: savedTempUser)
            } catch { print("failed to load temp user") }
            // selected user selected from table
        }
        if (selectedUser?.checkCoordinates()) == true {
            let leftData = selectedUser?.getLeftCoordinates()
            let rightData = selectedUser?.getRightCoordinates()
            loadDots(dataL: leftData!, dataR: rightData!)
        } else {
            print("failed to load coordinate data")
        }
        drawLines()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func leftButtonTapped(_ sender: UIButton) {
        leftButton.isEnabled = false
        rightButton.isEnabled = true
        left = true
        right = false
    }
    
    @IBAction func rightButtonTapped(_ sender: UIButton) {
        leftButton.isEnabled = true
        rightButton.isEnabled = false
        left = false
        right = true
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        // save new data into user
        // get users list and append user into list if not there
        let defaults = UserDefaults.standard
        var usersLi = Array<User>()
        if let savedUsers = defaults.object(forKey: "users") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                usersLi = try jsonDecoder.decode([User].self, from: savedUsers)
                if tempUser != nil {
                    saveDots()
                    usersLi.append(tempUser!)
                } else if selectedUser != nil {
                    saveDots()
                    usersLi[selectedIndex!] = selectedUser!
                }
            } catch { print("failed to load users list") }
        }
        // save the new users list
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(usersLi) {
            defaults.set(savedData, forKey: "users")
            print("saved new user")
            defaults.removeObject(forKey: "tempUser")
        } else { print("failed to save new user") }
    // go back to main menu
    self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func showInfoTapped(_ sender: UIButton) {
        infoView.isHidden = false
    }
    
    @IBAction func leaveButtonTapped(_ sender: UIButton) {
        infoView.isHidden = true
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
    
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
    
    func loadDots(dataL: [Int: CGPoint], dataR: [Int: CGPoint]) {
        // loads dots from User data and shows on screen
        var image: UIImageView
        for item in dataL {
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
                print("error with loading left ear data")
                return
            }
            UIView.animate(withDuration: 0.01, animations: {
                image.center = item.value
            }, completion: nil)
        }
        
        for item in dataR {
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
                print("error with loading right ear data")
                return
            }
            UIView.animate(withDuration: 0.01, animations: {
                image.center = item.value
            }, completion: nil)
        }
        drawLines()
    }
    
    func saveDots() {
        var dict = [Int: CGPoint]()
        var count = 0
        for dot in leftImages {
            // save dot coordinates into dictionary
            let x = 2 << (count - 1)
            dict[250 * x] = dot.center
            count += 1
        }
        if selectedUser != nil {
            selectedUser?.writeLeftCoordinates(coordinates: dict)
            print("left ear dots saved in selected user")
        } else {
            tempUser?.writeLeftCoordinates(coordinates: dict)
            print("left ear dots saved in temp user")
        }
        count = 0
        dict = [Int: CGPoint]()
        for dot in rightImages {
            //save dot coordinates into dictionary
            let x = 2 << (count - 1)
            dict[250 * x] = dot.center
            count += 1
        }
        if selectedUser != nil {
            selectedUser?.writeRightCoordinates(coordinates: dict)
            print("right ear dots saved in selected user")
        } else {
            tempUser?.writeRightCoordinates(coordinates: dict)
            print("right ear dots saved in temp user")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        var location: CGPoint
        if let touch = touches.first {
            if left {
                location = touch.location(in: leftView)
                location = CGPoint(x: location.x - 12, y: location.y - 24)
                print(location)
                for dot in leftImages {
                    if distance(location, dot.frame.origin) <= 20 {
                        selectedImage = dot
                        print(selectedImage)
                        break
                    }
                }
            } else {
                location = touch.location(in: rightView)
                location = CGPoint(x: location.x - 12, y: location.y - 24)
                print(location)
                for dot in rightImages {
                    if distance(location, dot.frame.origin) <= 20 {
                        selectedImage = dot
                        print(selectedImage)
                        break
                    }
                }
            }
            if selectedImage == nil {
                print("image not selected")
                return
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        drag = true
        guard let touch = touches.first else { return }
        var location: CGPoint
        if left {
            location = touch.location(in: leftView)
        } else {
            location = touch.location(in: rightView)
        }
        if self.drag {
            location = CGPoint(x: location.x - 12, y: location.y - 24)
            // move selected dot accordingly to touch (only y position and only in intervals) -> done
            let points = self.volDict.values
            for point in points {
                if location.y - CGFloat(point) <= 20 && location.y - CGFloat(point) >= -20 && self.selectedImage != nil {
                    UIView.animate(withDuration: 0.05, animations: {
                        self.selectedImage.center.y = CGFloat(point)
                    }, completion: nil)
                }
            }
            self.drawLines()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        drag = false
        selectedImage = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        // reset all dots back to original coordinates -> done
        for image in leftImages {
            UIView.animate(withDuration: 0.01, animations: {
                image.center.y = CGFloat(self.volDict[10]!)
            }, completion: nil)
        }
        for image in rightImages {
            UIView.animate(withDuration: 0.01, animations: {
                image.center.y = CGFloat(self.volDict[10]!)
            }, completion: nil)
        }
        drawLines()
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
