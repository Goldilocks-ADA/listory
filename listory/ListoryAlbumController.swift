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

class ListoryAlbumController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{

    var recordings = [URL]()
    var player: AVAudioPlayer!
    
    let addButtonSetItemRight: UIBarButtonItem = {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: Selector(("addTapped:")))
        return addButton
    }()
    
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
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    var stories = [Story]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(backgroundAlbumView)
        self.view.addSubview(titleBar)
        self.view.addSubview(collectionView)
        navigationController?.navigationBar.transparentNavigationBar()
        loadStories()
        navigationItem.rightBarButtonItem = UIBarButtonItem (barButtonSystemItem: .add, target: self, action: #selector(didTapButton))
        
        //TabBarController
        let tabBarVC = UITabBarController()

//        let tb1 = UINavigationController(rootViewController: FirstListoryAlbumController())
//        let tb2 = UINavigationController(rootViewController: SecondListoryAlbumController())
//        let tb3 = UINavigationController(rootViewController: ThirdListoryAlbumController())
        
        let tb1 = FirstListoryAlbumController()
        let tb2 = SecondListoryAlbumController()
        let tb3 = ThirdListoryAlbumController()
        
        tb1.title = "Photo"
        tb2.title = "Audio"
        tb3.title = "For You"
        
        tabBarVC.setViewControllers([tb1,tb2, tb3], animated: false)
        guard let items = tabBarVC.tabBar.items else {
            return
        }
        
        let images = ["btnPhoto", "btnAudio", "btnForYou"]
        
        for x in 0..<items.count {
            items[x].image = UIImage(systemName: images[x])
        }
        
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: true)
        
        //Calling CollectionView to View Controller
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        
        //PoopOverController
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        //Alert Notification
        let actionSheet = UIAlertController(title: "Listory would like to Access the Camera", message: "So you can take a picture from family albums", preferredStyle: .actionSheet)
        
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
//        self.present(actionSheet, animated: true, completion: nil)
        
        //Popover Position
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        //CollectionView Constraint
        self.collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp_leftMargin).offset(20)
            make.top.equalTo(self.view.snp_topMargin).offset(20)
            make.right.equalTo(self.view.snp_rightMargin).offset(-20)
            make.bottom.equalTo(self.view.snp_bottomMargin).offset(-20)
        }
        self.backgroundAlbumView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.safeAreaInsets)
            make.top.equalTo(self.view.safeAreaInsets)
            make.right.equalTo(self.view.safeAreaInsets)
            make.bottom.equalTo(self.view.safeAreaInsets)
        }
        
        self.titleBar.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(30)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
        }
        self.present(actionSheet, animated: true, completion: nil)
 
    }
    
    func loadStories() {
        if let loadedStories =  DataBaseHelper.shareInstance.retrieveAllStories(){
            stories = loadedStories
        }
    }
    
    @objc private func didTapButton(){
        self.navigationController?.pushViewController(AlbumController(), animated: true)
        let vc = self.navigationController?.topViewController as! AlbumController
        vc.delegate = self
    }
}

extension ListoryAlbumController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(EditAlbumController(), animated: true)
        let vc = self.navigationController?.topViewController as! EditAlbumController
        vc.story = stories[indexPath.row]
        vc.storyRow = indexPath.row
        vc.delegate = self
        vc.soundFileURL = URL(string: UserDefaults.standard.string(forKey: "audio")!)
//        return self.recordings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/4.5, height: collectionView.frame.height/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.backGround.image = UIImage(data: stories[indexPath.row].image!)
        return cell
    }
}

class CustomCell: UICollectionViewCell {
    var data: CustomData? {
        didSet {
            guard let data = data else { return }
            backGround.image = data.image
        }
    }
    
    fileprivate let backGround: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "beauty1")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.addSubview(backGround)
        self.backGround.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView.safeAreaLayoutGuide)
            make.left.equalTo(self.contentView.safeAreaLayoutGuide)
            make.right.equalTo(self.contentView.safeAreaLayoutGuide)
            make.bottom.equalTo(self.contentView.safeAreaLayoutGuide)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ListoryAlbumController: AlbumControllerDelegate {
    func updateStories(story: Story) {
        stories.append(story)
        collectionView.reloadData()
    }
}

extension ListoryAlbumController: EditAlbumControllerDelegate {
    func updateStories(story: Story, storyRow: Int) {
        stories[storyRow] = story
        collectionView.reloadData()
    }
}

extension UINavigationBar {
    func transparentNavigationBar() {
    self.setBackgroundImage(UIImage(), for: .default)
    self.shadowImage = UIImage()
    self.isTranslucent = true
    }
}

class TabBarController: UIViewController {
    override func viewDidLoad() {
        super .viewDidLoad()
        self.view.backgroundColor = .none
    }
}

class FirstListoryAlbumController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
}

class SecondListoryAlbumController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .clear
    }
}

class ThirdListoryAlbumController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .clear
    }
}
