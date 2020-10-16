//
//  AGPlayerRecorderState.swift
//  listory
//
//  Created by Devi Mandasari on 16/10/20.
//

import UIKit

enum AGPlayerRecorderState {
    case initialize
    case readyToRecord
    case recording
    case pauseRecording
    case finishRecording
    case readyToPlay
    case play
    case pausePlayer
    case stopPlayer
    case finishPlayer
    case failed(String)
}
