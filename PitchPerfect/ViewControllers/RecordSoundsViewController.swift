//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Brenner on 03/08/21.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController {
    
    // MARK: Strings
    private enum Strings {
        static let recordingInProgress = "Recording in Progress"
        static let tapToRecord = "Tap to Record"
        static let recordingName = "recordedVoice.wav"
        static let segueIdentifier = "stopRecording"
        static let genericError = "Recording was not successful"
    }
    
    // MARK: Outlets
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    // MARK: Properties
    var audioRecorder: AVAudioRecorder!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        isRecording(false)
    }
    
    // MARK: Methods
    private func isRecording(_ validator: Bool) {
        stopRecordingButton.isEnabled = validator
        recordButton.isEnabled = !validator
        recordingLabel.text = validator ? Strings.recordingInProgress : Strings.tapToRecord
    }
    
    private func recordAudioMethod(stopRecording: Bool = false) {
        
        if stopRecording {
            audioRecorder.stop()
            let audioSession = AVAudioSession.sharedInstance()
            try! audioSession.setActive(false)
            return
        }
    
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = Strings.recordingName
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Strings.segueIdentifier {
            guard let playSoundsViewController = segue.destination as? PlaySoundsViewController,
                  let recordedAudioURL = sender as? URL else { return }
            playSoundsViewController.recordedAudioURL = recordedAudioURL
        }
    }
    
    // MARK: Actions
    @IBAction func recordAudio(_ sender: UIButton) {
        isRecording(true)
        recordAudioMethod()
    }
    
    @IBAction func stopRecording(_ sender: UIButton) {
        isRecording(false)
        recordAudioMethod(stopRecording: true)
    }
}

// MARK: AVAudio Delegate
extension RecordSoundsViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: Strings.segueIdentifier, sender: audioRecorder.url)
        } else {
            print(Strings.genericError)
        }
    }
}

