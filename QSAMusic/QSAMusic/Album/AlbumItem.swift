//
//  AlbumItem.swift
//  QSAMusic
//
//  Created by 陈少文 on 17/4/27.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

import UIKit

class AlbumItem: UICollectionViewCell {
    
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var name: UILabel!
    
    func update(data: NSDictionary) -> Void {
        var urlStr = data["pic_small"] as! String
        urlStr = urlStr.replaceToScreenSize(old: "_90", new: "_120")
        imgV.sd_setImage(with: URL(string: urlStr), placeholderImage: UIImage(named: "QSAMusic_p.png"))
        title.text = data["title"] as? String
        name.text = data["author"] as? String
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
