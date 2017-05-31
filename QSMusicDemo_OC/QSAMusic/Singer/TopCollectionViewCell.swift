//
//  TopCollectionViewCell.swift
//  QSAMusic
//
//  Created by 陈少文 on 17/5/24.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

import UIKit

class TopCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    func update(data: NSDictionary) {
        imgV.sd_setImage(with: URL(string: data["avatar_middle"] as! String), placeholderImage: UIImage(named: "QSAMusic_p.png"))
        name.text = data["name"] as? String
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
