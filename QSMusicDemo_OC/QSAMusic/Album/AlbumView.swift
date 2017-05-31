//
//  AlbumView.swift
//  QSAMusic
//
//  Created by 陈少文 on 17/4/26.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

import UIKit

open class AlbumView: QSAKitBaseView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:80, height:120)
        layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20)
        
        let collectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "AlbumItem", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    private let dataArr = NSMutableArray()
    private var offset: Int = 0
    
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
    
    static let shared = AlbumView(frame: CGRect(x: 0, y: 0, width: SwiftMacro().ScreenWidth, height: SwiftMacro().ScreenHeight - 64 - 33))
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.backgroundColor = UIColor.white
        
        addSubview(collectionView)
        
        self.getData(offset: offset)
    }
    
    private init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getData(offset: Int) {
        NetworkEngine.getAlbumList(offset: offset) { (albumList, havemore) in
            if havemore == 0 {
                self.footer.backgroundColor = UIColor(white: 0.0, alpha: 0.1)
                self.bottomLabel.text = "没有更多了"
            }
            self.bottomLabelStr = "加载完成"
            for (_, item) in albumList.enumerated() {
                self.dataArr.add(item)
            }
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - 代理
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: SwiftMacro().ScreenWidth, height: 30.0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
        footer.addSubview(bottomLabel)
        return footer
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AlbumItem
        cell.update(data: dataArr[indexPath.row] as! NSDictionary)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let album = dataArr[indexPath.row] as! NSDictionary
        NetworkEngine.getAlbumDetail(albumId: album["album_id"] as! String) { (albumInfo, songList) in
            let aDetails = AlbumDetails()
            aDetails.albumInfo = albumInfo
            aDetails.songList = songList
            self.superVC.navigationController!.pushViewController(aDetails, animated: true)
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= scrollView.contentSize.height - (SwiftMacro().ScreenHeight - 64 - 33) - 30) {
            if (bottomLabelStr != "" && bottomLabel.text != "没有更多了") {
                bottomLabelStr = "";
                offset += 25
                getData(offset: offset)
            }
        }
    }
}
