//
//  DetailTestViewController.swift
//  TissueHearingExpress
//
//  Created by Jenny Wu on 13/7/18.
//  Copyright © 2018 Jenny Wu. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class DetailTestViewController: UIViewController {
    @IBOutlet weak var freqLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var heardButton: UIButton!
    @IBOutlet weak var notHeardButton: UIButton!
    @IBOutlet weak var earLabel: UILabel!
    
    var leftEar = Array<[Bool]>()
    var rightEar = Array<[Bool]>()
    var leftCount1 = 1
    var leftCount2 = 0.1
    var rightCount1 = 1
    var rightCount2 = 0.1
    var ear = ""
    var finished = false
    var stage = 1.1
    var heard = true
    var count = 0
    
    var time = Timer()
    var running = false
    
    let freqDict: [Int: Int] = [
        1: 250,
        2: 500,
        3: 1000,
        4: 2000,
        5: 4000,
        6: 8000
    ]
    let volDict: [Float: [Int]] = [
        0.1: [50],
        0.2: [30, 70],
        0.3: [20, 40, 60, 80],
        0.4: [10]
    ]
    
    let toneGen = ToneGenerator()
    var redo = false
    
    override func viewDidDisappear(_ animated: Bool) {
        time.invalidate()
        running = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.setTitle("開始", for: .normal)
        leftCount1 = 1
        leftCount2 = 0.1
        rightCount1 = 0
        rightCount2 = 0.4
        ear = "left"
        redo = true
        heardButton.isEnabled = false
        notHeardButton.isEnabled = false
        // disable two buttons below
        // Do any additional setup after loading the view.
        leftEar = Array(repeating: [], count: 6)
        rightEar = Array(repeating: [], count: 6)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        if !running {
            prepareSound()
            startButton.setTitle("測試\(stage)", for: .normal)
            heardButton.isEnabled = true
            notHeardButton.isEnabled = true
        } else {
            startButton.setTitle("重播", for: .normal)
            time.invalidate()
            startButton.isEnabled = true
            running = false
        }
    }
    
    
    @IBAction func heardTapped(_ sender: UIButton) {
        time.invalidate()
        heard = true
        startButton.isEnabled = true
        if !finished {
            if ear == "left" {
                leftEar[leftCount1 - 1].append(true)
            } else {
                rightEar[rightCount1 - 1].append(true)
            }
        }
        toneGen.stop()
        
        redo = false
        if !(rightCount1 == 6 && (rightCount2 == 0.4 || (Float(rightCount2) == Float(0.3) && count > 0))) {
            prepareSound()
        } else {
            finish()
        }
    }
    
    func finish() {
        startButton.isEnabled = false
        
        let leftData = interpretData(array: leftEar)
        let rightData = interpretData(array: rightEar)
        
        let defaults = UserDefaults.standard
        var tempUser: User
        if let savedUser = defaults.object(forKey: "tempUser") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                tempUser = try jsonDecoder.decode(User.self, from: savedUser)
                tempUser.writeLeftResults(results: leftData)
                tempUser.writeRightResults(results: rightData)
                
                tempUser.tempSaveUser()
            } catch {
                print("Failed to load temporary user")
            }
        }
        
        let vc :UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Final") as UIViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func notHeardTapped(_ sender: UIButton) {
        heard = false
        count += 1
        time.invalidate()
        startButton.isEnabled = true
        if !finished {
            if ear == "left" {
                leftEar[leftCount1 - 1].append(false)
            } else {
                rightEar[rightCount1 - 1].append(false)
            }
        }
        toneGen.stop()
        redo = false
        if !(rightCount1 == 6 && (rightCount2 == 0.4 || (Float(rightCount2) == Float(0.3) && count > 0))) {
            prepareSound()
        }
        else {
            finish()
        }
    }
    
    func prepareSound() {
        var freq = 800
        var volume = 1.0
        
        if leftCount1 == 6 && leftCount2 == 0.4 {
            ear = "right"
        } else if leftCount1 == 6 && Float(leftCount2) == Float(0.3) {
            if count > 0 {
                ear = "right"
            }
        }

        if !redo {
            if ear == "left" {
                if Float(leftCount2) == Float(0.3) && count > 0 {
                    leftCount2 = 0.1
                    leftCount1 += 1
                    count = 0
                } else if leftCount2 < 0.4 {
                    leftCount2 += 0.1
                } else {
                    leftCount2 = 0.1
                    leftCount1 += 1
                    count = 0
                }
            } else if ear == "right" {
                if Float(rightCount2) == Float(0.3) && count > 0 {
                    rightCount2 = 0.1
                    rightCount1 += 1
                    count = 0
                } else if rightCount2 < 0.4 {
                    rightCount2 += 0.1
                } else {
                    rightCount2 = 0.1
                    rightCount1 += 1
                    count = 0
                }
            }
        }
        toneGen.enableSpeaker()
        if ear == "left" {
            freq = freqDict[leftCount1]!
            earLabel.text = "左耳測試"
            freqLabel.text = "\(freqDict[leftCount1]!) Hz"
            if Float(leftCount2) == Float(0.3) && count > 0 {
                if count == 2 || heard {
                    volumeLabel.text = "\(volDict[Float(leftCount2)]![count + 1]) dB"
                } else {
                    volumeLabel.text = "\(volDict[Float(leftCount2)]![count]) dB"
                }
            } else {
            volumeLabel.text = "\(volDict[Float(leftCount2)]![count]) dB"
            }
        } else if ear == "right" {
            freq = freqDict[Int(rightCount1)]!
            earLabel.text = "右耳測試"
            freqLabel.text = "\(freqDict[rightCount1]!) Hz"
            if Float(rightCount2) == Float(0.3) && count > 0 {
                if count == 2 || heard {
                    volumeLabel.text = "\(volDict[Float(rightCount2)]![count + 1]) dB"
                } else {
                    volumeLabel.text = "\(volDict[Float(rightCount2)]![count]) dB"
                }
            } else {
                volumeLabel.text = "\(volDict[Float(rightCount2)]![count]) dB"
            }
        } else { return }
        
        print("\(ear) ear testing")
        print("left ear: \(leftCount1), \(leftCount2); right ear: \(rightCount1), \(rightCount2)")
        volume = Double(getVolumeValue())
        print("frequency: \(freq), volume: \(volume)")
        playSound(f: Double(freq), v: Double(volume))
        
        print("=====================")
        
        redo = true
    }
    
    func getVolumeValue() -> Float {
        var db: Float = 0.1
        if ear == "left" {
            db = Float(leftCount2)
            stage = (Double(leftCount1) + leftCount2)
        } else if ear == "right" {
            db = Float(rightCount2)
            stage = (Double(rightCount1) + rightCount2)
        }

        if db == 0.1 {
            return 0.5
        } else if db == 0.2 {
            if count == 0 {
                return 0.3
            } else if count == 1 {
                return 0.7
            }
        } else if db == 0.3 {
            if count == 0 {
                return 0.2
            } else if count == 1 && heard == true{
                return 0.6
            } else if count == 1 && heard == false {
                return 0.4
            } else if count == 2 {
                return 0.8
            }
        } else {
            return 0.1
        }
        print("failed")
        return 0.1
    }
    
    func playSound(f: Double, v: Double) {
        running = true
        toneGen.setFrequency(freq: f)
        toneGen.setToneVolume(vol: v)
        toneGen.setToneTime(t: 2)
        startButton.setTitle("測試\(stage)", for: .normal)
        startButton.isEnabled = false
        time = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.startButtonTapped(_:)), userInfo: nil, repeats: false)
    }
    
    func interpretData(array: Array<[Bool]>) -> [Int: Int] {
        var db = 10
        var count = 0
        var newDict = [Int: Int]()
        for freq in array {
            if freq[0] {
                if freq[1] {
                    if freq[2] {
                        if freq[3] {
                            db = 10
                        } else {
                            db = 20
                        }
                    } else {
                        db = 30
                    }
                } else {
                    if freq[2] {
                        db = 40
                    } else {
                        db = 50
                    }
                }
            } else {
                if freq[1] {
                    if freq[2] {
                        db = 60
                    } else {
                        db = 70
                    }
                } else {
                    if freq[2] {
                        db = 80
                    } else {
                        db = 90
                    }
                }
            }
            let x = 2 << (count - 1)
            newDict[250 * x] = db
            count += 1
        }
        return newDict
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
