//
//  AlbumController.swift
//  listory
//
//  Created by Devi Mandasari on 12/10/20.
//

import UIKit
import AVFoundation
import SnapKit
import PencilKit
import PhotosUI

protocol EditAlbumControllerDelegate {
    func updateStories(story: Story, storyRow: Int)
}

let reuseIdentifier = "recordingCell"

class EditAlbumController: UIViewController, PKCanvasViewDelegate, PKToolPickerObserver, UIImagePickerControllerDelegate & UINavigationControllerDelegate,UIPopoverPresentationControllerDelegate, UIScreenshotServiceDelegate {
    
    //MARK:- 1.View Creation Detail Screen
    
    let recordButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "recordButton"), for: .normal)
        return button
    }()
    
    lazy var stopButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "stopButton"), for: .normal)
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
    
    let backBtn: UIButton = {
       let backButton = UIButton()
        backButton.setImage(UIImage(named: "backbutton"), for: .normal)
        return backButton
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    //UIImageView Camera
    let sampleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage()
        return imageView
    }()
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var backgroundImageView: UIImageView = {
        let pencilbackgroundView = UIImageView()
        pencilbackgroundView.image = UIImage(named: "albumBG")
        pencilbackgroundView.contentMode = .scaleAspectFill
        pencilbackgroundView.translatesAutoresizingMaskIntoConstraints = false
        pencilbackgroundView.clipsToBounds = true
        return pencilbackgroundView
    }()
    
    lazy var backgroundImageView2: UIImageView = {
        let pencilbackgroundView = UIImageView()
        pencilbackgroundView.image = sampleImageView.image
        pencilbackgroundView.contentMode = .scaleAspectFit
        pencilbackgroundView.translatesAutoresizingMaskIntoConstraints = false
        pencilbackgroundView.clipsToBounds = true
        return pencilbackgroundView
    }()
    
    lazy var canvasView: PKCanvasView = {
        let canvasView = PKCanvasView()
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        canvasView.tool = PKInkingTool(.marker, color: .black, width: 10)
        canvasView.delegate = self
        canvasView.drawingPolicy = .anyInput
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
        return canvasView
    }()
    
    var recorder: AVAudioRecorder!
    var player: AVAudioPlayer!
    var meterTimer: Timer!
    var soundFileURL: URL!
    var recordings = [URL]()
    var toolPicker: PKToolPicker!
    var imageDataBase = DataBaseHelper()
    var delegate: EditAlbumControllerDelegate?
    var photo: Photo!
    var storyRow: Int!
    var musicIdentifier: String?
    var recordingSession: AVAudioSession!
    var isWithAudio : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        canvasView.drawingGestureRecognizer.isEnabled = false
        setupData()
        setupView()
        self.view.addSubview(backBtn)
        self.title = "Listory Image Preview"
        self.view.addSubview(sampleImageView)
        self.tabBarController?.tabBar.isHidden = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButton))

        stopButton.isEnabled = false
        recordButton.isEnabled = true
        stopButton.isHidden = true
        
        self.view.addSubview(statusLabel)
        
        self.backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(30)
            make.top.equalTo(self.view).offset(40)
        }

        self.statusLabel.snp.makeConstraints{(make)in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(16)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(150 )
        }
        
        self.backBtn.addTarget(self, action: #selector(backButton), for: .touchUpInside)
        self.recordButton.addTarget(self, action: #selector(record), for: .touchUpInside)
    }
    
    @objc func backButton(){
        
        print("Test alert")
        let  backAlert = UIAlertController(title: "Would like you cancel the process?", message: "Press the button", preferredStyle: .actionSheet)
        
        backAlert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { action in
        print("Back to Photo Controller")
        self.navigationController?.pushViewController(PhotoViewController(), animated: true)
            
        }))
//        self.present(backAlert, animated: true, completion: nil)
        
        //Popover Position
        if let popoverController = backAlert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
//        self.present(backAlert, animated: true, completion: nil)
        self.view.window?.rootViewController?.present(backAlert, animated: true, completion: nil)
    }
    
    //MARK: - Function FOR COREDATA
    func setupData(){
        if let image = photo.image{
            sampleImageView.image = UIImage(data: image)
            print("image can not be loaded \(image)")
        }
    }
     
    @objc func saveButton() {
        if let imageData = sampleImageView.image?.pngData(){
            print("Trying to save image")
            delegate?.updateStories(story: imageDataBase.addNewStory(name: photo.name!, isWithAudio: true, image: imageData, drawing: canvasView.drawing.dataRepresentation(), audioPath: ""), storyRow: storyRow)
            self.navigationController?.popViewController(animated: true)
        }
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        recorder = nil
        player = nil
    }
    
    @objc private func record(_ sender: UIButton) {
        setupPencilKit()
        print("\(#function)")
        
        
        if player != nil && player.isPlaying {
            print("stopping")
            player.stop()
            
            recordButton.isHidden = true
            
            stopButton.isEnabled = true
        }
        
        if recorder == nil {
            recordButton.setImage(UIImage(named: "stopButton"), for: .normal)
            print("recording. recorder nil")
            print("merekam")
            stopButton.isHidden = false
            
            //stopButton.isEnabled = true
            recordWithPermission(true)
            
            return
        }
        
        if recorder != nil && recorder.isRecording {
            recorder.stop()
            

        }
        
    }
    
    @objc private func stop(_ sender: UIButton) {
        
        print("\(#function)")
        
        recorder?.stop()
        player?.stop()
        
        meterTimer.invalidate()
        
       // recordButton.setTitle("Record", for: .normal)
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
        
        stopButton.setImage(UIImage(named: "stopButton"), for: .normal)
        var url: URL?
        if self.recorder != nil {
            url = self.recorder.url
        } else {
            url = self.soundFileURL!
        }
//        print("playing \(String(describing: url))")
//        UserDefaults.standard.set("\(url!)", forKey: "audio")
        
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
        let searchPaths: [String] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        let documentPath_: String = searchPaths.first!
        let pathToSave = "\(documentPath_)/\(dateString())"
        let url: URL = URL(fileURLWithPath: pathToSave)
        self.musicIdentifier = dateString()
        self.soundFileURL = url
        
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
    
    func dateString() -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "ddMMMYY_hhmmssa"
            let fileName = formatter.string(from: Date())
            return "\(fileName).m4a"
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
    
    func setupPencilKit() {
        // Set up the tool picker
        if #available(iOS 14.0, *) {
            toolPicker = PKToolPicker()
        } else {
            let window = parent?.view.window
            toolPicker = PKToolPicker.shared(for: window!)
        }
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        toolPicker.addObserver(self)
        updateLayout(for: toolPicker)
        canvasView.becomeFirstResponder()
    }
    
    func setupView() {
        view.addSubview(backgroundView)
        view.addSubview(recordButton)
        view.addSubview(stopButton)

        //layer 1
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        backgroundView.addSubview(backgroundImageView)
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        backgroundImageView.addSubview(backgroundImageView2)
        backgroundImageView2.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        backgroundImageView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100).isActive = true
        backgroundImageView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100).isActive = true
        backgroundImageView2.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        
        backgroundView.addSubview(canvasView)
        canvasView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        canvasView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        canvasView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        canvasView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        self.recordButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view).offset(-22)
            make.centerX.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.stopButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view).offset(-22)
            make.centerX.equalTo(self.view.safeAreaLayoutGuide)
        }
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
            
        }
        canvasView.scrollIndicatorInsets = canvasView.contentInset
    }
    
    override public var shouldAutorotate: Bool {
        return false
    }
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    override public var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeRight
    }
    
    func didSelect(image: UIImage?) {
        self.backgroundImageView.image = image
    }
    
    @objc func saveImage() {
        UIGraphicsBeginImageContextWithOptions(backgroundView.bounds.size, false, UIScreen.main.scale)
        backgroundView.drawHierarchy(in: backgroundView.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if image != nil {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image!)
            }, completionHandler: {success, error in
                
            })
        }
    }

}

// MARK: AVAudioRecorderDelegate
extension EditAlbumController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder,
                                         successfully flag: Bool) {
        print("\(#function)")
        print("finished recording \(flag)")
        stopButton.isEnabled = false
        showSaveAlert()
        
     
    }
    
    func showSaveAlert(){
        let alert = UIAlertController(title: "Would You Like to Save this File", message: "(Write down the name file", preferredStyle: .alert)
        alert.addTextField()
        
        alert.addAction(UIAlertAction(title: "Sumbit", style: .default) {[unowned alert] _ in
            print("keep was tapped")
            self.saveStory(name: alert.textFields![0].text ?? self.photo.name!)
            
            
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) {[unowned self] _ in
            print("delete was tapped")
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveStory(name: String){
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let currentStoryName = "Story-\(format.string(from: Date()))"
        
        if let imageData = sampleImageView.image?.pngData(){
            delegate?.updateStories(story:  imageDataBase.addNewStory(name: currentStoryName, isWithAudio: true, image: imageData, drawing: canvasView.drawing.dataRepresentation(), audioPath: musicIdentifier!), storyRow: storyRow)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("\(#function)")
        
        if let e = error {
            print("\(e.localizedDescription)")
        }
    }
    
    func saveFile(url:URL){
        let docUrl:URL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
    let desURL = docUrl.appendingPathComponent("tmpsong.m4a") //Use file name with ext
    var downloadTask:URLSessionDownloadTask
    downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { [weak self](URLData, response, error) -> Void in
        do{
            let isFileFound:Bool? = FileManager.default.fileExists(atPath: desURL.path)
            if isFileFound == true{
                print(desURL)
            } else {
                try FileManager.default.copyItem(at: URLData!, to: desURL)
            }

        }catch let err {
            print(err.localizedDescription)
        }
    })
    downloadTask.resume()
    }
    
}

// MARK: AVAudioPlayerDelegate
extension EditAlbumController: AVAudioPlayerDelegate {
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
