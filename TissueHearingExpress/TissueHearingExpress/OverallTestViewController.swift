//
//  OverallTestViewController.swift
//  TissueHearingExpress
//
//  Created by Jenny Wu on 12/7/18.
//  Copyright © 2018 Jenny Wu. All rights reserved.
//

import UIKit
import AVFoundation

class OverallTestViewController: UIViewController {
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var nextStep: UIButton!
    @IBOutlet weak var barView: UIImageView!
    @IBOutlet weak var freqBar: UIImageView!
    
    let toneGen = ToneGenerator()
    var time = Timer()
    var running = false
    var age = 0
    var redo = false
    var count = 0
    
    //var tone: AVTonePlayerUnit!
    //var engine: AVAudioEngine!
    
    func playing() {
        running = true
        stopButton.isEnabled = true
        time = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.startButtonTapped(_:)), userInfo: nil, repeats: true)
    }
    
    @IBAction func pausePlayToggleButton(sender: UIButton) {
        if running == false {
            print("playing")
            startButton.isEnabled = false
            nextStep.isEnabled = false
            stopButton.isEnabled = true
            redo = true
            count = 0
            return playing()
        }
        return
    }
    
    @IBAction func stopButton(sender: UIButton) {
        if running == false {
            return
        }
        toneGen.stop()
        //engine.mainMixerNode.volume = 0.0
        //tone.stop()
        //engine.reset()
        //===============
        time.invalidate()
        running = false
        stopButton.isEnabled = false
        startButton.isEnabled = true
        nextStep.isEnabled = true
        startButton.setTitle("重測", for: .normal)
        print("stopped")
        redo = true
        infoLabel.isHidden = false
        infoLabel.text = "你的聽力年齡\(calculateAge())歲"
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        var translate = CGAffineTransform()
        var scale = CGAffineTransform()
        nextStep.isHidden = false
        stopButton.isHidden = false
        if redo == true {
            count = 0
        }
        redo = false
        if count < 10 {
            self.count += 1
            print(count)
            let freq = (20000 - (count - 1) * 2000)
            UIView.animate(withDuration: 1, delay: 0, options: [], animations: { [unowned self] in
                switch self.count {
                case 1:
                    self.barView.transform = CGAffineTransform.identity
                case 2:
                    translate = CGAffineTransform(scaleX: 1, y: 333/370)
                    scale = CGAffineTransform(translationX: 0, y: 18.5)
                    self.barView.transform = translate.concatenating(scale)
                case 3:
                    translate = CGAffineTransform(scaleX: 1, y: 296/370)
                    scale = CGAffineTransform(translationX: 0, y: 37)
                    self.barView.transform = translate.concatenating(scale)
                case 4:
                    translate = CGAffineTransform(scaleX: 1, y: 259/370)
                    scale = CGAffineTransform(translationX: 0, y: 55.5)
                    self.barView.transform = translate.concatenating(scale)
                case 5:
                    translate = CGAffineTransform(scaleX: 1, y: 222/370)
                    scale = CGAffineTransform(translationX: 0, y: 74)
                    self.barView.transform = translate.concatenating(scale)
                case 6:
                    translate = CGAffineTransform(scaleX: 1, y: 186/370)
                    scale = CGAffineTransform(translationX: 0, y: 92)
                    self.barView.transform = translate.concatenating(scale)
                case 7:
                    translate = CGAffineTransform(scaleX: 1, y: 148/370)
                    scale = CGAffineTransform(translationX: 0, y: 111)
                    self.barView.transform = translate.concatenating(scale)
                case 8:
                    translate = CGAffineTransform(scaleX: 1, y: 112/370)
                    scale = CGAffineTransform(translationX: 0, y: 129)
                    self.barView.transform = translate.concatenating(scale)
                case 9:
                    translate = CGAffineTransform(scaleX: 1, y: 75/370)
                    scale = CGAffineTransform(translationX: 0, y: 147.5)
                    self.barView.transform = translate.concatenating(scale)
                case 10:
                    translate = CGAffineTransform(scaleX: 1, y: 38/370)
                    scale = CGAffineTransform(translationX: 0, y: 166)
                    self.barView.transform = translate.concatenating(scale)
                default:
                    self.barView.transform = CGAffineTransform.identity
                }
            })
            playSound(f: Double(freq))
            print(freq)
        } else {
            print("stopped")
            toneGen.stop()
            //engine.mainMixerNode.volume = 0.0
            //tone.stop()
            //engine.reset()
            //==================
            time.invalidate()
            startButton.isEnabled = true
            stopButton.isEnabled = false
            nextStep.isEnabled = true
            running = false
            startButton.setTitle("重測", for: .normal)
            print("stopped")
            redo = true
            infoLabel.isHidden = false
            infoLabel.text = "你的聽力年齡\(calculateAge())歲"
        }
    }
    
    func calculateAge() -> Int {
        if count == 1 {
            return 5
        } else if count == 2 {
            return 15
        } else if count == 3 {
            return 20
        } else if count == 4 {
            return 35
        } else if count == 5 {
            return 45
        } else if count == 6 {
            return 55
        } else if count == 7 {
            return 65
        } else if count == 8 {
            return 75
        } else if count == 9 {
            return 80
        } else {
            return 90
        }
    }
    
    
    func playSound(f: Double) {
        toneGen.enableSpeaker()
        toneGen.setFrequency(freq: Double(f))
        toneGen.setToneTime(t: 3)
        //tone.frequency = f
        //tone.preparePlaying()
        //tone.play()
        //engine.mainMixerNode.volume = 1.0
    }
    
    @IBAction func infoButtonTapped(_ sender: UIButton) {
        infoView.isHidden = false
    }
    
    @IBAction func leaveTapped(_ sender: UIButton) {
        infoView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoLabel.isHidden = true
        infoView.isHidden = true
        // Do any additional setup after loading the view.
        running = false
        age = 5
        redo = false
        count = 0
        nextStep.isHidden = true
        stopButton.isHidden = true
        view.addSubview(barView)
        view.sendSubview(toBack: barView)
        view.sendSubview(toBack: freqBar)
        //===================
        //tone = AVTonePlayerUnit()
        //let format = AVAudioFormat(standardFormatWithSampleRate: tone.sampleRate, channels: 1)
        //engine = AVAudioEngine()
        //engine.attach(tone)
        //let mixer = engine.mainMixerNode
        //engine.connect(tone, to: mixer, format: format)
        //do {
        //    try engine.start()
        //} catch let error as NSError {
        //    print(error)
        //}
        //====================
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        toneGen.stop()
        //engine.mainMixerNode.volume = 0.0
        //tone.stop()
        //engine.reset()
        // ==================
        time.invalidate()
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
