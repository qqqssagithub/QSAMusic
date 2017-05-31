//
//  ListCell.swift
//  QSAMusic
//
//  Created by 陈少文 on 17/5/23.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {

    @IBOutlet weak var song: UILabel!
    @IBOutlet weak var other: UILabel!
    
    func update(data: NSDictionary, indexStr: String) {
        if data["versions"] as! String != "" {
            song.text = "\(data["title"] as! String)(\(data["versions"] as! String))"
        } else {
            song.text = "\(data["title"] as! String)"
        }
        
        if indexStr == "searchLeftTableView" {
            other.text = "《\(data["album_title"] as! String)》"
        } else {
            other.text = data["author"] as? String
        }
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
