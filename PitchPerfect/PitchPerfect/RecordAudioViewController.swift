//
//  RecordAudioViewController.swift
//  PitchPerfect
//
//  Created by Angel Contreras on 3/7/15.
//  Copyright (c) 2015 Angel Contreras. All rights reserved.
//

import UIKit
import AVFoundation

class RecordAudioViewController: UIViewController, AVAudioRecorderDelegate {
        
        @IBOutlet weak var recordingLabel: UILabel!
        @IBOutlet weak var stopRecordingButton: UIButton!
        @IBOutlet weak var recordButton: UIButton!
    
    
        var audioRecorder:AVAudioRecorder!
        var recordedAudio:RecordedAudio!

        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
        }
    override func viewWillAppear(animated: Bool) {
        stopRecordingButton.hidden = true
        recordingLabel.text = "Tap to Record"
        recordButton.enabled = true
    }
        override func viewDidAppear(animated: Bool) {
            
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
    @IBAction func recordAudio(sender: UIButton) {
        
        recordingLabel.text = "Recording..."
        stopRecordingButton.hidden = false
        recordButton.enabled = false

        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        // gets the path to the document directory within the app. It is the only place we can store files.
        
        let currentDateTime = NSDate() // get current date and time
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        // using the formatter to convert the date and time into a string and using it to name the file to avoid files with the same name
        
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        
        //code to allow audio to play normaly in a divse
        //Credit: thiago_243118
        var error: NSError?
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: &error)
        session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: &error)
        session.setActive(true, error: &error)
        //////
        
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else{
            println("Recording was not Successful")
            recordButton.enabled = true
            stopRecordingButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
            
        }
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }

}

