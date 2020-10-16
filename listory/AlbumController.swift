//
//  AlbumController.swift
//  listory
//
//  Created by Devi Mandasari on 12/10/20.
//

import UIKit
import AVFoundation
import SnapKit

class AlbumController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    let recordButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.backgroundColor = .red
        button.setTitle("Record", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let playButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.backgroundColor = .red
        button.setTitle("Play", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let audioManager: AGManager = AGManager(withFileManager: AGFileManager(withFileName: nil))
    
    var isRecording: Bool = false
    var isPlaying: Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Detail Screen"
        self.view.addSubview(recordButton)
        self.view.addSubview(playButton)
        audioManager.delegate = self
        audioManager.checkRecordPermission()
        
        self.recordButton.snp.makeConstraints{(make) in
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(16)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(50)
        }
        
        self.playButton.snp.makeConstraints{(make) in
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(50)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-50)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-100)
            make.height.equalTo(50)
        }
        
        self.recordButton.addTarget(self, action: #selector(redordingAction), for: .touchUpInside)
        
        self.playButton.addTarget(self, action: #selector(playingAction), for: .touchUpInside)
    }
    
    @objc private func redordingAction(){
        if !isRecording {
            isRecording = true
            self.audioManager.recordStart()
        } else {
            self.audioManager.stopRecording()
        }
    }
    
    @objc private func playingAction() {
        if !isPlaying {
            isPlaying = false
            self.audioManager.startPalyer()
        } else {
            self.audioManager.stopPlaying()
        }
    }
    
}

extension AlbumController: AGManagerDelegate {
    func recorderAndPlayer(_ manager: AGManager, withStates state: AGManagerState) {
        switch state {
        case .undetermined:
            break
        case .granted:
            recordButton.setTitle("Initialize Recorder", for: .normal)
            playButton.setTitle("Initialize Player", for: .normal)
        case .denied:
            break
            
        case .error(let erro):
            print(erro.localizedDescription)
        }
        recordButton.isEnabled = false
        playButton.isEnabled = false
    }
    
    func recorderAndPlayer(_ recoder: AGAudioRecorder, withStates state: AGRecorderState) {
        switch state {
        case .prepareToRecord:
            recordButton.setTitle("Ready to record", for: .normal)
            playButton.setTitle("Ready to Play", for: .normal)
            recordButton.isEnabled = true
            playButton.isEnabled = false
            
        case .recording:
            recordButton.setTitle("Recording....", for: .normal)
            playButton.isEnabled = false
            
        case .pause:
            recordButton.setTitle("Pause recording", for: .normal)
            
        case .stop:
            recordButton.setTitle("Stop recording", for: .normal)
            
        case .finish:
            recordButton.setTitle("Recording Finish", for: .normal)
            
        case .failed(let error):
            recordButton.setTitle(error.localizedDescription, for: .normal)
            playButton.isEnabled = false
            recordButton.isEnabled = false
        }
    }

    func recorderAndPlayer(_ player: AGAudioPlayer, withStates state: AGPlayerState) {
        switch state {
        case .prepareToPlay:
            playButton.setTitle("Ready to Play", for: .normal)
            recordButton.isEnabled = false
            playButton.isEnabled = true
            
        case .play:
            playButton.setTitle("Playing", for: .normal)
            
        case .pause:
            playButton.setTitle("Pause Playing", for: .normal)
            
        case .stop:
            playButton.setTitle("Stop Playing", for: .normal)
            
        case .finish:
            recordButton.setTitle("Start New Recording", for: .normal)
            playButton.setTitle("Playing Finished", for: .normal)
            recordButton.isEnabled = true
            
        case .failed(let error):
            recordButton.setTitle(error.localizedDescription, for: .normal)
            playButton.isEnabled = false
            recordButton.isEnabled = false
        }
    }
    
    func audioRecorderTime(currentTime timeInterval: TimeInterval, formattedString: String) {
        
    }
}
