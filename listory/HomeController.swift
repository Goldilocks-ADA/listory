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
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Batam, 20 Februari 2020"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    let sampleImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "sampleimage")
        //imageView.backgroundColor = .green
       return imageView
    }()
    
    let greetingLabel: UILabel = {
        let label = UILabel()
        label.text = "Selamat Pagi"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hari libur gak pergi ke luar rumah kan? Yuk kumpul bersama keluarga. Ini adalah saat yang tepat. Luangkan waktu bersama mereka."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.backgroundColor = .red
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        //MARK: 2. Add subview to main view
        self.view.addSubview(dateLabel)
        self.view.addSubview(sampleImageView)
        self.view.addSubview(greetingLabel)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(nextButton)
        
        //MARK: 3. Add constraint
        self.dateLabel.snp.makeConstraints{(make)in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(16)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(16)
        }
        
        self.sampleImageView.snp.makeConstraints{ (make) in
            make.top.equalTo(self.dateLabel.snp.bottom).offset(16)
           make.left.equalTo(self.view.safeAreaLayoutGuide).offset(16)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(200)
            
        }
        
        self.greetingLabel.snp.makeConstraints{(make)in
            make.top.equalTo(self.sampleImageView.snp.bottom).offset(16)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(16)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
            
        }
        
        self.descriptionLabel.snp.makeConstraints{(make) in
            make.top.equalTo(self.greetingLabel.snp.bottom).offset(16)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(16)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
        }
        
        self.nextButton.snp.makeConstraints{(make) in
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(16)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(50)
        }
        
        self.navigationController?.navigationBar.barTintColor = .red
        self.title = "Home Screen"
       // self.navigationController?.navigationBar.
        
        self.nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
    }

    @objc private func nextButtonPressed(){
        self.navigationController?.pushViewController(AlbumController(), animated: true)
    }


}

