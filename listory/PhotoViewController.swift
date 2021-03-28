//
//  PhotoViewController.swift
//  listory
//
//  Created by Jogi Oktavianus on 12/11/20.
//

import UIKit
import SnapKit
import AVFoundation
import CoreData

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate & UICollectionViewDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    let backgroundAlbumView: UIImageView = {
        let bgAlbum = UIImageView ()
        bgAlbum.image = UIImage(named: "albumBG")
        return bgAlbum
    }()
    
    // below this variable is unused, will be removed
//    let albumControll: UIImageView = {
//        let bgAlbum1 = UIImageView ()
//        bgAlbum1.image = UIImage(named: "albumBG")
//        return bgAlbum1
//    }()
    
    let imageLine1: UIImageView = {
       let line1 = UIImageView()
        line1.image = UIImage (named: "line1")
        return line1
    }()
    
    let imageLine2: UIImageView = {
       let line2 = UIImageView()
        line2.image = UIImage (named: "line2")
        return line2
    }()
    
    let buttonAdd: UIButton = {
       let btnAdd = UIButton()
        var image = UIImage(named: "btnAdd")
        
        if isIOS {
            image = image?.resizeImage(targetSize: CGSize(width: 30, height: 30))
        }
        btnAdd.setImage(image, for: .normal)
        return btnAdd
    }()
    
    let titleBar: UILabel = {
        let titleLabel = UILabel()
        
        titleLabel.font = UIFont(name: "PT Sans Bold", size: isIOS ? titleLabel.font.pointSize * 2 : 50)
        
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
   
    var photos = [Photo]()
//    let viewControllers = UITabBarController()
    var recordings = [URL]()
    var player: AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(backgroundAlbumView)
        self.view.addSubview(titleBar)
        self.view.addSubview(collectionView)
        self.view.addSubview(imageLine1)
        self.view.addSubview(imageLine2)
        self.view.addSubview(buttonAdd)
        navigationController?.navigationBar.transparentNavigationBar()
        navigationController?.navigationBar.isHidden = true
        loadPhotos()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        
        // Constraint
        self.buttonAdd.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(30)
            if isIOS {
                make.right.equalTo(self.view.safeAreaLayoutGuide)
            }else {
                make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-140)
            }
        }
        
        self.collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp_leftMargin).offset(40)
            make.top.equalTo(self.view.snp_topMargin).offset(85)
            make.right.equalTo(self.view.snp_rightMargin).offset(-40)
            make.bottom.equalTo(self.view.snp_bottomMargin).offset(-30)
        }
        self.backgroundAlbumView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.safeAreaInsets)
            make.top.equalTo(self.view.safeAreaInsets)
            make.right.equalTo(self.view.safeAreaInsets)
            make.bottom.equalTo(self.view.safeAreaInsets)
        }
        
        self.titleBar.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(30)
            if isIOS {
                make.left.equalTo(self.view.safeAreaLayoutGuide)
            } else {
                make.left.equalTo(self.view)
                make.right.equalTo(self.view)
            }
        }
        
        self.imageLine1.snp.makeConstraints { (make) in
            if isIOS {
                make.top.equalTo(self.titleBar.snp.bottom)
            }else {
                make.top.equalTo(self.titleBar.snp.bottom).offset(10)
                make.left.equalTo(self.view.safeAreaLayoutGuide).offset(100)
                make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-100)
            }
        }
        
        self.imageLine2.snp.makeConstraints { (make) in
            if isIOS {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            }else {
                make.left.equalTo(self.view.safeAreaLayoutGuide).offset(100)
                make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-100)
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            }
        }
        
        self.buttonAdd.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        print("PhotoViewController")
    }
    
    @objc private func backButton(){
//        self.navigationController?.pushViewController(HomeController(), animated: true)
    }
    
    func loadPhotos() {
        if let loadedPhotos =  DataBaseHelper.shareInstance.retrieveAllPhoto(){
            photos = loadedPhotos
        }
    }
    
    @objc private func didTapButton(_ sender: Any){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        //Alert Notification
        let actionSheet = UIAlertController(title: "Add Image", message: "Would You Like To Take a Picture from: ", preferredStyle: .alert)
        
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
            self.present(imagePickerController, animated: true) {
                print("Select Photo")
            }
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
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let currentPhotoName = "Photo-\(format.string(from: Date()))"
            
            let imageDataBase = DataBaseHelper()
            addPhoto(photo: imageDataBase.addNewPhoto(name: currentPhotoName, id: currentPhotoName, image: pickedImage.pngData()!))
            print("Photo Selected")
            
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func addPhoto(photo: Photo) {
        photos.append(photo)
        collectionView.reloadData()
    }
} //Batas Kelas

extension PhotoViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = EditAlbumController()
        
        vc.hidesBottomBarWhenPushed = true
        vc.photo = photos[indexPath.row]
        vc.storyRow = indexPath.row
        vc.delegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isIOS {
            return CGSize(width: 350, height: 250)
        }
        return CGSize(width: 350, height: 300)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.backGround.image = UIImage(data: photos[indexPath.row].image!) // Need to repair
        cell.backgroundColor = UIColor(named: "white")
        cell.nameImage.text = photos[indexPath.row].name!
        return cell
    }
}

private class CustomCell: UICollectionViewCell {
    var data: CustomData? {
        didSet {
            guard let data = data else { return }
            backGround.image = data.image
        }
    }
    
    fileprivate let backGround: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(named: "albumBG")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 0
        return imageView
    }()
    
    fileprivate let nameImage: UILabel = {
       let nameFile = UILabel()
        nameFile.text = "image.jpg"
        nameFile.textAlignment = .left
        nameFile.font = UIFont(name: "PT Sans Bold", size: 20)
        nameFile.textColor = .black
        return nameFile
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.addSubview(backGround)
        contentView.addSubview(nameImage)
        self.backGround.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView.safeAreaLayoutGuide)
            make.left.equalTo(self.contentView.safeAreaLayoutGuide)
            make.right.equalTo(self.contentView.safeAreaLayoutGuide)
            make.bottom.equalTo(self.contentView.safeAreaLayoutGuide).offset(-40)
        }
        
        self.nameImage.snp.makeConstraints { (make) in
            make.top.equalTo(self.backGround.snp.bottom).offset(5)
            make.left.equalTo(self.backGround.snp.left).offset(18)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotoViewController: EditAlbumControllerDelegate {
    func updateStories(story: Story, storyRow: Int) {
        let navVC = tabBarController?.viewControllers![1] as! UINavigationController
        let vc = navVC.topViewController as! AudioViewController
        vc.addStory(story: story)
        tabBarController?.selectedIndex = 1
    }
}

extension UINavigationBar {
    func transparentNavigationBar() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
}

extension PhotoViewController: ListoryAlbumControllerDelegate {
    func setupTabBar(){
    }
}
