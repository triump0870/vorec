//
//  ViewController.swift
//  Vorec
//
//  Created by Rohan Roy on 19/06/16.
//  Copyright © 2016 Rohan Roy. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController , AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    var audioRecorder:AVAudioRecorder!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopRecordingButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    @IBAction func recordAudio(sender: UIButton) {
        stopRecordingButton.enabled = true
        recordButton.enabled = false
        recordingLabel.text = "Recording in Progress..."
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let fileName = "recordedAudio.wav"
        let pathArray = [dirPath,fileName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions:AVAudioSessionCategoryOptions.DefaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings:[:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(sender: AnyObject) {
        stopRecordingButton.enabled = false
        recordButton.enabled = true
        recordingLabel.text = "Tap to Record"
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        stopRecordingButton.enabled = false
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            self.performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
        }
        else{
            print("Saving of recording failed")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            let recordAudioUrl = sender as! NSURL
            playSoundsVC.recordedAudioUrl = recordAudioUrl
        }
    }
}

