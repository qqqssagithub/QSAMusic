//
//  TopTableViewCell.swift
//  QSAMusic
//
//  Created by 陈少文 on 17/5/24.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

import UIKit

class TopTableViewCell: UITableViewCell {

    @IBOutlet weak var collection: UICollectionView!
    
    func update(data: [NSDictionary], superVC: QSAKitBaseViewController) {
        TopCollectionViewDelegate.shared.data = data
        TopCollectionViewDelegate.shared.superVC = superVC
        collection.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collection.register(UINib.init(nibName: "TopCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TopCollectionCell")
        collection.delegate = TopCollectionViewDelegate.shared
        collection.dataSource = TopCollectionViewDelegate.shared
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private class TopCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
        static let shared = TopCollectionViewDelegate()
        private override init() {}
        
        var data = [NSDictionary]()
        var superVC: QSAKitBaseViewController?
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return data.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCollectionCell", for: indexPath) as! TopCollectionViewCell
            cell.update(data: data[indexPath.row])
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let name = data[indexPath.row]["name"] as! String
            NetworkEngine.getSearch(query: name) { (result) in
                let singer = SingerDetail()
                singer.navigationName = name
                self.superVC?.navigationController?.pushViewController(singer, animated: true)
            }
        }
    }
    
}
