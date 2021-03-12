//
//  ViewController.swift
//  listory
//
//  Created by Devi Mandasari on 12/10/20.
//

import UIKit
import SnapKit

class HomeController: UIViewController, UIScrollViewDelegate {
    
    private var scrollViewFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var pageNumber: Int = 0
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
        button.setTitle("Skip", for: .normal)
        button.titleLabel?.font = UIFont(name: "PT Sans", size: 42)
        button.tintColor = UIColor(red: 96/255, green: 91/255, blue: 80/255, alpha: 1)
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setImage(UIImage(named: "nextbutton"), for: .normal)
        button.tintColor = UIColor(red: 96/255, green: 91/255, blue: 80/255, alpha: 1)
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setImage(UIImage(named: "backbutton"), for: .normal)
        button.tintColor = UIColor(red: 96/255, green: 91/255, blue: 80/255, alpha: 1)
        return button
    }()
    
    let onboardingImages = ["onboarding1", "onboarding2", "onboarding_3"] //Change image on boarding
    let onboardingTexts = ["Choose your memorable photo from your library or taking picture from your family albums", "Tell your story about the photo in recording audio mode", "Save your memorable stories with a unique name so they can be replayed in the future"]
    
    
    
    @objc
    private func skipButtonPressed(){
        UserDefaults.standard.set(true, forKey: "isFirstLaunch")
        self.navigationController?.replaceTopViewController(with: ListoryTabbarController(), animated: true)
    }
    
    @objc
    private func nextButtonPressed(){
        
        self.pageNumber += 1
        self.onboardingPageControl.currentPage = pageNumber
        self.scrollView.contentOffset.x = self.scrollView.frame.size.width * CGFloat(pageNumber)
        if(pageNumber == 2){
            skipButton.setTitle("Get Started", for: .normal)
        }else{
            skipButton.setTitle("Skip", for: .normal)
        }
        if(pageNumber == 0){
            backButton.isHidden = true
            nextButton.isHidden = false
        }else if(pageNumber == 1){
            backButton.isHidden = false
            nextButton.isHidden = false
        }else if(pageNumber == 2){
            backButton.isHidden = false
            nextButton.isHidden = true
        }
    }
    
    @objc
    private func backButtonPressed(){
        self.pageNumber -= 1
        self.onboardingPageControl.currentPage = pageNumber
        self.scrollView.contentOffset.x = self.scrollView.frame.size.width * CGFloat(pageNumber)
        if(pageNumber == 2){
            skipButton.setTitle("Get started", for: .normal)
        }else{
            skipButton.setTitle("Skip", for: .normal)
        }
        
        if(pageNumber == 0){
            backButton.isHidden = true
            nextButton.isHidden = false
        }else if(pageNumber == 1){
            backButton.isHidden = false
            nextButton.isHidden = false
        }else if(pageNumber == 2){
            backButton.isHidden = false
            nextButton.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.backgroundImageView)
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.onboardingPageControl)
        self.view.addSubview(self.skipButton)
        self.view.addSubview(self.nextButton)
        self.view.addSubview(self.backButton)
        
        //        menampilkan backButton and nextButton di masing2 halaman
        
        if(pageNumber == 0){
            backButton.isHidden = true
            nextButton.isHidden = false
        }else if(pageNumber == 1){
            backButton.isHidden = false
            nextButton.isHidden = false
        }else if(pageNumber == 2){
            backButton.isHidden = false
            nextButton.isHidden = true
        }
        
        self.scrollView.delegate = self
        
  // setting constraint
        
        self.backgroundImageView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
        
        self.scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
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
            make.width.equalTo(300)
        }
        
        self.nextButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            //            make.centerX.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(45)
            make.width.equalTo(300)
        }
        
        self.backButton.snp.makeConstraints{(make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            //            make.centerX.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(45)
            make.width.equalTo(300)
        }
        
        
        // setting action untuk all buttons
 
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        self.skipButton.addTarget(self, action: #selector(self.skipButtonPressed), for: .touchUpInside)
        self.backButton.addTarget(self, action: #selector(self.backButtonPressed), for: .touchUpInside)
        self.nextButton.addTarget(self, action: #selector(self.nextButtonPressed), for: .touchUpInside)
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.setupImageScrollView()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            pageNumber = Int(scrollView.contentOffset.x) / Int(scrollView.frame.size.width)
            self.onboardingPageControl.currentPage = Int(pageNumber)
            if(pageNumber == 2){
                skipButton.setTitle("Get Started", for: .normal)
            }else{
                skipButton.setTitle("Skip", for: .normal)
            }
            
            if(pageNumber == 0){
                backButton.isHidden = true
                nextButton.isHidden = false
            }else if(pageNumber == 1){
                backButton.isHidden = false
                nextButton.isHidden = false
            }else if(pageNumber == 2){
                backButton.isHidden = false
                nextButton.isHidden = true
            }
            
        }
    }
    
    func setupImageScrollView(){
        //        let onboardingAttributedText = Utils.setAttributedString()
        for index in 0..<self.onboardingImages.count {
            self.scrollViewFrame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            self.scrollViewFrame.size.width =  self.scrollView.frame.size.width
            self.scrollViewFrame.size.height = self.scrollView.frame.size.height - 350
            
            self.scrollViewFrame.origin.y = 80
            self.scrollViewFrame.size.height -= 80

            
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
        
            
            let label = UILabel(frame: labelFrame)
            label.text = self.onboardingTexts[index]
            label.numberOfLines = 0
            label.adjustsFontForContentSizeCategory = true
            label.textColor = UIColor(red: 96/255, green: 91/255, blue: 80/255, alpha: 1)
            label.font = UIFont(name: "PT Sans Bold", size: 60)
            label.textAlignment = .center
            
            
            
            self.scrollView.addSubview(imageView)
            self.scrollView.addSubview(label)
        }
        
        self.scrollView.contentSize = CGSize(width: (self.scrollView.frame.size.width * CGFloat(onboardingImages.count)), height: self.scrollView.frame.height)
        self.onboardingPageControl.numberOfPages = onboardingImages.count
    }
}


extension UINavigationController {
    func replaceTopViewController(with viewController: UIViewController, animated: Bool) {
        var vcs = viewControllers
        vcs[vcs.count - 1] = viewController
        setViewControllers(vcs, animated: animated)
    }
}

import SwiftUI

struct HomeControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        HomeController()
    }
}

struct HomeController_Previews: PreviewProvider {
    
    static var previews: some View {
        let height = UIScreen.main.bounds.width
        let width = UIScreen.main.bounds.height
        
        HomeControllerRepresentable()
            .previewDevice("iPad (8th generation)")
            .previewDisplayName("iPad (8th generation)")
            .previewLayout(PreviewLayout.fixed(width: CGFloat(width), height: CGFloat(height)))
    }
}
