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
    
    //    let addButtonSetItemRight: UIBarButtonItem = {
    //        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: Selector(("addTapped:")))
    //        return addButton
    //    }()
    
    let backgroundAlbumView: UIImageView = {
        let bgAlbum = UIImageView ()
        bgAlbum.image = UIImage(named: "albumBG")
        return bgAlbum
    }()
    //    let albumControll: UIImageView = {
    //        let bgAlbum1 = UIImageView ()
    //        bgAlbum1.image = UIImage(named: "albumBG")
    //        return bgAlbum1
    //    }()
    //
    //    let imageLine1: UIImageView = {
    //       let line1 = UIImageView()
    //        line1.image = UIImage (named: "line1")
    //        return line1
    //    }()
    //
    //    let imageLine2: UIImageView = {
    //       let line2 = UIImageView()
    //        line2.image = UIImage (named: "line2")
    //        return line2
    //    }()
    //
    //    let buttonAdd: UIButton = {
    //       let btnAdd = UIButton()
    //        btnAdd.setImage(UIImage(named: "btnAdd"), for: .normal)
    //        return btnAdd
    //    }()
    //
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
    //
    var stories = [Story]()
    let viewControllers = UITabBarController()
    var recordings = [URL]()
    var player: AVAudioPlayer!
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(backgroundAlbumView)
//        self.view.addSubview(titleBar)
        self.view.addSubview(collectionView)
        //        self.view.addSubview(imageLine1)
        //        self.view.addSubview(imageLine2)
        //        self.view.addSubview(buttonAdd)
                navigationController?.navigationBar.transparentNavigationBar()
                setupTabBar()
                loadStories()
        ////        navigationItem.rightBarButtonItem = UIBarButtonItem (barButtonSystemItem: .add, target: self, action: #selector(didTapButton))
        ////
        //
        //        //Calling CollectionView to View Controller
        //        collectionView.delegate = self
        //        collectionView.dataSource = self
        //        collectionView.backgroundColor = .clear
        //
        //        //CollectionView Constraint
        //        self.collectionView.snp.makeConstraints { (make) in
        //            make.left.equalTo(self.view.snp_leftMargin).offset(20)
        //            make.top.equalTo(self.view.snp_topMargin).offset(20)
        //            make.right.equalTo(self.view.snp_rightMargin).offset(-20)
        //            make.bottom.equalTo(self.view.snp_bottomMargin).offset(-85)
        //        }
        //        self.backgroundAlbumView.snp.makeConstraints { (make) in
        //            make.left.equalTo(self.view.safeAreaInsets)
        //            make.top.equalTo(self.view.safeAreaInsets)
        //            make.right.equalTo(self.view.safeAreaInsets)
        //            make.bottom.equalTo(self.view.safeAreaInsets)
        //        }
        //
        //        self.buttonAdd.snp.makeConstraints { (make) in
        //            make.top.equalTo(self.titleBar.snp.top).offset(10)
        //            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-130)
        //        }
        //
        //        self.titleBar.snp.makeConstraints { (make) in
        //            make.top.equalTo(self.view).offset(30)
        //            make.left.equalTo(self.view)
        //            make.right.equalTo(self.view)
        //        }
        //
        //        self.imageLine1.snp.makeConstraints { (make) in
        //            make.top.equalTo(self.titleBar.snp.bottom).offset(10)
        //            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(100)
        //            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-100)
        //        }
        //
        //        self.imageLine2.snp.makeConstraints { (make) in
        //            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(100)
        //            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-100)
        //            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-80)
        //        }
        //        self.buttonAdd.addTarget(self, action: #selector(self.didTapButton), for: .touchUpInside)
        //    }
        //
     
        //
        //    @objc private func didTapButton(){
        ////        self.navigationController?.pushViewController(AlbumController(), animated: true)
        ////        let vc = self.navigationController?.topViewController as! AlbumController
        ////        vc.delegate = self
        //
        //        let imagePickerController = UIImagePickerController()
        //        imagePickerController.delegate = self
        //
        //        //Alert Notification
        //        let actionSheet = UIAlertController(title: "Listory would like to Access the Camera", message: "So you can take a picture from family albums", preferredStyle: .actionSheet)
        //
        //        //Photo From Camera
        //        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
        //            if UIImagePickerController.isSourceTypeAvailable(.camera){
        //                imagePickerController.sourceType = .camera
        //                self.present(imagePickerController, animated: true, completion: nil)
        //            }
        //            else {
        //                print("Camera not available")
        //            }
        //        }))
        //
        //        //Photo from Photo Library
        //        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
        //            imagePickerController.sourceType = .photoLibrary
        //            self.present(imagePickerController, animated: true, completion: nil)
        //        }))
        //
        //
        //        //Cancel Button
        //        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        //        self.present(actionSheet, animated: true, completion: nil)
        //
        //        //Popover Position
        //        if let popoverController = actionSheet.popoverPresentationController {
        //            popoverController.sourceView = self.view
        //            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        //            popoverController.permittedArrowDirections = []
        //        }
        //        self.present(actionSheet, animated: true, completion: nil)
        //    }
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

//extension ListoryAlbumController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.navigationController?.pushViewController(EditAlbumController(), animated: true)
//        let vc = self.navigationController?.topViewController as! EditAlbumController
//        vc.story = stories[indexPath.row]
//        vc.storyRow = indexPath.row
//        vc.delegate = self
//        vc.soundFileURL = URL(string: UserDefaults.standard.string(forKey: "audio")!)
//        //        return self.recordings.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.width/4.5, height: collectionView.frame.height/2)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return stories.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
//        cell.backGround.image = UIImage(data: stories[indexPath.row].image!)
//        return cell
//    }
//}
//
//class CustomCell: UICollectionViewCell {
//    var data: CustomData? {
//        didSet {
//            guard let data = data else { return }
//            backGround.image = data.image
//        }
//    }
//    
//    fileprivate let backGround: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = #imageLiteral(resourceName: "beauty1")
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = 12
//        return imageView
//    }()
//    
//    override init(frame: CGRect){
//        super.init(frame: frame)
//        contentView.addSubview(backGround)
//        self.backGround.snp.makeConstraints { (make) in
//            make.top.equalTo(self.contentView.safeAreaLayoutGuide).offset(13)
//            make.left.equalTo(self.contentView.safeAreaLayoutGuide)
//            make.right.equalTo(self.contentView.safeAreaLayoutGuide)
//            make.bottom.equalTo(self.contentView.safeAreaLayoutGuide)
//            //            make.height.equalTo(500)
//            //            make.width.equalTo(250)
//        }
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//extension ListoryAlbumController: AlbumControllerDelegate {
//    func updateStories(story: Story) {
//        stories.append(story)
//        collectionView.reloadData()
//    }
//}
//
//extension ListoryAlbumController: EditAlbumControllerDelegate {
//    func updateStories(story: Story, storyRow: Int) {
//        stories[storyRow] = story
//        collectionView.reloadData()
//    }
//}
//
//extension UINavigationBar {
//    func transparentNavigationBar() {
//        self.setBackgroundImage(UIImage(), for: .default)
//        self.shadowImage = UIImage()
//        self.isTranslucent = true
//    }
//}

extension UITabBar {
    static func setTransparentTabBar(){
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().clipsToBounds = true
    }
}
