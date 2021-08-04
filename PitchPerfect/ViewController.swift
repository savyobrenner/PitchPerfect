//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Brenner on 03/08/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isRecording(false)
        // Do any additional setup after loading the view.
    }
    
    private func isRecording(_ validator: Bool) {
        stopRecordingButton.isEnabled = validator
        recordButton.isEnabled = !validator
        recordingLabel.text = validator ? "Recording in Progress" : "Tap to Record"
    }

    @IBAction func recordAudio(_ sender: UIButton) {
        isRecording(true)
    }
    
    @IBAction func stopRecording(_ sender: UIButton) {
        isRecording(false)
    }
    

}

