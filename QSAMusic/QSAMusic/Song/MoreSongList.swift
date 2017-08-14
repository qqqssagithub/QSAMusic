//
//  MoreSongList.swift
//  QSAMusic
//
//  Created by 陈少文 on 17/5/19.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

import UIKit

public class MoreSongList: QSAKitBaseView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var data = NSMutableArray()
    private var page: Int = 1
    public var tags: String = ""
    
    private var footer: UICollectionReusableView!
    private lazy var bottomLabel: UILabel = {
        let bottomLabel = UILabel(frame: CGRect(x: 12.0, y: 7.0, width: SwiftMacro().ScreenWidth - 24.0, height: 16.0))
        bottomLabel.textAlignment = .center
        bottomLabel.font = UIFont.systemFont(ofSize: 12.0)
        bottomLabel.textColor = UIColor.lightGray
        bottomLabel.text = ""
        return bottomLabel
    }()
    private var bottomLabelStr: String = ""
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func draw(_ rect: CGRect) {
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:80, height:112)
        layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20)
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib(nibName: "SongListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
    }
    
    public func show(superView: UIView, title: String) {
        self.frame = CGRect(x: 0, y: SwiftMacro().ScreenHeight, width: SwiftMacro().ScreenWidth, height: SwiftMacro().ScreenHeight - 64 - 33)
        superView.addSubview(self)
        self.title.text = title
        
        getData()
        
        UIView.animate(withDuration: 0.2) {
            self.frame = CGRect(x: 0, y: 0, width: SwiftMacro().ScreenWidth, height: SwiftMacro().ScreenHeight - 64 - 33)
        }
    }
    
    private func getData(page: Int = 1) {
        if tags != "" {
            NetworkEngine.getSongListClassDetail(page: page, tag: tags, responseBlock: { (content, havemore) in
                self.updateDate(content: content, havemore: havemore)
            })
        } else {
            NetworkEngine.getRecommend(page: page, responseBlock: { (content, havemore) in
                self.updateDate(content: content, havemore: havemore)
            })
        }
    }
    
    private func updateDate(content: [NSDictionary], havemore: Int) {
        if havemore == 0 {
            self.footer.backgroundColor = UIColor(white: 0.0, alpha: 0.1)
            self.bottomLabel.text = "没有更多了"
        }
        self.bottomLabelStr = "加载完成"
        for (_, item) in content.enumerated() {
            self.data.add(item)
        }
        self.collectionView.reloadData()
    }
    
    @IBAction private func backbtn(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: { 
            self.frame = CGRect(x: 0, y: SwiftMacro().ScreenHeight, width: SwiftMacro().ScreenWidth, height: SwiftMacro().ScreenHeight - 64 - 33)
        }) { (completion) in
            self.removeFromSuperview()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: SwiftMacro().ScreenWidth, height: 30.0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
        footer.addSubview(bottomLabel)
        return footer
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SongListCollectionViewCell
        cell.update(songList: data[indexPath.row] as! NSDictionary)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let listId = (data[indexPath.row] as! NSDictionary)["listid"] as! String
        NetworkEngine.getSongListDetail(listId:  listId) { (listInfo, songList) in
            let songListDetail = SongListDetail()
            songListDetail.listInfo = listInfo
            songListDetail.songList = songList
            self.superVC.navigationController!.pushViewController(songListDetail, animated: true)
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= scrollView.contentSize.height - (SwiftMacro().ScreenHeight - 64 - 33) - 30) {
            if (bottomLabelStr != "" && bottomLabel.text != "没有更多了") {
                bottomLabelStr = "";
                page += 1
                getData(page: page)
            }
        }
    }
}

