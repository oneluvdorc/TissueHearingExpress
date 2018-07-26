//
//  SoundDetectionViewController.swift
//  TissueHearingExpress
//
//  Created by Jenny Wu on 18/7/18.
//  Copyright © 2018 Jenny Wu. All rights reserved.
//

import UIKit
import AVFoundation
import CoreAudio

class SoundDetectionViewController: UIViewController {
    var recorder: AVAudioRecorder!
    var timer = Timer()
    
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var backgroundLabel: UILabel!
    @IBOutlet weak var volumeBar: UIImageView!
    @IBOutlet weak var volumeImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(volumeBar)
        view.addSubview(volumeImage)
        view.sendSubview(toBack: volumeImage)
        beginRecord()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        beginRecord()
    }
    
    func beginRecord() {
        let directory = NSTemporaryDirectory()
        let fileName = NSUUID().uuidString
        
        let fullURL = NSURL.fileURL(withPathComponents: [directory, fileName])
        
        
        let recordSettings: [String: Any] = [
            AVFormatIDKey:              kAudioFormatAppleIMA4,
            AVSampleRateKey:            44100.0,
            AVNumberOfChannelsKey:      2,
            AVEncoderBitRateKey:        12800,
            AVLinearPCMBitDepthKey:     16,
            AVEncoderAudioQualityKey:   AVAudioQuality.max.rawValue
        ]
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setActive(true)
            try recorder = AVAudioRecorder(url: fullURL!, settings: recordSettings)
            
        } catch {
            return
        }
        
        recorder.prepareToRecord()
        recorder.isMeteringEnabled = true
        recorder.record()
        levelTimerCallback()
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(levelTimerCallback), userInfo: nil, repeats: true)
    }
    
    @objc func levelTimerCallback() {
        var level: Float = -50.0
        recorder.updateMeters()
        level = recorder.averagePower(forChannel: 0)
        let angle = (level + 45) * 2 / 90
        volumeLabel.text = "\(Int((level + 100).rounded()))"
        UIView.animate(withDuration: 0.4, animations: {
            self.volumeBar.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
        })
        if level >= -40  {
            backgroundLabel.textColor = UIColor.red
            backgroundLabel.text = "目前的環境噪音過高，並不適宜進行聽力檢測，請換個環境進行檢測．"
        } else {
            backgroundLabel.textColor = UIColor.black
            backgroundLabel.text = "目前的環境噪音可進行聽力檢測，請點擊下方的下一步鍵進行聽力檢測．"
        }
    }
    
    @IBAction func leaveButtonTapped(_ sender: UIButton) {
        timer.invalidate()
        recorder.stop()
        recorder.isMeteringEnabled = false
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
