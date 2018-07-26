//
//  LeftRightViewController.swift
//  TissueHearingExpress
//
//  Created by Jenny Wu on 12/7/18.
//  Copyright © 2018 Jenny Wu. All rights reserved.
//

import UIKit
import AVFoundation

class LeftRightViewController: UIViewController, AVAudioPlayerDelegate {
    var headphones = false
    var audioPlayer: AVAudioPlayer!
    var ear: String = ""
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    
    @IBAction func leftButtonTapped(_ sender: UIButton) {
        leftButton.isEnabled = false
        rightButton.isEnabled = true
        ear = "left"
        playSound()
    }
    
    @IBAction func rightButtonTapped(_ sender: UIButton) {
        rightButton.isEnabled = false
        leftButton.isEnabled = true
        ear = "right"
        playSound()
    }
    
    @IBAction func nextStep(_ sender: Any) {
        if audioPlayer != nil {
            audioPlayer.stop()
        }
        headphones = headsetPluggedIn()
        if !headphones {
            let ac = UIAlertController(title: "警告", message: "請先插入耳機再進行測試！", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "確定", style: .default))
            present(ac, animated: true)
        }
    }
    
    func playSound() {
        headphones = headsetPluggedIn()
        if headphones == false {
            let ac = UIAlertController(title: "警告", message: "請先插入耳機再進行測試！", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "確定", style: .default))
            present(ac, animated: true)
            return
        } else {
            let audioFilePath = Bundle.main.path(forResource: "sound", ofType: "mp3")
            if audioFilePath != nil {
                let audioFileUrl = NSURL.fileURL(withPath: audioFilePath!)
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: audioFileUrl)
                    if ear == "left" {
                        audioPlayer.pan = -0.9
                    } else if ear == "right" {
                        audioPlayer.pan = 0.9
                    } else {
                        audioPlayer.pan = 0.0
                        print("error: ear not specified")
                    }
                    audioPlayer.play()
                } catch {
                }
            } else {
                print("audio file is not found")
            }
        }
    }
    
    func headsetPluggedIn() -> Bool {
        let route = AVAudioSession.sharedInstance().currentRoute
        return (route.outputs ).filter({ $0.portType == AVAudioSessionPortHeadphones }).count > 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
