//
//  ListoryAlbum.swift
//  listory
//
//  Created by Jogi Oktavianus on 23/10/20.
//

import UIKit
import SnapKit

struct CustomData {
    var title = String()
    var image = UIImage()
    var url = String()
}
    

class ListoryAlbumController: UIViewController {
    
    let data = [
        CustomData(title: "String", image: #imageLiteral(resourceName: "beauty1"), url: "")
    ]
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CustomeCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Listory Gallery"
        self.view.addSubview(collectionView)
        
        //Calling CollectionView to View Controller
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        
        //CollectionView Constraint
        self.collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp_leftMargin).offset(20)
            make.top.equalTo(self.view.snp_topMargin).offset(20)
            make.right.equalTo(self.view.snp_rightMargin).offset(-20)
            make.bottom.equalTo(self.view.snp_bottomMargin).offset(-20)
        }
    }
}

extension UIViewController:UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/5, height: collectionView.frame.width/5)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomeCell
        cell.backgroundColor = .black
        return cell
    }
}

class CustomeCell: UICollectionViewCell{
    
    fileprivate let backGround: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "sampleimage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        contentView.addSubview(backGround)
        
        self.backGround.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView.safeAreaLayoutGuide)
            make.left.equalTo(self.contentView.safeAreaLayoutGuide)
            make.right.equalTo(self.contentView.safeAreaLayoutGuide)
            make.bottom.equalTo(self.contentView.safeAreaLayoutGuide)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
