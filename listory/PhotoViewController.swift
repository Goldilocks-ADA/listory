//
//  PhotoViewController.swift
//  listory
//
//  Created by Jogi Oktavianus on 12/11/20.
//

import UIKit

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate & UICollectionViewDelegate, UINavigationControllerDelegate {
    
    let buttonAdd: UIButton = {
       let btnAdd = UIButton()
        btnAdd.setImage(UIImage(named: "btnAdd"), for: .normal)
        return btnAdd
    }()
    
    let buttonBack: UIButton = {
        let backBtn = UIButton()
        backBtn.setImage(UIImage(named: "backbutton"), for: .normal)
        return backBtn
    }()
    
    let backgroundAlbumView: UIImageView = {
        let bgAlbum = UIImageView ()
        bgAlbum.image = UIImage(named: "albumBG")
        return bgAlbum
    }()
    
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
    
//    let buttonAdd: UIButton = {
//       let btnAdd = UIButton()
//        btnAdd.setImage(UIImage(named: "btnAdd"), for: .normal)
//        return btnAdd
//    }()
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        self.view.addSubview(backgroundAlbumView)
        self.view.addSubview(titleBar)
        self.view.addSubview(collectionView)
        self.view.addSubview(imageLine1)
        self.view.addSubview(imageLine2)

        self.view.addSubview(buttonAdd)
        self.view.addSubview(buttonBack)
        
        
        collectionView.delegate = self
//        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        
        
        self.buttonAdd.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(30)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-140)
        }
        
        self.buttonBack.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(40)
            make.left.equalTo(self.view).offset(150)
        }
 
        //CollectionView Constraint
        self.collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp_leftMargin).offset(20)
            make.top.equalTo(self.view.snp_topMargin).offset(20)
            make.right.equalTo(self.view.snp_rightMargin).offset(-20)
            make.bottom.equalTo(self.view.snp_bottomMargin).offset(-85)
        }
        self.backgroundAlbumView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.safeAreaInsets)
            make.top.equalTo(self.view.safeAreaInsets)
            make.right.equalTo(self.view.safeAreaInsets)
            make.bottom.equalTo(self.view.safeAreaInsets)
        }
        
//        self.buttonAdd.snp.makeConstraints { (make) in
//            make.top.equalTo(self.titleBar.snp.top).offset(10)
//            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-130)
//        }
        
        self.titleBar.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(30)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
        }
        
        self.imageLine1.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleBar.snp.bottom).offset(10)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(100)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-100)
        }
        
        self.imageLine2.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(100)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-100)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-80)
        }
        
        self.buttonBack.addTarget(self, action: #selector(backButton), for: .touchUpInside)
        
        self.buttonAdd.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc private func backButton(){
//        self.navigationController?.pushViewController(HomeController(), animated: true)
    }
    
    @objc private func didTapButton(){
//        self.navigationController?.pushViewController(AlbumController(), animated: true)
//        let vc = self.navigationController?.topViewController as! AlbumController
//        vc.delegate = self
        print("test")
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        //Alert Notification
        let actionSheet = UIAlertController(title: "Add Image", message: "Would You Like To Take a Picture from: ", preferredStyle: .actionSheet)
        
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
        self.present(actionSheet, animated: true, completion: nil)
        
        //Popover Position
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(actionSheet, animated: true, completion: nil)
    }
}

