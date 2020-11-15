//
//  PreviewViewController.swift
//  listory
//
//  Created by Devi Mandasari on 15/11/20.
//

import UIKit
import AVFoundation
import SnapKit
import PencilKit
import PhotosUI

class PreviewViewController: UIViewController, PKCanvasViewDelegate {

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
    
    let playBtn: UIButton = {
        let play = UIButton()
        play.setImage(UIImage(named: "playBtn"), for: .normal)
        return play
    }()
    
//    let pauseBtn: UIButton = {
//        let pause = UIButton()
//        pause.setImage(UIImage(named: "pauseBtn"), for: .normal)
//        return pause
//    }()
    
    let backwardBtn: UIButton = {
        let backward = UIButton()
        backward.setImage(UIImage(named: "Rewind"), for: .normal)
        return backward
    }()
    
    let forwardBtn: UIButton = {
        let forward = UIButton()
        forward.setImage(UIImage(named: "Forward"), for: .normal)
        return forward
    }()
    
    let backBtn: UIButton = {
        let back = UIButton()
        back.setImage(UIImage(named: "backbutton"), for: .normal)
        return back
    }()
    
    let volumeSlider: UISlider = {
        let slider = UISlider(frame:CGRect(x: 10, y: 100, width: 300, height: 20))
        slider.minimumValue = 0
        slider.maximumValue = 1.0
        slider.isContinuous = true
        slider.tintColor = UIColor.black
        return slider
    }()
    
    let playRecordSlider: UISlider = {
        let recordSlider = UISlider(frame:CGRect(x: 10, y: 100, width: 300, height: 20))
        recordSlider.minimumValue = 0
        recordSlider.maximumValue = 1.0
        recordSlider.isContinuous = true
        recordSlider.tintColor = UIColor.black
        return recordSlider
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
    var storyRow: Int!
    var story: Story!
    var musicIdentifier: String?
    var recordingSession: AVAudioSession!
    var isWithAudio : Bool = false
    var currentVolume: Float = 1.0
    var currentTime: TimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playBtn.isEnabled = true
        navigationController?.navigationBar.isHidden = true

        setupData()
        setupView()
        self.view.addSubview(backBtn)
        self.view.addSubview(playBtn)
        self.view.addSubview(forwardBtn)
        self.view.addSubview(backwardBtn)
        self.view.addSubview(playRecordSlider)
        self.view.addSubview(volumeSlider)
        self.view.addSubview(statusLabel)
        
        self.backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(30)
            make.top.equalTo(self.view).offset(40)
        }
        
        self.backwardBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view).offset(-30)
            make.right.equalTo(self.playBtn.snp.right).offset(-50)
        }
        
        self.statusLabel.snp.makeConstraints{(make)in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(100)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(150 )
        }
        
        self.playBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view).offset(-25)
            make.left.equalTo(self.view.center)
        }
        
//        self.pauseBtn.snp.makeConstraints { (make) in
//            make.bottom.equalTo(self.view).offset(-25)
//            make.left.equalTo(self.view.center)
//        }
        
        self.forwardBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view).offset(-30)
            make.left.equalTo(self.playBtn.snp.left).offset(50)
        }
        
        self.volumeSlider.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view).offset(-30)
            make.left.equalTo(self.forwardBtn.snp.right).offset(100)
            make.size.equalTo(CGSize(width: 300, height: 20))
        }
        
        self.playRecordSlider.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view).offset(-30)
            make.right.equalTo(self.backwardBtn.snp.right).offset(-100)
            make.size.equalTo(CGSize(width: 300, height: 20))
        }
        
        self.backBtn.addTarget(self, action: #selector(backButton), for: .touchUpInside)
        self.playBtn.addTarget(self, action: #selector(play), for: .touchUpInside)
        self.volumeSlider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .touchUpInside)
        self.playRecordSlider.addTarget(self, action: #selector(sliderPlayRecordDidChange(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        player?.stop()
    }
    
    func setupView(){
        view.addSubview(backgroundView)

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
        canvasView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0).isActive = true
        canvasView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -0).isActive = true
    }
    
    @objc func backButton(){
        navigationController?.pushViewController(AudioViewController(), animated: false)
    }
    
    func setupData(){
        if let image = story.image{
            sampleImageView.image = UIImage(data: image)
            print("image can not be loaded \(image)")
        }
        if let drawing = story.drawing{
            do {
                try canvasView.drawing = PKDrawing(data: drawing)
            } catch {
                print("cannot load data drawing")
            }
        }
    }
    
    @objc func play() {

        print("audio sekarang \(soundFileURL.absoluteString)  \(soundFileURL.absoluteURL)")
        
        if (player != nil) {
            if player.isPlaying {
                playBtn.setImage(UIImage(named: "playBtn"), for: .normal)
                player.pause()
            } else {
                playBtn.setImage(UIImage(named: "pauseBtn"), for: .normal)
                player.play()
            } 
        } else {
            do {
                print("audio f1")
                self.player = try AVAudioPlayer(contentsOf: soundFileURL.absoluteURL)
                print("audio fo")
                player.prepareToPlay()
                player.delegate = self
                player.volume = currentVolume
                volumeSlider.setValue(currentVolume, animated: true)
                playRecordSlider.maximumValue = Float(round(player.duration))
                playRecordSlider.setValue(Float(currentTime), animated: true)
                player.currentTime = currentTime
                Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
                player.play()
                playBtn.setImage(UIImage(named: "pauseBtn"), for: .normal)

            } catch {
                self.player = nil
                print(error.localizedDescription)
                print("AVAudioPlayer init failed")
            }
        }
    }
    
    @objc func updateTime(_ timer: Timer) {
        playRecordSlider.value = Float(player.currentTime)
        // Update label
        
        //Update label 
    }
    
    @objc func sliderValueDidChange(_ sender:UISlider!){
        print("Slider value changed")
        player?.volume = sender.value
        currentVolume = sender.value
//           // Use this code below only if you want UISlider to snap to values step by step
        print("Slider step value \((sender.value))")
       }
    
    @objc func sliderPlayRecordDidChange(_ sender: UISlider!){
        player?.play(atTime: TimeInterval(sender.value))
        print("Time Interval \((sender.value))")
        currentTime = TimeInterval(sender.value)
        player?.currentTime = TimeInterval(sender.value)
    }
       
       override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           // Dispose of any resources that can be recreated.
       }
    
    
//    @objc func updateAudioMeter(_ timer: Timer) {
//
//        if let player = self.player {
//            if player.play() {
//                let min = Int(player.currentTime / 60)
//                let sec = Int(player.currentTime.truncatingRemainder(dividingBy: 60))
//                let s = String(format: "%02d:%02d", min, sec)
//                statusLabel.text = s
//                recorder.updateMeters()
//            }
//        }
//    }
    
    }


// MARK: AVAudioPlayerDelegate
extension PreviewViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("\(#function)")
        print("finished playing \(flag)")
        playBtn.setImage(UIImage(named: "playBtn"), for: .normal)
        self.player = nil
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("\(#function)")
        if let e = error {
            print("\(e.localizedDescription)")
        }
    }
}
