//
//  SingerDetailCell.swift
//  QSAMusic
//
//  Created by 陈少文 on 17/6/2.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

import UIKit

class SingerDetailCell: UITableViewCell {
    
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var other: UILabel!

    func update(data: NSDictionary) {
        imgV.sd_setImage(with: URL(string: data["pic"] != nil ? (data["pic"] as! String) : (data["pic_small"] as! String)), placeholderImage: UIImage(named: "QSAMusic_p.png"))
        title.text = data["title"] as? String
        other.text = data["other"] as? String
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
