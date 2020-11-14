//
//  ListoryAlbum.swift
//  listory
//
//  Created by Jogi Oktavianus on 23/10/20.
//

import UIKit
import SnapKit
import AVFoundation

struct CustomData {
    var title = String()
    var image = UIImage()
    var url = String()
}

protocol ListoryAlbumControllerDelegate {
    func setupTabBar()
}

class ListoryAlbumController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let backgroundAlbumView: UIImageView = {
        let bgAlbum = UIImageView ()
        bgAlbum.image = UIImage(named: "albumBG")
        return bgAlbum
    }()
    
    let titleBar: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "PT Sans Bold", size: 50)
        titleLabel.text = "Listory Album Photo"
        titleLabel.textColor = .darkGray
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    //
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    var stories = [Story]()
    let viewControllers = UITabBarController()
    var recordings = [URL]()
    var player: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(backgroundAlbumView)
        self.view.addSubview(collectionView)
        navigationController?.navigationBar.isHidden = true
        setupTabBar()
        loadStories()
    }
    
    func loadStories() {
        if let loadedStories =  DataBaseHelper.shareInstance.retrieveAllStories(){
            stories = loadedStories
        }
    }
    
    func setupTabBar(){
        viewControllers.tabBar.barTintColor = .white
        UITabBar.setTransparentTabBar()
        let photoTabBar = PhotoViewController()
        photoTabBar.tabBarItem.image = UIImage (named: "btnPhoto")
        let audioTabBar = AudioViewController()
        audioTabBar.tabBarItem.image = UIImage (named: "btnAudio")
        let forYouTabBar = ForYouViewController()
        forYouTabBar.tabBarItem.image = UIImage (named: "btnForYou")
        
        viewControllers.setViewControllers([photoTabBar, audioTabBar, forYouTabBar], animated: false)
        viewControllers.modalPresentationStyle = .fullScreen
        self.view.addSubview(viewControllers.view)
    }
}
//^Batas akhir kelas

extension UITabBar {
    static func setTransparentTabBar(){
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().clipsToBounds = true
    }
}
