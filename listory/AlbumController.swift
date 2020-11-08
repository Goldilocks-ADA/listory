//
//  AlbumController.swift
//  listory
//
//  Created by Devi Mandasari on 12/10/20.
//

import UIKit
import SnapKit

class AlbumController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate,UIPopoverPresentationControllerDelegate {

    //MARK:- 1.View Creation Detail Screen
    //Camera Button
    let cameraButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.layer.cornerRadius = 33
        button.backgroundColor = .red
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    //UIImageView Camera
    let sampleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage()
        return imageView
    }()
    
    let testCode: UIImageView = {
        let image = UIImageView()
    
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        //MARK:- 2. Add Subview to Main View
        self.title = "Listory Album"
        self.view.addSubview(cameraButton)
        self.view.addSubview(sampleImageView)
        //MARK:- 3. Add Constraint
        self.cameraButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            make.width.equalTo(66)
            make.height.equalTo(66)
        }
        
        self.sampleImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.safeAreaLayoutGuide)
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.right.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.cameraButton.addTarget(self, action: #selector(buttonAddImage), for: .touchUpInside)
    }
    
    //Open Camera Button
    @objc func buttonAddImage(_ sender: UIBarButtonItem){
        //        self.navigationController?.pushViewController(CameraViewController(), animated: true)
        
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
        
        //Popover Position
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: - UIImagePickerControlle DidFinishMediaInfo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info [UIImagePickerController.InfoKey.originalImage] as! UIImage
        sampleImageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - UIImagePickerController DidCancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

