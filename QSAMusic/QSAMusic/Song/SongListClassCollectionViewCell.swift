//
//  SongListClassCollectionViewCell.swift
//  QSAMusic
//
//  Created by 陈少文 on 17/5/19.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

import UIKit

class SongListClassCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var classLabel: UILabel!
    
    func updata(tag: String) {
        classLabel.text = tag
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
