//
//  ListoryAlbum.swift
//  listory
//
//  Created by Jogi Oktavianus on 23/10/20.
//

import UIKit
import SnapKit
import AVFoundation

struct CustomData {
    var title = String()
    var image = UIImage()
    var url = String()
}

class ListoryAlbumController: UIViewController {

    var recordings = [URL]()
    var player: AVAudioPlayer!
    
    let addButtonSetItemRight: UIBarButtonItem = {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: Selector(("addTapped:")))
        return addButton
    }()
    
    let backgroundAlbumView: UIImageView = {
        let bgAlbum = UIImageView ()
        bgAlbum.image = UIImage(named: "albumBG")
        return bgAlbum
    }()
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
   
    var stories = [Story]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  //      navigationController?.navigationBar.barTintColor = .none
//        self.navigationController?.isNavigationBarHidden = true
        self.view.addSubview(backgroundAlbumView)
        self.title = "Listory Gallery"
        self.view.addSubview(collectionView)
        loadStories()
        navigationItem.rightBarButtonItem = UIBarButtonItem (barButtonSystemItem: .add, target: self, action: #selector(didTapButton))
        
        //Calling CollectionView to View Controller
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        
        //CollectionView Constraint
        self.collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp_leftMargin).offset(20)
            make.top.equalTo(self.view.snp_topMargin).offset(20)
            make.right.equalTo(self.view.snp_rightMargin).offset(-20)
            make.bottom.equalTo(self.view.snp_bottomMargin).offset(-20)
        }
        self.backgroundAlbumView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.safeAreaInsets)
            make.top.equalTo(self.view.safeAreaInsets)
            make.right.equalTo(self.view.safeAreaInsets)
            make.bottom.equalTo(self.view.safeAreaInsets)
            
        }
    }
    
    func loadStories() {
        if let loadedStories =  DataBaseHelper.shareInstance.retrieveAllStories(){
            stories = loadedStories
        }
    }
    
    @objc private func didTapButton(){
        self.navigationController?.pushViewController(AlbumController(), animated: true)
        let vc = self.navigationController?.topViewController as! AlbumController
        vc.delegate = self
    }
}

extension ListoryAlbumController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(EditAlbumController(), animated: true)
        let vc = self.navigationController?.topViewController as! EditAlbumController
        vc.story = stories[indexPath.row]
        vc.storyRow = indexPath.row
        vc.delegate = self
        vc.soundFileURL = URL(string: UserDefaults.standard.string(forKey: "audio")!)
//        return self.recordings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/4.5, height: collectionView.frame.height/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.backGround.image = UIImage(data: stories[indexPath.row].image!)
        return cell
    }
}

class CustomCell: UICollectionViewCell {
    var data: CustomData? {
        didSet {
            guard let data = data else { return }
            backGround.image = data.image
        }
    }
    
    fileprivate let backGround: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "beauty1")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
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

extension ListoryAlbumController: AlbumControllerDelegate {
    func updateStories(story: Story) {
        stories.append(story)
        collectionView.reloadData()
    }
}

extension ListoryAlbumController: EditAlbumControllerDelegate {
    func updateStories(story: Story, storyRow: Int) {
        stories[storyRow] = story
        collectionView.reloadData()
    }
}
