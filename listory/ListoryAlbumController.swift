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

class ListoryAlbumController: UIViewController {
    
  
    let viewControllers = UITabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.transparentNavigationBar()
        setupTabBar()
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

extension UINavigationBar {
    func transparentNavigationBar() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
}

extension UITabBar {
    static func setTransparentTabBar(){
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().clipsToBounds = true
    }
}
