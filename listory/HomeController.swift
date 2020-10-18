//
//  ViewController.swift
//  listory
//
//  Created by Devi Mandasari on 12/10/20.
//

import UIKit
import SnapKit

class HomeController: UIViewController {

    //MARK: 1. View Creation
    
    
    let onboardingImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "onboardingText")
        //imageView.backgroundColor = .green
       return imageView
    }()
    
   
    
    let startButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "onboardingStart"), for: .normal)//        button.backgroundColor = .red
//        button.setTitle("Next", for: .normal)
//        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        //MARK: 2. Add subview to main view
        self.view.addSubview(onboardingImageView)
        self.view.addSubview(startButton)
        
        //MARK: 3. Add constraint
       
        self.onboardingImageView.snp.makeConstraints{ (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
           make.left.equalTo(self.view.safeAreaLayoutGuide)
            make.right.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
       
            
        }
        
      
        self.startButton.snp.makeConstraints{(make) in
   //         make.left.equalTo(self.view.safeAreaLayoutGuide).offset(16)
    //        make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
            make.centerX.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-60)
            
            make.height.equalTo(67)
        }
        
 //       self.navigationController?.navigationBar.barTintColor = .red
 //       self.title = "Home Screen"
       // self.navigationController?.navigationBar.
        
        self.startButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
    }

    @objc private func nextButtonPressed(){
        self.navigationController?.pushViewController(DashBoardViewController(), animated: true)
    }


}

