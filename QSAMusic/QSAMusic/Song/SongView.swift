//
//  SongView.swift
//  QSAMusic
//
//  Created by 陈少文 on 17/4/27.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

import UIKit

public class SongView: QSAKitBaseView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private lazy var collectionView: UICollectionView = {
        let layout = QSMusicGeDanCVFlowLayout()
        let lineSpacing = (SwiftMacro().ScreenWidth - (80.0 * 3)) / 4
        layout.sectionInset = UIEdgeInsetsMake(20.0, lineSpacing, 0.0, lineSpacing)
        layout.minimumLineSpacing = 20.0
        
        let collectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SongListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.register(UINib(nibName: "SongListClassCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "classCell")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    private var songListDataArr = [NSDictionary]()
    private var songListDetailsDataArr = [NSDictionary]()
    
    static let shared = SongView(frame: CGRect(x: SwiftMacro().ScreenWidth, y: 0, width: SwiftMacro().ScreenWidth, height: SwiftMacro().ScreenHeight - 64 - 33))
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.backgroundColor = UIColor.white
        
        addSubview(collectionView)
        
        self.getSongListClass()
    }
    
    private init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getSongListClass() {
        NetworkEngine.getSongListClass { (songList) in
            self.songListDataArr = songList
            self.collectionView.reloadData()
            
            NetworkEngine.getRecommend(size: 8, responseBlock: { (content, havemore) in
                self.songListDetailsDataArr = content
                self.collectionView.reloadData()
            })
        }
    }
    
    // MARK: - 代理
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return songListDataArr.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: SwiftMacro().ScreenWidth, height: 30.0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
        header.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        for view in header.subviews {
            view.removeFromSuperview()
        }
        let titleLabel = UILabel(frame: CGRect(x: 12.0, y: 7.0, width: SwiftMacro().ScreenWidth - 24.0, height: 16.0))
        titleLabel.font = UIFont.systemFont(ofSize: 12.0)
        titleLabel.textColor = UIColor.lightGray
        let songListClass = songListDataArr[indexPath.section] 
        titleLabel.text = songListClass["title"] as? String
        header.addSubview(titleLabel)
        return header
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return songListDetailsDataArr.count + 1
        }
        return Int(songListDataArr[section]["num"] as! NSNumber)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: 80, height: 112)
        }
        return CGSize(width: 80, height: 30)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SongListCollectionViewCell
            if indexPath.row != songListDetailsDataArr.count {
                cell.update(songList: songListDetailsDataArr[indexPath.row])
            } else {
                cell.update(songList: ["pic_300": "", "listenum": "", "title": "更多精选"])
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "classCell", for: indexPath) as! SongListClassCollectionViewCell
        cell.updata(tag: ((songListDataArr[indexPath.section]["tags"] as! NSArray)[indexPath.row] as! NSDictionary)["tag"] as! String)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row != songListDetailsDataArr.count {
                let listId = songListDetailsDataArr[indexPath.row]["listid"] as! String
                NetworkEngine.getSongListDetail(listId:  listId) { (listInfo, songList) in
                    let songListDetail = SongListDetail()
                    songListDetail.listInfo = listInfo
                    songListDetail.songList = songList
                    self.superVC.navigationController!.pushViewController(songListDetail, animated: true)
                }
            } else {
                let moreSongList = UINib(nibName: "MoreSongList", bundle: nil).instantiate(withOwner: nil, options: nil).first as! MoreSongList
                moreSongList.superVC = self.superVC
                let songListClass = self.songListDataArr[0]
                moreSongList.show(superView: self, title: songListClass["title"] as! String)
            }
        } else {
            let moreSongList = UINib(nibName: "MoreSongList", bundle: nil).instantiate(withOwner: nil, options: nil).first as! MoreSongList
            moreSongList.superVC = self.superVC
            moreSongList.tags = ((songListDataArr[indexPath.section]["tags"] as! NSArray)[indexPath.row] as! NSDictionary)["tag"] as! String
            moreSongList.show(superView: self, title: moreSongList.tags)
        }
    }
    
}
