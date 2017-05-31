//
//  SingerClassTableViewCell.swift
//  QSAMusic
//
//  Created by 陈少文 on 17/5/24.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

import UIKit

class SingerClassTableViewCell: UITableViewCell {

    @IBOutlet weak var content: UILabel!
    
    func update(data: String) {
        content.text = data
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
