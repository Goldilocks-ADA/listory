//
//  DashboardViewController.swift
//  listory
//
//  Created by Agus Lukmantara on 16/10/20.
//

import UIKit
import SnapKit

class DashBoardViewController: UIViewController {
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "latar")
        return imageView
    }()
    
    let startButtonRecord: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "tombolRecord"), for: .normal)
        //        button.backgroundColor = UIColor(red: 247, green: 222, blue: 159, alpha: 100)
        //        button.titleLabel?.font = .preferredFont(forTextStyle: .largeTitle)
        //        button.layer.cornerRadius = 30
        //       button.titleLabel?.adjustsFontForContentSizeCategory = true
        //        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        //        button.setTitle("START", for: .normal)
        //        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let startButtonListen: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage((UIImage(named: "tombolListen")), for: .normal)
        //        button.backgroundColor = UIColor(red: 247, green: 222, blue: 159, alpha: 100)
        //        button.titleLabel?.font = .preferredFont(forTextStyle: .largeTitle)
        //        button.layer.cornerRadius = 30
        //        button.titleLabel?.adjustsFontForContentSizeCategory = true
        //        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        //        button.setTitle("START", for: .normal)
        //        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Listory Dashboard"
        self.view.backgroundColor = .white
        self.view.addSubview(backgroundImageView)
        self.view.addSubview(startButtonRecord)
        self.view.addSubview(startButtonListen)
        
        self.backgroundImageView.snp.makeConstraints{(make) in
            //  make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.equalTo(self.view.safeAreaLayoutGuide)
            make.right.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(270)
        }
        self.startButtonRecord.snp.makeConstraints{(make) in
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(150)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-50)
            make.height.equalTo(655)
            make.width.equalTo(350)
            //  make.width.equalTo(235)
        }
        
        self.startButtonListen.snp.makeConstraints{(make) in
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-150)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-50)
            make.height.equalTo(655)
            make.width.equalTo(350)
        }
        self.startButtonRecord.addTarget(self, action: #selector(moveToAlbumController), for: .touchUpInside)
    }
    
    @objc func moveToAlbumController(){
        self.navigationController?.pushViewController(ListoryTabbarController(), animated: true)
    }
}

import SwiftUI

struct DashBoardViewControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // leave this empty
    }
    
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        DashBoardViewController()
    }
}

@available(iOS 13.0.0, *)
struct DashBoardViewController_Previews: PreviewProvider {
    
    static var previews : some View {
        let height = UIScreen.main.bounds.width
        let width = UIScreen.main.bounds.height
        DashBoardViewControllerRepresentable()
            .previewDevice("iPad (8th generation)")
            .previewDisplayName("iPad (8th generation)")
            .previewLayout(PreviewLayout.fixed(width: width, height: height))
    }
}
