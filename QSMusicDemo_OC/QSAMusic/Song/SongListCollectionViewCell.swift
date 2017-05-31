//
//  SongListCollectionViewCell.swift
//  QSAMusic
//
//  Created by 陈少文 on 17/5/19.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

import UIKit

class SongListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var num: UILabel!
    @IBOutlet weak var title: UILabel!
    
    func update(songList: NSDictionary) {
        imgV.sd_setImage(with: URL(string: songList["pic_300"] as! String), placeholderImage: UIImage(named: "QSAMusic_p.png"))
        num.text = songList["listenum"] as? String
        title.text = songList["title"] as? String
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
