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
    
//    let backgroundAlbumView: UIImageView = {
//        let bgAlbum = UIImageView ()
//        bgAlbum.image = UIImage(named: "albumBG")
//        return bgAlbum
//    }()
    
    let playBtn: UIButton = {
        let play = UIButton()
        play.setImage(UIImage(named: "playBtn"), for: .normal)
        return play
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.addSubview(sampleImageView)
//        self.view.addSubview(backgroundAlbumView)

        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true

        setupData()
        setupView()
        self.view.addSubview(playBtn)
        self.view.addSubview(forwardBtn)
        self.view.addSubview(backwardBtn)
//        self.backgroundAlbumView.snp.makeConstraints { (make) in
//            make.left.equalTo(self.view.safeAreaInsets)
//            make.top.equalTo(self.view.safeAreaInsets)
//            make.right.equalTo(self.view.safeAreaInsets)
//            make.bottom.equalTo(self.view.safeAreaInsets)
//        }
        
//        self.sampleImageView.snp.makeConstraints { (make) in
//            make.left.equalTo(self.view.safeAreaLayoutGuide)
//            make.right.equalTo(self.view.safeAreaLayoutGuide)
//            make.top.equalTo(self.view.safeAreaLayoutGuide)
//            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
//        }
        
        
        
        self.backwardBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view).offset(-30)
            make.right.equalTo(self.playBtn.snp.right).offset(-50)
        }
        
        self.playBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view).offset(-25)
            make.left.equalTo(self.view.center)
        }
        
        self.forwardBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view).offset(-30)
            make.left.equalTo(self.playBtn.snp.left).offset(50)
        }
    }
    
    func setupView(){
        view.addSubview(backgroundView)

        //layer 1
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
//        
        backgroundView.addSubview(backgroundImageView)
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        backgroundImageView.addSubview(backgroundImageView2)
        backgroundImageView2.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        backgroundImageView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        backgroundImageView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        backgroundImageView2.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        backgroundView.addSubview(canvasView)
        canvasView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        canvasView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        canvasView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0).isActive = true
        canvasView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -0).isActive = true
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

}
