//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Angel Contreras on 3/7/15.
//  Copyright (c) 2015 Angel Contreras. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    //// Outlets ////
    /////////////////
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //// Actions ////
    /////////////////
    @IBAction func slowSound(sender: UIButton) {
        playAudioAt(0.5)
    }

    @IBAction func fastSound(sender: UIButton) {
        playAudioAt(2.0)
    }

    @IBAction func stopSound(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
    }
    
    @IBAction func chipmunkSound(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func darthVaderSound(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func reverbAudio(sender: UIButton) {
        playReverb(50)
    }
    
    @IBAction func echoSound(sender: UIButton) {
        playEcho(100)
    }
   
    
    //// Functions ////
    ///////////////////
    func playAudioAt(speed: Float){
        audioEngine.stop()
        audioPlayer.stop()
        audioPlayer.rate = speed
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    func playReverb(mix: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var reverbEffect = AVAudioUnitReverb()
        reverbEffect.wetDryMix = mix
        audioEngine.attachNode(reverbEffect)
        
        audioEngine.connect(audioPlayerNode, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    func playEcho(rate: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var echoEffect = AVAudioUnitDelay()
        echoEffect.wetDryMix = rate
        echoEffect.feedback = 30
        audioEngine.attachNode(echoEffect)

        audioEngine.connect(audioPlayerNode, to: echoEffect, format: nil)
        audioEngine.connect(echoEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
    }

}
