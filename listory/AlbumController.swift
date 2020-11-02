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

class AlbumController: UIViewController, PKCanvasViewDelegate, PKToolPickerObserver, UIImagePickerControllerDelegate & UINavigationControllerDelegate,UIPopoverPresentationControllerDelegate, UIScreenshotServiceDelegate {
    
    
    
    //MARK:- 1.View Creation Detail Screen
    let cameraButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.layer.cornerRadius = 33
        button.backgroundColor = .red
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let recordButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.layer.cornerRadius = 33
        button.backgroundColor = .red
        button.setTitle("Record", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let stopButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.layer.cornerRadius = 33
        button.backgroundColor = .red
        button.setTitle("Stop", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let playButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.layer.cornerRadius = 33
        button.backgroundColor = .red
        button.setTitle("Play", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
      //  label.text = "Selamat Pagi"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    let sampleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage()
        return imageView
    }()
    
    let pencilFingerButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.layer.cornerRadius = 33
        button.backgroundColor = .red
        button.setTitle("Pencil", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    var recorder: AVAudioRecorder!
    var player: AVAudioPlayer!
    var meterTimer: Timer!
    var soundFileURL: URL!
    var recordings = [URL]()
    
    var canvasView: PKCanvasView!
    var undoBarButtonitem: UIBarButtonItem!
    var redoBarButtonItem: UIBarButtonItem!
    var toolPicker: PKToolPicker!
    var drawing = PKDrawing()
    
    /// On iOS 14.0, this is no longer necessary as the finger vs pencil toggle is a global setting in the toolpicker
  //  var pencilFingerBarButtonItem: UIBarButtonItem!

    /// Standard amount of overscroll allowed in the canvas.
    static let canvasOverscrollHeight: CGFloat = 500
    
    /// Data model for the drawing displayed by this view controller.
    var dataModelController: DataModelController!
    
    /// Private drawing state.
    var drawingIndex: Int = 0
    var hasModifiedDrawing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        //MARK:- 2. Add Subview to Main View
        self.title = "Detail Screen"
        self.view.addSubview(cameraButton)
        self.view.addSubview(sampleImageView)
        self.view.addSubview(recordButton)
        self.view.addSubview(stopButton)
        self.view.addSubview(playButton)
        self.view.addSubview(statusLabel)
        self.view.addSubview(pencilFingerButton)
        
        stopButton.isEnabled = false
        playButton.isEnabled = false
        
        //MARK:- 3. Add Constraint
        self.cameraButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            make.width.equalTo(66)
            make.height.equalTo(66)
        }
        
        self.recordButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-100)
            make.width.equalTo(66)
            make.height.equalTo(66)
        }
        
        self.stopButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-200)
            make.width.equalTo(66)
            make.height.equalTo(66)
        }
        
        self.playButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-300)
            make.width.equalTo(66)
            make.height.equalTo(66)
        }
        
        self.pencilFingerButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-400)
            make.width.equalTo(66)
            make.height.equalTo(66)
        }
        
        self.statusLabel.snp.makeConstraints{(make)in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(16)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(150 )
        }
        
        self.sampleImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.safeAreaLayoutGuide)
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.right.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.cameraButton.addTarget(self, action: #selector(buttonAddImage), for: .touchUpInside)
        self.recordButton.addTarget(self, action: #selector(record), for: .touchUpInside)
        self.stopButton.addTarget(self, action: #selector(stop), for: .touchUpInside)
        self.playButton.addTarget(self, action: #selector(play), for: .touchUpInside)
        self.pencilFingerButton.addTarget(self, action: #selector(viewWillAppear), for: .touchUpInside)
    }
    
    @objc func updateAudioMeter(_ timer: Timer) {
        
        if let recorder = self.recorder {
            if recorder.isRecording {
                let min = Int(recorder.currentTime / 60)
                let sec = Int(recorder.currentTime.truncatingRemainder(dividingBy: 60))
                let s = String(format: "%02d:%02d", min, sec)
                statusLabel.text = s
                recorder.updateMeters()
            }
        }
    }
    
    /// Set up the drawing initially.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set up the canvas view with the first drawing from the data model.
        canvasView.delegate = self
        canvasView.drawing = dataModelController.drawings[drawingIndex]
        canvasView.alwaysBounceVertical = true
        
        // Set up the tool picker
        if #available(iOS 14.0, *) {
            toolPicker = PKToolPicker()
        } else {
            // Set up the tool picker, using the window of our parent because our view has not
            // been added to a window yet.
            let window = parent?.view.window
            toolPicker = PKToolPicker.shared(for: window!)
        }
        
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        toolPicker.addObserver(self)
        updateLayout(for: toolPicker)
        canvasView.becomeFirstResponder()
        
        // Before iOS 14, add a button to toggle finger drawing.
        //if #available(iOS 14.0, *) { } else {
           // pencilFingerBarButtonItem = UIBarButtonItem(title: "Enable Finger Drawing",
            //                                            style: .plain,
          //                                              target: self,
              //                                          action: #selector(toggleFingerPencilDrawing(_:)))
           // navigationItem.rightBarButtonItems?.append(pencilFingerBarButtonItem)
         //   canvasView.allowsFingerDrawing = false
       // }
        
        // Always show a back button.
        navigationItem.leftItemsSupplementBackButton = true
        
        // Set this view controller as the delegate for creating full screenshots.
        parent?.view.window?.windowScene?.screenshotService?.delegate = self
    }
    
    /// When the view is resized, adjust the canvas scale so that it is zoomed to the default `canvasWidth`.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let canvasScale = canvasView.bounds.width / DataModel.canvasWidth
        canvasView.minimumZoomScale = canvasScale
        canvasView.maximumZoomScale = canvasScale
        canvasView.zoomScale = canvasScale
        
        // Scroll to the top.
        updateContentSizeForDrawing()
        canvasView.contentOffset = CGPoint(x: 0, y: -canvasView.adjustedContentInset.top)
    }
    
    /// When the view is removed, save the modified drawing, if any.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Update the drawing in the data model, if it has changed.
        if hasModifiedDrawing {
            dataModelController.updateDrawing(canvasView.drawing, at: drawingIndex)
        }
        
        // Remove this view controller as the screenshot delegate.
        view.window?.windowScene?.screenshotService?.delegate = nil
    }
    
    /// Hide the home indicator, as it will affect latency.
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    /// Action method: Turn finger drawing on or off, but only on devices before iOS 14.0
    @objc private func toggleFingerPencilDrawing(_ sender: Any) {
        if #available(iOS 14.0, *) { } else {
            canvasView.allowsFingerDrawing.toggle()
            _ = canvasView.allowsFingerDrawing ? "Disable Finger Drawing" : "Enable Finger Drawing"
          //  pencilFingerButton.title = title
        }
    }
    
    /// Helper method to set a new drawing, with an undo action to go back to the old one.
    func setNewDrawingUndoable(_ newDrawing: PKDrawing) {
        let oldDrawing = canvasView.drawing
        undoManager?.registerUndo(withTarget: self) {
            $0.setNewDrawingUndoable(oldDrawing)
        }
        canvasView.drawing = newDrawing
    }
    
    /// Delegate method: Note that the drawing has changed.
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        hasModifiedDrawing = true
        updateContentSizeForDrawing()
    }
    
    /// Helper method to set a suitable content size for the canvas view.
    func updateContentSizeForDrawing() {
        // Update the content size to match the drawing.
        let drawing = canvasView.drawing
        let contentHeight: CGFloat
        
        // Adjust the content size to always be bigger than the drawing height.
        if !drawing.bounds.isNull {
            contentHeight = max(canvasView.bounds.height, (drawing.bounds.maxY + AlbumController.canvasOverscrollHeight) * canvasView.zoomScale)
        } else {
            contentHeight = canvasView.bounds.height
        }
        canvasView.contentSize = CGSize(width: DataModel.canvasWidth * canvasView.zoomScale, height: contentHeight)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        recorder = nil
        player = nil
    }
    
    @objc private func record(_ sender: UIButton) {
        
        print("\(#function)")
        
        if player != nil && player.isPlaying {
            print("stopping")
            player.stop()
        }
        
        if recorder == nil {
            print("recording. recorder nil")
            recordButton.setTitle("Pause", for: .normal)
            playButton.isEnabled = false
            stopButton.isEnabled = true
            recordWithPermission(true)
            return
        }
        
        if recorder != nil && recorder.isRecording {
            print("pausing")
            recorder.pause()
            recordButton.setTitle("Continue", for: .normal)
            
        } else {
            print("recording")
            recordButton.setTitle("Pause", for: .normal)
            playButton.isEnabled = false
            stopButton.isEnabled = true
            //            recorder.record()
            recordWithPermission(false)
        }
    }
    
    /// Action method: Turn finger drawing on or off, but only on devices before iOS 14.0
  //  @objc private func toggleFingerPencilDrawing(_ sender: Any) {
    //    if #available(iOS 14.0, *) { } else {
      //      canvasView.allowsFingerDrawing.toggle()
        //    let title = canvasView.allowsFingerDrawing ? "Disable Finger Drawing" : "Enable Finger Drawing"
          //  pencilFingerBarButtonItem.title = title
       // }
   // }
    
    @objc private func stop(_ sender: UIButton) {
        
        print("\(#function)")
        
        recorder?.stop()
        player?.stop()
        
        meterTimer.invalidate()
        
        recordButton.setTitle("Record", for: .normal)
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
            playButton.isEnabled = true
            stopButton.isEnabled = false
            recordButton.isEnabled = true
        } catch {
            print("could not make session inactive")
            print(error.localizedDescription)
        }
        
        //recorder = nil
    }
    
    @objc private func play(_ sender: UIButton) {
        print("\(#function)")
        
        var url: URL?
        if self.recorder != nil {
            url = self.recorder.url
        } else {
            url = self.soundFileURL!
        }
        print("playing \(String(describing: url))")
        
        do {
            self.player = try AVAudioPlayer(contentsOf: url!)
            stopButton.isEnabled = true
            player.delegate = self
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
        } catch {
            self.player = nil
            print(error.localizedDescription)
        }
    }
    
    func setupRecorder() {
        print("\(#function)")
        
        let format = DateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        let currentFileName = "recording-\(format.string(from: Date())).m4a"
        print(currentFileName)
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.soundFileURL = documentsDirectory.appendingPathComponent(currentFileName)
        print("writing to soundfile url: '\(soundFileURL!)'")
        
        if FileManager.default.fileExists(atPath: soundFileURL.absoluteString) {
            // probably won't happen. want to do something about it?
            print("soundfile \(soundFileURL.absoluteString) exists")
        }
        
        let recordSettings: [String: Any] = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey: 32000,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.0
        ]
        
        
        do {
            recorder = try AVAudioRecorder(url: soundFileURL, settings: recordSettings)
            recorder.delegate = self
            recorder.isMeteringEnabled = true
            recorder.prepareToRecord() // creates/overwrites the file at soundFileURL
        } catch {
            recorder = nil
            print(error.localizedDescription)
        }
        
    }
    
    func recordWithPermission(_ setup: Bool) {
        print("\(#function)")
        
        AVAudioSession.sharedInstance().requestRecordPermission {
            [unowned self] granted in
            if granted {
                
                DispatchQueue.main.async {
                    print("Permission to record granted")
                    self.setSessionPlayAndRecord()
                    if setup {
                        self.setupRecorder()
                    }
                    self.recorder.record()
                    
                    self.meterTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                                           target: self,
                                                           selector: #selector(self.updateAudioMeter(_:)),
                                                           userInfo: nil,
                                                           repeats: true)
                }
            } else {
                print("Permission to record not granted")
            }
        }
        
        if AVAudioSession.sharedInstance().recordPermission == .denied {
            print("permission denied")
        }
    }
    
    func setSessionPlayAndRecord() {
        print("\(#function)")
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
        } catch {
            print("could not set session category")
            print(error.localizedDescription)
        }
        
        do {
            try session.setActive(true)
        } catch {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    
    /// Delegate method: Note that the tool picker has changed which part of the canvas view
    /// it obscures, if any.
    func toolPickerFramesObscuredDidChange(_ toolPicker: PKToolPicker) {
        updateLayout(for: toolPicker)
    }
    
    /// Delegate method: Note that the tool picker has become visible or hidden.
    func toolPickerVisibilityDidChange(_ toolPicker: PKToolPicker) {
        updateLayout(for: toolPicker)
    }
    
    func updateLayout(for toolPicker: PKToolPicker) {
        let obscuredFrame = toolPicker.frameObscured(in: view)
        
        // If the tool picker is floating over the canvas, it also contains
        // undo and redo buttons.
        if obscuredFrame.isNull {
            canvasView.contentInset = .zero
            navigationItem.leftBarButtonItems = []
        }
        
        // Otherwise, the bottom of the canvas should be inset to the top of the
        // tool picker, and the tool picker no longer displays its own undo and
        // redo buttons.
        else {
            canvasView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.bounds.maxY - obscuredFrame.minY, right: 0)
            navigationItem.leftBarButtonItems = [undoBarButtonitem, redoBarButtonItem]
        }
        canvasView.scrollIndicatorInsets = canvasView.contentInset
    }
    
    @objc func routeChange(_ notification: Notification) {
        print("\(#function)")
        
        if let userInfo = (notification as NSNotification).userInfo {
            print("routeChange \(userInfo)")
            
            //print("userInfo \(userInfo)")
            if let reason = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt {
                //print("reason \(reason)")
                switch AVAudioSession.RouteChangeReason(rawValue: reason)! {
                case AVAudioSessionRouteChangeReason.newDeviceAvailable:
                    print("NewDeviceAvailable")
                    print("did you plug in headphones?")
                    checkHeadphones()
                case AVAudioSessionRouteChangeReason.oldDeviceUnavailable:
                    print("OldDeviceUnavailable")
                    print("did you unplug headphones?")
                    checkHeadphones()
                case AVAudioSessionRouteChangeReason.categoryChange:
                    print("CategoryChange")
                case AVAudioSessionRouteChangeReason.override:
                    print("Override")
                case AVAudioSessionRouteChangeReason.wakeFromSleep:
                    print("WakeFromSleep")
                case AVAudioSessionRouteChangeReason.unknown:
                    print("Unknown")
                case AVAudioSessionRouteChangeReason.noSuitableRouteForCategory:
                    print("NoSuitableRouteForCategory")
                case AVAudioSessionRouteChangeReason.routeConfigurationChange:
                    print("RouteConfigurationChange")
                    
                }
            }
        }
    }
    
    func checkHeadphones() {
        print("\(#function)")
        
        // check NewDeviceAvailable and OldDeviceUnavailable for them being plugged in/unplugged
        let currentRoute = AVAudioSession.sharedInstance().currentRoute
        if !currentRoute.outputs.isEmpty {
            for description in currentRoute.outputs {
                if description.portType == AVAudioSession.Port.headphones {
                    print("headphones are plugged in")
                    break
                } else {
                    print("headphones are unplugged")
                }
            }
        } else {
            print("checking headphones requires a connection to a device")
        }
    }
    
    //Open Camera Button
    @objc func buttonAddImage(_ sender: UIBarButtonItem){
        //        self.navigationController?.pushViewController(CameraViewController(), animated: true)
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        //Alert Notification
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        //Photo From Camera
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
            else {
                print("Camera not available")
            }
        }))
        
        //Photo from Photo Library
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        
        //Cancel Button
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: - UIImagePickerControlle DidFinishMediaInfo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info [UIImagePickerController.InfoKey.originalImage] as! UIImage
        sampleImageView.image = image
        self.title = ""
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - UIImagePickerController DidCancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: AVAudioRecorderDelegate
extension AlbumController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder,
                                         successfully flag: Bool) {
        
        print("\(#function)")
        
        print("finished recording \(flag)")
        stopButton.isEnabled = false
        playButton.isEnabled = true
        recordButton.setTitle("Record", for: UIControl.State())
        
        // iOS8 and later
        let alert = UIAlertController(title: "Recorder",
                                      message: "Finished Recording",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Keep", style: .default) {[unowned self] _ in
            print("keep was tapped")
            self.recorder = nil
        })
        alert.addAction(UIAlertAction(title: "Delete", style: .default) {[unowned self] _ in
            print("delete was tapped")
            self.recorder.deleteRecording()
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder,
                                          error: Error?) {
        print("\(#function)")
        
        if let e = error {
            print("\(e.localizedDescription)")
        }
    }
    
}

// MARK: AVAudioPlayerDelegate
extension AlbumController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("\(#function)")
        
        print("finished playing \(flag)")
        recordButton.isEnabled = true
        stopButton.isEnabled = false
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("\(#function)")
        
        
        if let e = error {
            print("\(e.localizedDescription)")
        }
        
    }
}
