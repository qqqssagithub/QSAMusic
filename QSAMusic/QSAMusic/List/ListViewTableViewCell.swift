//
//  ListViewTableViewCell.swift
//  QSAMusic
//
//  Created by 陈少文 on 17/5/23.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

import UIKit

class ListViewTableViewCell: UITableViewCell {

    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var first: UILabel!
    @IBOutlet weak var second: UILabel!
    @IBOutlet weak var third: UILabel!
    
    func update(data: NSDictionary) {
        imgV.sd_setImage(with: URL(string: data["pic_s192"] as! String), placeholderImage: UIImage(named: "QSAMusic_p.png"))
        let firstStr0 = ((data["content"] as! NSArray)[0] as! NSDictionary)["title"] as! String
        let firstStr1 = ((data["content"] as! NSArray)[0] as! NSDictionary)["author"] as! String
        first.text = firstStr0 + " -- " + firstStr1
        let secondStr0 = ((data["content"] as! NSArray)[1] as! NSDictionary)["title"] as! String
        let secondStr1 = ((data["content"] as! NSArray)[1] as! NSDictionary)["author"] as! String
        second.text = secondStr0 + " -- " + secondStr1
        let thirdStr0 = ((data["content"] as! NSArray)[2] as! NSDictionary)["title"] as! String
        let thirdStr1 = ((data["content"] as! NSArray)[2] as! NSDictionary)["author"] as! String
        third.text = thirdStr0 + " -- " + thirdStr1
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
