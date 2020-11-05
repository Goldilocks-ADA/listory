//
//  ViewController.swift
//  listory
//
//  Created by Devi Mandasari on 12/10/20.
//

import UIKit
import SnapKit

class HomeController: UIViewController {

//    //MARK: 1. View Creation
    var position = 0
    
    let onboardingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "onboarding_1")
        return imageView
    }()
    
    @objc func tapDetected() {
        if position == 0 {
            onboardingImageView.image = UIImage(named: "onboarding_2")
            self.position += 1
        }else if(position == 1){
            onboardingImageView.image = UIImage(named: "onboarding_3")
            self.position += 1
        }else{
            UserDefaults.standard.set(true, forKey: "isFirstLaunch")
            self.navigationController?.pushViewController(ListoryAlbumController(), animated: true)
        }
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Onboarding Screen"
        self.view.backgroundColor = .white
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        onboardingImageView.isUserInteractionEnabled = true
        onboardingImageView.addGestureRecognizer(singleTap)
//        //MARK: 2. Add subview to main view
        self.view.addSubview(onboardingImageView)
//        self.view.addSubview(startButton)
//
//        //MARK: 3. Add constraint
        self.onboardingImageView.snp.makeConstraints{ (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.equalTo(self.view.safeAreaLayoutGuide)
            make.right.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)

            
        }
//
//
//        self.startButton.snp.makeConstraints{(make) in
//            make.centerX.equalTo(self.view.safeAreaLayoutGuide)
//            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-60)
//            make.height.equalTo(67)
        }

//        self.startButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
//    }
//
//    @objc private func nextButtonPressed(){
//        self.navigationController?.pushViewController(DashBoardViewController(), animated: true)
//    }
}
//class Core {
//    static let shared = Core()
//
//    func isNewUser() -> Bool {
//        return !UserDefaults.standard.bool(forKey: "isNewUser")
//    }
//
//    ///
//    func setIsNotNewUser() -> Bool {
//        UserDefaults.standard.set(true, forKey: "isNewUser")
//    }
//}
