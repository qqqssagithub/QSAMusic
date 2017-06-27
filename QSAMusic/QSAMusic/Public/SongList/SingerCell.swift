//
//  SingerCell.swift
//  QSAMusic
//
//  Created by 陈少文 on 17/5/23.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

import UIKit

class SingerCell: UITableViewCell {

    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    func update(data: NSDictionary) {
        imgV.layer.cornerRadius = 15.0
        imgV.layer.masksToBounds = true
        imgV.sd_setImage(with: URL(string: data["avatar_middle"] as! String), placeholderImage: UIImage(named: "QSAMusic_p.png"))
        var name = data["name"] as? String
        if name == nil {
            name = data["author"] as? String
        }
        self.name.text = name?.remove(excess: ["<em>", "</em>"])
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
