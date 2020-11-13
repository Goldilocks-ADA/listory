//
//  PhotoViewController.swift
//  listory
//
//  Created by Jogi Oktavianus on 12/11/20.
//

import UIKit

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .none

        self.view.addSubview(buttonAdd)
        self.view.addSubview(buttonBack)
        
        self.buttonAdd.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(30)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-130)
        }
        
        self.buttonBack.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(40)
            make.left.equalTo(self.view).offset(150)
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
