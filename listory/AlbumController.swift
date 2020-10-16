//
//  AlbumController.swift
//  listory
//
//  Created by Devi Mandasari on 12/10/20.
//

import UIKit
import SnapKit

class AlbumController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    //MARK:- 1.View Creation Detail Screen
    let cameraButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.backgroundColor = .red
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        //MARK:- 2. Add Subview to Main View
        self.title = "Detail Screen"
        self.view.addSubview(cameraButton)
//        self.view.addSubview(buttonAddImage())
        
        //MARK:- 3. Add Constraint
        self.cameraButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(16)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(50)
        }
        
        
    }
    
    func buttonAddImage(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        //Alert Notification
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
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
    }
}
