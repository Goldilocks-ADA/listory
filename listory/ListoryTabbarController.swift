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
    var id = String()
}

protocol ListoryAlbumControllerDelegate {
    func setupTabBar()
}

class ListoryTabbarController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    var stories = [Story]()
    let viewControllers = UITabBarController()
    var recordings = [URL]()
    var player: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(backgroundAlbumView)
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
        let photoTabBar = UINavigationController(rootViewController: PhotoViewController())
        photoTabBar.tabBarItem.image = UIImage (named: "photoViewOpacity")
        photoTabBar.tabBarItem.selectedImage = UIImage(named: "photoViewGreen")?.withRenderingMode(.alwaysOriginal)
//        self.tabBarController?.selectedIndex = 0
        
        let audioTabBar = UINavigationController(rootViewController: AudioViewController())
        audioTabBar.tabBarItem.image = UIImage (named: "audioPhotoViewOpacity")
        audioTabBar.tabBarItem.selectedImage = UIImage(named: "audioPhotoView")?.withRenderingMode(.alwaysOriginal)
//        self.tabBarController?.selectedIndex = 1
        
        viewControllers.setViewControllers([photoTabBar, audioTabBar], animated: false)
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


import SwiftUI

struct ListoryTabbarControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        ListoryTabbarController()
    }
}

struct ListoryTabbarController_Previews: PreviewProvider {
    static var previews: some View {
        let height = UIScreen.main.bounds.width //414
        let width = UIScreen.main.bounds.height //896
        
        ListoryTabbarControllerRepresentable()
            .previewDevice("iPad (8th generation)")
            .previewDisplayName("iPad (8th generation)")
            .previewLayout(PreviewLayout.fixed(width: CGFloat(width), height: CGFloat(height)))
    }
}
