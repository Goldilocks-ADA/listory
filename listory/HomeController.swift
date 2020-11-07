//
//  ViewController.swift
//  listory
//
//  Created by Devi Mandasari on 12/10/20.
//

import UIKit
import SnapKit

class HomeController: UIViewController {
    
    private var scrollViewFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background")
        return imageView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    let onboardingPageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 4
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black//PRMPColor.lightBlue
        pageControl.currentPage = 0
        return pageControl
    }()
    
    let skipButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("SKIP", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .largeTitle)
//        button.backgroundColor = .white
//        button.layer.borderColor = UIC //PRMPColor.primeBlue.cgColor
//        button.layer.borderWidth = 1
//        button.layer.cornerRadius = 22
        button.tintColor = UIColor(red: 96/255, green: 91/255, blue: 80/255, alpha: 1)
//        button.titleLabel?.font = PRMPFont.subHeading
        return button
    }()
    
    let onboardingImages = ["onboarding_1", "onboarding_2", "onboarding_3"]
    let onboardingTexts = ["Choose your memorable photo from your library or taking picture from your family albums", "Tell your story about the photo in recording audio mode", "Save your memorable stories with a unique name so they can be replayed in the future"]

//    //MARK: 1. View Creation
//

//    var position = 0
//
//
//    let onboardingImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "onboarding_1")
//
//        //imageView.backgroundColor = .green
//        return imageView
//    }()

//    let backgroundImageView : UIImageView = {
//        let backgroundView = UIImageView(frame: UIScreen.main.bounds)
//        backgroundView.image = UIImage(named: "background")
//        backgroundView.contentMode = .scaleAspectFill
//        return backgroundView
//    }()
    
//    let descriptionLabel : UILabel = {
//        let label = UILabel()
//        label.text = "Choose memorable photo from your libary or taking picture from your family album"
//        label.font = .preferredFont(forTextStyle: .body)
//        label.adjustsFontForContentSizeCategory = true
//        label.textColor = .init(red: 68/255, green: 68/255, blue: 68/255, alpha: 1)
//        return label
//    }()
//    let startButton: UIButton = {
//        let button = UIButton(type: UIButton.ButtonType.custom)
//        button.setImage(UIImage(named: "onboardingStart"), for: .normal)
//        return button
//    }()
//
    
//    @objc func tapDetected() {
//        if position == 0 {
//            onboardingImageView.image = UIImage(named: "onboarding_2")
//            self.position += 1
//        }else if(position == 1){
//            onboardingImageView.image = UIImage(named: "onboarding_3")
//            self.position += 1
//        }else{
//            UserDefaults.standard.set(true, forKey: "isFirstLaunch")
//            self.navigationController?.pushViewController(ListoryAlbumController(), animated: true)
//        }
//
//    }
    
    @objc
    private func nextButtonPressed(){
        UserDefaults.standard.set(true, forKey: "isFirstLaunch")
        self.navigationController?.pushViewController(ListoryAlbumController(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.backgroundImageView)
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.onboardingPageControl)
        self.view.addSubview(self.skipButton)
        
        self.scrollView.delegate = self
        
        self.backgroundImageView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
        
        self.scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(16)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(200)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-200)
        }
        
        self.onboardingPageControl.snp.makeConstraints { (make) in
            make.top.equalTo(self.scrollView.snp.bottom)//.offset(-32)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.skipButton.snp.top).offset(-40)
            make.height.equalTo(10)
        }
        
        self.skipButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(45)
            make.width.equalTo(175)
        }
        
//        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        self.skipButton.addTarget(self, action: #selector(self.nextButtonPressed), for: .touchUpInside)
        
//        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
//        onboardingImageView.isUserInteractionEnabled = true
//        onboardingImageView.addGestureRecognizer(singleTap)
////        //MARK: 2. Add subview to main view
//        self.view.addSubview(backgroundImageView)
//        self.view.addSubview(onboardingImageView)
////        self.view.addSubview(startButton)
////
////        //MARK: 3. Add constraint
//        self.onboardingImageView.snp.makeConstraints{ (make) in
//            make.centerX.equalTo(self.view.safeAreaLayoutGuide)
//            make.centerY.equalTo(self.view.safeAreaLayoutGuide)
//            make.width.equalTo(300)
//        }
//        self.backgroundImageView.snp.makeConstraints{(make) in make.left.right.top.bottom.equalTo(self.view)}
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.setupImageScrollView()
    }
    
    func setupImageScrollView(){
//        let onboardingAttributedText = Utils.setAttributedString()
        for index in 0..<self.onboardingImages.count {
            self.scrollViewFrame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            self.scrollViewFrame.size.width =  self.scrollView.frame.size.width
            self.scrollViewFrame.size.height = self.scrollView.frame.size.height - 300
            
            self.scrollViewFrame.origin.y = 80
            self.scrollViewFrame.size.height -= 80
            
//            if UIDevice.current.hasNotch {
//                self.scrollViewFrame.origin.y = 80
//                self.scrollViewFrame.size.height -= 80
//            }
                                                    
            let imageView = UIImageView(frame: self.scrollViewFrame)
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: onboardingImages[index])
            
            var labelFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
            labelFrame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            labelFrame.origin.y = self.scrollViewFrame.size.height
            labelFrame.size.width =  self.scrollView.frame.size.width
            labelFrame.size.height = self.scrollView.frame.size.height - self.scrollViewFrame.size.height
            
            labelFrame.origin.y += 80
            labelFrame.size.height -= 80
            
//            if UIDevice.current.hasNotch {
//                labelFrame.origin.y += 80
//                labelFrame.size.height -= 80
//            }
            
            let label = UILabel(frame: labelFrame)
            label.text = self.onboardingTexts[index]
            label.numberOfLines = 0
            label.font = UIFont(name: "Helvetica", size: 60)
            label.textAlignment = .center
            
            self.scrollView.addSubview(imageView)
            self.scrollView.addSubview(label)
        }
        
        self.scrollView.contentSize = CGSize(width: (self.scrollView.frame.size.width * CGFloat(onboardingImages.count)), height: self.scrollView.frame.height)
        self.onboardingPageControl.numberOfPages = onboardingImages.count
    }
}

extension HomeController {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
            self.onboardingPageControl.currentPage = Int(pageNumber)
            
//            if self.settingController == nil {
//                if pageNumber == 4 {
//                    UIView.animate(withDuration: 0.2) {
//                        self.onboardingView.nextButton.alpha = 1
//                    }
//                } else {
//                    UIView.animate(withDuration: 0.2) {
//                        self.onboardingView.nextButton.alpha = 0
//                    }
//                }
//            }
        }
    }
}
