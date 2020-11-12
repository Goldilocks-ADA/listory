//
//  AlbumController.swift
//  listory
//
//  Created by Devi Mandasari on 12/10/20.
//

import UIKit
import AVFoundation
import SnapKit
import UIKit
import PencilKit
import PhotosUI

protocol AlbumControllerDelegate {
    func updateStories(story: Story)
}

class AlbumController: UIViewController, PKCanvasViewDelegate, PKToolPickerObserver, UIImagePickerControllerDelegate & UINavigationControllerDelegate,UIPopoverPresentationControllerDelegate, UIScreenshotServiceDelegate {
// MARK: AVAudioRecorderDelegate
}
