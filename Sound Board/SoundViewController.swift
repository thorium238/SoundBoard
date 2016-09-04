//
//  SoundViewController.swift
//  Sound Board
//
//  Created by Thomas Piotrowski on 9/2/16.
//  Copyright © 2016 Thomas Piotrowski. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
        playButton.isEnabled = false
        addButton.isEnabled = false
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    
    var audioRecorder : AVAudioRecorder? = nil // can leave nil off.
    var audioPlayer : AVAudioPlayer? = nil
    var audioURL : URL?
    
    @IBOutlet weak var playButton: UIButton!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }
    
    func setupRecorder() {
        do {
            // Create an audio session
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            // Create URL for the audio file
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            //print("****************")
            //print(audioURL)
            //print("****************")
            // Create setting for audio recorder
            var settings : [String : Any] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
            settings[AVSampleRateKey] = 44100.0
            settings[AVNumberOfChannelsKey] = 2
            // Create AudioRecorder
            audioRecorder =  try AVAudioRecorder(url: audioURL! , settings: settings)
            audioRecorder!.prepareToRecord()
        } catch let error as NSError {
            print (error)}
    }
    
    @IBAction func recordTapped(_ sender: AnyObject) {
        if audioRecorder!.isRecording {
            // Stop recording and change btn title to record
            audioRecorder?.stop()
            recordButton.setTitle("Record", for: .normal)
            playButton.isEnabled = true
            addButton.isEnabled = true
        } else {
            // start recording and change button title to stop
            audioRecorder?.record()
            recordButton.setTitle("Stop", for: .normal)
        }
        
    }
    
    
    @IBAction func playTapped(_ sender: AnyObject) {
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer!.play()
        }
        catch {}
        
    }
    
    
    @IBAction func addTapped(_ sender: AnyObject) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let sound = Sound(context: context)
        
        sound.name = nameTextField.text
        sound.audio = NSData(contentsOf: audioURL!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
    }
    
}
