//
//  AGManager.swift
//  listory
//
//  Created by Devi Mandasari on 16/10/20.
//

import UIKit
import AVFoundation

enum AGManagerState {
    case granted
    case denied
    case undetermined
    case error(Error)
}

protocol AGManagerDelegate: class {
    func recorderAndPlayer(_ manager: AGManager, withStates state: AGManagerState)
    func recorderAndPlayer(_ recoder: AGAudioRecorder, withStates state: AGRecorderState)
    func recorderAndPlayer(_ player: AGAudioPlayer, withStates state: AGPlayerState)
}

class AGManager: NSObject {
    
    private var fileManager: AGFileManager
    var delegate: AGManagerDelegate?
    
    private var recorder: AGAudioRecorder?
    private var player: AGAudioPlayer?

    init(withFileManager fileManager: AGFileManager) {
        self.fileManager = fileManager
        super.init()
    }
    
    func checkRecordPermission() {
        let recordPermission = AVAudioSession.sharedInstance().recordPermission
        switch recordPermission {
        case .granted:
            DispatchQueue.main.async {
                self.delegate?.recorderAndPlayer(self, withStates: .granted)
                self.configuration()
            }
            break
        case .denied:
            DispatchQueue.main.async {
                self.delegate?.recorderAndPlayer(self, withStates: .denied)
            }
            break
        case .undetermined:
            self.requestForRecordPermission()
            break
        @unknown default:
            self.requestForRecordPermission()
            break
        }
    }
    
    private func requestForRecordPermission() {
        let session = AVAudioSession.sharedInstance()
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try session.setCategory(AVAudioSession.Category.playAndRecord)
                try session.setActive(true, options: .notifyOthersOnDeactivation)
                try session.overrideOutputAudioPort(.speaker)
                try session.setActive(true)
                session.requestRecordPermission { [weak self] (allowed) in
                    self?.checkRecordPermission()
                }
            } catch {
                DispatchQueue.main.async {
                    self.delegate?.recorderAndPlayer(self, withStates: .error(error))
                }
            }
        }
    }
    
    private func configuration() {
        self.recorder = AGAudioRecorder(withFileManager: fileManager)
        self.player = AGAudioPlayer(withFileManager: fileManager)
        
        self.recorder?.recorderStateChangeHandler = { state in
            self.delegate?.recorderAndPlayer(self.recorder!, withStates: state)
        }
        
        self.player?.playerStateChangeHandler = { state in
            self.delegate?.recorderAndPlayer(self.player!, withStates: state)
        }
        
        self.recorder?.setupRecorder()
    }
    
    func recordStart() {
        self.player?.doStop()
        self.recorder?.doRecord()
    }
    
    func pauseRecording() {
        self.recorder?.doPause()
    }
    
    func resumeRecording() {
        self.player?.doStop()
        self.recorder?.doResume()
    }
    
    func stopRecording() {
        self.recorder?.doStop()
        self.player?.preparePlay()
    }
    
    func startPalyer() {
        self.recorder?.doStop()
        self.player?.doPlay()
    }
    
    func pausePlaying() {
        self.player?.doPause()
    }
    
    func resumePalyer() {
        self.recorder?.doStop()
        self.player?.doPlay()
    }
    
    func stopPlaying() {
        self.player?.doStop()
    }
}

