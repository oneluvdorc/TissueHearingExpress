//
//  ViewController.swift
//  TissueHearingExpress
//
//  Created by Jenny Wu on 10/7/18.
//  Copyright © 2018 Jenny Wu. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var toneGen = ToneGenerator()
    //var tone = AVTonePlayerUnit()
    //var engine = AVAudioEngine()
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var nextStep: UIButton!
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        startButton.setTitle("聽到了", for: .normal)
        startButton.isEnabled = false
        self.nextStep.isHidden = false
        toneGen.enableSpeaker()
        toneGen.setFrequency(freq: 800)
        toneGen.setToneTime(t: 3)
        //tone.frequency = 800.0
        //tone.preparePlaying()
        //tone.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // change 2 to desired number of seconds
            // Your code with delay
            self.toneGen.stop()
            //self.engine.mainMixerNode.volume = 0.0
            //self.tone.stop()
            //self.engine.reset()
            //self.startButton.setTitle("重播", for: .normal)
            //self.startButton.isEnabled = true
        }
    }
    
    @IBAction func nextStepTapped(_ sender: UIButton) {
        toneGen.stop()
        //self.engine.mainMixerNode.volume = 0.0
        //self.tone.stop()
        //self.engine.reset()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if nextStep != nil {
            nextStep.isHidden = true
        }
        // Do any additional setup after loading the view, typically from a nib.
        //let format = AVAudioFormat(standardFormatWithSampleRate: tone.sampleRate, channels: 1)
        //engine.attach(tone)
        //let mixer = engine.mainMixerNode
        //engine.connect(tone, to: mixer, format: format)
        //do {
        //    try engine.start()
        //} catch let error as NSError {
        //    print(error)
        //}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


