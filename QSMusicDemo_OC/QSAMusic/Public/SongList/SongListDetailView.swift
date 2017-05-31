//
//  SongListDetailView.swift
//  QSAMusic
//
//  Created by 陈少文 on 17/5/23.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

import UIKit

class SongListDetailView: QSAKitBaseViewController, UITableViewDelegate, UITableViewDataSource {

    var dataArr = [NSDictionary]()
    var titleStr: String = ""
    var indexStr: String = ""
    
    private lazy var headerImageView: UIImageView = {
        let headerImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: SwiftMacro().ScreenWidth, height: 70))
        headerImageView.image = UIImage(named: "back2.jpg")
        return headerImageView
    }()
    
    private lazy var headerView: UIView = {
        let headerView = UIView(frame: CGRect(x: 0, y: -70, width: SwiftMacro().ScreenWidth, height: 70))
        headerView.addSubview(self.headerImageView)
        
        let button = UIButton()
        button.frame = CGRect(x: 12, y: 25, width: 30, height: 30)
        button.setTitle("<<", for: UIControlState.normal)
        button.addTarget(self, action: #selector(back), for: UIControlEvents.touchUpInside)
        headerView.addSubview(button)
        
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 32, width: SwiftMacro().ScreenWidth, height: 30))
        headerLabel.text = self.titleStr + " TOP30"
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont.systemFont(ofSize: 14)
        headerLabel.textColor = .white
        headerView.addSubview(headerLabel)
        
        return headerView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: -20, width: SwiftMacro().ScreenWidth, height: SwiftMacro().ScreenHeight + 20))
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = self.headerView
        tableView.register(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "ListCell")
        tableView.register(UINib(nibName: "SingerCell", bundle: nil), forCellReuseIdentifier: "SingerCell")
        tableView.register(UINib(nibName: "LoadCell", bundle: nil), forCellReuseIdentifier: "LoadCell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var tempHeaderView: UIView = {
       let tempHeaderView = UIView(frame: CGRect(x: 0, y: -70, width: SwiftMacro().ScreenWidth, height: 70))
        
        let imgV = UIImageView(frame: CGRect(x: 0, y: 0, width: SwiftMacro().ScreenWidth, height: 70))
        imgV.image = UIImage(named: "back2.jpg")
        tempHeaderView.addSubview(imgV)
        
        let button = UIButton()
        button.frame = CGRect(x: 12, y: 25, width: 30, height: 30)
        button.setTitle("<<", for: UIControlState.normal)
        button.addTarget(self, action: #selector(back), for: UIControlEvents.touchUpInside)
        tempHeaderView.addSubview(button)
        
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 32, width: SwiftMacro().ScreenWidth, height: 30))
        headerLabel.text = self.titleStr + " TOP30"
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont.systemFont(ofSize: 14)
        headerLabel.textColor = .white
        tempHeaderView.addSubview(headerLabel)
        
        return tempHeaderView
    }()
    
    override func viewDidLoad() {
        view.addSubview(tableView)
        view.addSubview(tempHeaderView)
    }

    func back() {
        self.navigationController!.popViewController(animated: true)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexStr == "List") {
            return 44.0;
        }
        return 55.0;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexStr == "List" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! ListCell
            cell.update(data: dataArr[indexPath.row], indexStr: "List")
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ListViewTableViewCell
        cell.update(data: dataArr[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        PlayerController.shared.play(playList: dataArr, index: indexPath.row)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y;
        if (yOffset < -20) {
            let factor = -yOffset + 50;
            let f = CGRect(x: -(SwiftMacro().ScreenWidth * factor / 70 - SwiftMacro().ScreenWidth) / 2, y: yOffset + 20, width: SwiftMacro().ScreenWidth * factor / 70, height: factor);
            headerImageView.frame = f;
            
            tempHeaderView.alpha = 0.0;
            tempHeaderView.frame = CGRect(x: 0, y: -70, width: SwiftMacro().ScreenWidth, height: 70);
        }else {
            var f = headerView.frame;
            f.origin.y = 0;
            headerView.frame = f;
            headerImageView.frame = CGRect(x: 0, y: f.origin.y, width: SwiftMacro().ScreenWidth, height: 70);
        }
        if (yOffset > 50) {
            tempHeaderView.alpha = 1.0;
            UIView.animate(withDuration: 0.2, animations: {
                self.tempHeaderView.frame = CGRect(x: 0, y: 0, width: SwiftMacro().ScreenWidth, height: 70)
            })
        }
    }
}
