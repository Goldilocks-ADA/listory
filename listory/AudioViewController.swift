//
//  PhotoViewController.swift
//  listory
//
//  Created by Jogi Oktavianus on 12/11/20.
//

import UIKit
import SnapKit
import AVFoundation
import CoreData

class AudioViewController: UIViewController, UIImagePickerControllerDelegate & UICollectionViewDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    let backgroundAlbumView: UIImageView = {
        let bgAlbum = UIImageView ()
        bgAlbum.image = UIImage(named: "albumBG")
        return bgAlbum
    }()
      
    let imageLine1: UIImageView = {
       let line1 = UIImageView()
        line1.image = UIImage (named: "line1")
        return line1
    }()
    
    let imageLine2: UIImageView = {
       let line2 = UIImageView()
        line2.image = UIImage (named: "line2")
        return line2
    }()

    let buttonSelect: UIButton = {
        let btnSelect = UIButton()
        var image = UIImage(named: "btnSelect")
        
        if isIOS {
           // image = image?.resizeImage(targetSize: CGSize(width: 30, height: 30))
            btnSelect.setTitle("Select", for: .normal)
            btnSelect.setTitleColor(UIColor(named: "white2"), for: .normal)
            btnSelect.titleLabel?.font = UIFont(name: "PT Sans Bold", size: 27)
            btnSelect.backgroundColor = UIColor(named: "grey4")
            btnSelect.layer.cornerRadius = 22
            btnSelect.clipsToBounds = true
            btnSelect.contentEdgeInsets = UIEdgeInsets(top: 5,left: 20,bottom: 5,right: 20)
        } else {
        btnSelect.setTitle("Select", for: .normal)
        btnSelect.setTitleColor(UIColor(named: "white2"), for: .normal)
        btnSelect.titleLabel?.font = UIFont(name: "PT Sans Bold", size: 27)
        btnSelect.backgroundColor = UIColor(named: "grey4")
        btnSelect.layer.cornerRadius = 22
        btnSelect.clipsToBounds = true
        btnSelect.contentEdgeInsets = UIEdgeInsets(top: 5,left: 20,bottom: 5,right: 20)
        }
        return btnSelect
    }()
    
    let buttonTrash: UIButton = {
        let btnTrash = UIButton()
        var image = UIImage(systemName: "trash")
        if isIOS {
            image = image?.resizeImage(targetSize: CGSize(width: 30, height: 30))
        } else {
            image = image?.resizeImage(targetSize: CGSize(width: 45, height: 45))
        }
        image = image?.withTintColor(UIColor(named: "grey3")!)
        
        btnTrash.setImage(image, for: .normal)
        return btnTrash
    }()
    
    let titleBar: UILabel = {
        let titleLabel = UILabel()
        
        titleLabel.font = UIFont(name: "PT Sans Bold", size: isIOS ? titleLabel.font.pointSize * 2 : 50)
        
        titleLabel.text = "Audio Album Photo"
        titleLabel.textColor = .darkGray
        titleLabel.textAlignment = .center
        return titleLabel
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
    var recordings = [URL]()
    var player: AVAudioPlayer!
    var storiesObjectIDs: [NSManagedObjectID] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AudioViewController");
        self.view.addSubview(backgroundAlbumView)
        self.view.addSubview(titleBar)
        self.view.addSubview(collectionView)
        self.view.addSubview(imageLine1)
        self.view.addSubview(imageLine2)
        self.view.addSubview(buttonSelect)
        self.view.addSubview(buttonTrash)
        navigationController?.navigationBar.transparentNavigationBar()
        navigationController?.navigationBar.isHidden = true
        
//        setupTabBar()
        loadStories()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        
        // Constraint
        
        self.buttonSelect.snp.makeConstraints{ constraintMaker in
            if isIOS {
                constraintMaker.top.equalTo(self.view).offset(25)
                constraintMaker.right.equalTo(self.view.safeAreaLayoutGuide).offset(-40)
            } else {
            constraintMaker.top.equalTo(self.view).offset(35)
            constraintMaker.right.equalTo(self.view.safeAreaLayoutGuide).offset(-150)
            }
        }
        
        self.buttonTrash.snp.makeConstraints { (constraintMaker) in
            constraintMaker.top.equalTo(self.view).offset(30)
            if isIOS {
                constraintMaker.right.equalTo(self.view.safeAreaLayoutGuide)
            }else {
                constraintMaker.top.equalTo(self.view).offset(35)
                constraintMaker.right.equalTo(self.view.safeAreaLayoutGuide).offset(-90)
            }
        }
        
        //Collection view cell
        self.collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp_leftMargin).offset(40)
            make.top.equalTo(self.view.snp_topMargin).offset(85)
            make.right.equalTo(self.view.snp_rightMargin).offset(-40)
            make.bottom.equalTo(self.view.snp_bottomMargin).offset(-30)
        }
        self.backgroundAlbumView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.safeAreaInsets)
            make.top.equalTo(self.view.safeAreaInsets)
            make.right.equalTo(self.view.safeAreaInsets)
            make.bottom.equalTo(self.view.safeAreaInsets)
        }
        
        self.titleBar.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(30)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
        }
        
        self.imageLine1.snp.makeConstraints { (make) in
            if isIOS {
                make.top.equalTo(self.titleBar.snp.bottom)
            }else {
                make.top.equalTo(self.titleBar.snp.bottom).offset(10)
                make.left.equalTo(self.view.safeAreaLayoutGuide).offset(100)
                make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-100)
            }
        }
        
        self.imageLine2.snp.makeConstraints { (make) in
            if isIOS {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            }else {
                make.left.equalTo(self.view.safeAreaLayoutGuide).offset(100)
                make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-100)
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            }
        }
        
        self.buttonSelect.addTarget(self, action: #selector(buttonSelectTapped), for: .touchUpInside)
        self.buttonTrash.addTarget(self, action: #selector(buttonTrashTapped), for: .touchUpInside)
    }

    func loadStories() {
        if let loadedStories =  DataBaseHelper.shareInstance.retrieveAllStories(){
            stories = loadedStories
        }
    }
    
    @objc private func buttonSelectTapped(_ sender: UIButton) {
        if sender.currentTitle == "Select" {
            sender.setTitle("Cancel", for: .normal)
            self.collectionView.allowsMultipleSelection = true
            self.buttonTrash.isEnabled = true
        } else {
            sender.setTitle("Select", for: .normal)
            self.collectionView.allowsMultipleSelection = false
            storiesObjectIDs = []
            self.buttonTrash.isEnabled = false
        }
        guard let selectedItems = self.collectionView.indexPathsForSelectedItems else { return }
        for indexPath in selectedItems {
            self.collectionView.deselectItem(at: indexPath, animated: true)
        }

        var image = self.buttonTrash.currentImage
        image = image?.withTintColor(UIColor(named: "grey3")!)
        self.buttonTrash.setImage(image, for: .normal)
    }
    
    @objc private func buttonTrashTapped(_ sender: UIButton) {
        if storiesObjectIDs.count > 0 {
            let many = storiesObjectIDs.count > 1 ? "s" : ""
            let actionSheet = UIAlertController(title: "", message: "Are you sure want to delete this audio album photo\(many)?", preferredStyle: .alert)
     
            actionSheet.addAction(UIAlertAction(title: "Delete File\(many)", style: .destructive, handler: { _ in
                DataBaseHelper.shareInstance.deleteStories(objectIDs: self.storiesObjectIDs)
                self.loadStories()
                self.collectionView.reloadData()
                self.buttonSelectTapped(self.buttonSelect)
            } ))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    func addStory(story: Story) {
        stories.append(story)
        collectionView.reloadData()
    }
    
    func formatTime(timeInterval: Double) -> String {
        let min = Int(timeInterval / 60)
        let sec = Int(timeInterval.truncatingRemainder(dividingBy: 60))
        let s = String(format: "%02d:%02d", min, sec)
        return s
    }
} //Batas Kelas

extension AudioViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = PreviewViewController()
        let searchPaths: [String] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        let documentPath_ = searchPaths.first!
        let audioPath = String(stories[indexPath.row].audioPath!)
        let selectedSound = "\(documentPath_)/\(audioPath)"
        let url: URL = URL(fileURLWithPath: selectedSound)
        
        vc.story = stories[indexPath.row]
        vc.storyRow = indexPath.row
        vc.soundFileURL = url
        
        let cell = collectionView.cellForItem(at: indexPath) as! CustomCell
        
        if self.collectionView.allowsMultipleSelection {
            guard let selectedItems = self.collectionView.indexPathsForSelectedItems else { return }
            
            let story = stories[indexPath.row]
            storiesObjectIDs.append(story.objectID)
            
            var image = self.buttonTrash.currentImage
            image = image?.withTintColor(UIColor(named: "greenDark")!)
            self.buttonTrash.setImage(image, for: .normal)
            
        } else {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CustomCell
        guard let selectedItems = self.collectionView.indexPathsForSelectedItems else { return }
        
        if (selectedItems.count == 0){
            var image = self.buttonTrash.currentImage
            image = image?.withTintColor(UIColor(named: "grey3")!)
            self.buttonTrash.setImage(image, for: .normal)
        }
        
        let story = stories[indexPath.row]
        
        storiesObjectIDs.removeAll(where: { story.objectID ==  $0 })
        print(storiesObjectIDs.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 350, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.backGround.image = UIImage(data: stories[indexPath.row].image!) // Need to repair
        
        cell.backgroundColor = UIColor(named: "white")
        
        cell.nameImage.text = stories[indexPath.row].name!
        cell.lenghtDuration.text = "\(formatTime(timeInterval: stories[indexPath.row].audioDuration)) sec"
        return cell
    }
}

private class CustomCell: UICollectionViewCell {
    
    var data: CustomData? {
        didSet {
            guard let data = data else { return }
            backGround.image = data.image
        }
    }
    
    fileprivate let backGround: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "albumBG")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 0
        return imageView
    }()
    
    fileprivate var nameImage: UILabel = {
       let nameFile = UILabel()
        nameFile.text = ""
        nameFile.textAlignment = .left
        nameFile.font = UIFont(name: "PT Sans Bold", size: 20)
        nameFile.textColor = .black
        return nameFile
    }()
    
    fileprivate let lenghtDuration: UILabel = {
        let lenght = UILabel()
        lenght.text = ""
        lenght.textAlignment = .center
        lenght.textColor = UIColor(named: "grey2")
        lenght.font = UIFont(name: "PT Sans Regular", size: 20)
        return lenght
    }()
    
    fileprivate let iconSpeaker: UIImageView = {
        var image = UIImage(systemName: "speaker.3.fill")
        let imageView = UIImageView()
        
        image?.withTintColor(.black)
        image = image?.resizeImage(targetSize: CGSize(width: 60, height: 60))
        imageView.image = image
        return imageView
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.addSubview(backGround)
        contentView.addSubview(nameImage)
        contentView.addSubview(lenghtDuration)
        contentView.addSubview(iconSpeaker)
        
        self.backGround.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView.safeAreaLayoutGuide)
            make.left.equalTo(self.contentView.safeAreaLayoutGuide)
            make.right.equalTo(self.contentView.safeAreaLayoutGuide)
            make.bottom.equalTo(self.contentView.safeAreaLayoutGuide).offset(-60)
        }
        
        self.nameImage.snp.makeConstraints { (make) in
            make.top.equalTo(self.backGround.snp.bottom).offset(5)
            make.left.equalTo(self.backGround.snp.left).offset(18)
        }
        
        self.lenghtDuration.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameImage.snp.bottom)
            make.left.equalTo(self.nameImage.snp.left)
        }
        
        self.iconSpeaker.snp.makeConstraints{ make in
            make.top.equalTo(self.nameImage.snp.top)
            make.right.equalTo(self.backGround.snp.right).offset(-10)
        }
        
        self.selectedBackgroundView = {
            let bgView = UIView()
            bgView.backgroundColor = UIColor.init(displayP3Red: 137/256, green: 214/256, blue: 151/256, alpha: 100/256)
            return bgView
        }()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AudioViewController: AlbumControllerDelegate {
    func updateStories(story: Story) {
        stories.append(story)
        collectionView.reloadData()
    }
}

extension AudioViewController: EditAlbumControllerDelegate {
    func updateStories(story: Story, storyRow: Int) {
        stories[storyRow] = story
        collectionView.reloadData()
    }
}


extension AudioViewController: ListoryAlbumControllerDelegate {
    func setupTabBar(){}
}
