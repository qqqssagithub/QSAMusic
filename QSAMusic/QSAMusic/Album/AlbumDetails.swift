//
//  AlbumDetails.swift
//  QSAMusic
//
//  Created by 陈少文 on 17/4/28.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

import UIKit

class AlbumDetails: QSAKitBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var albumInfo = NSDictionary()
    var songList = [NSDictionary]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: SwiftMacro().ScreenWidth, height: SwiftMacro().ScreenHeight))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor.clear
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: SwiftMacro().ScreenWidth, height: 250))
        headerView.backgroundColor = UIColor.clear
        tableView.tableHeaderView = headerView
        return tableView
    }()
    
    private lazy var navigationView: QSAKitBlurView = {
        let navigationView = QSAKitBlurView(frame: CGRect(x: 0, y: 0, width: SwiftMacro().ScreenWidth, height: 64), type: Blur_blackColor) as QSAKitBlurView
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: SwiftMacro().ScreenWidth - 100, height: 20))
        title.text = self.albumInfo["title"] as? String
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 14)
        navigationView.contentViewAddSubview(title)
        title.center = CGPoint(x: navigationView.center.x, y: navigationView.center.y + 5)
        return navigationView
    }()
    
    private lazy var backBtn: UIButton = {
        let backBtn = UIButton(frame: CGRect(x: 12, y: 21, width: 30, height: 30))
        backBtn.setTitle("<<", for: UIControlState.normal)
        backBtn.addTarget(self, action: #selector(back), for: UIControlEvents.touchUpInside)
        return backBtn
    }()
    
    func back() -> Void {
        self.navigationController!.popViewController(animated: true)
    }
    
    private lazy var infoImgV: UIImageView = {
        let infoImgV = UIImageView(frame: CGRect(x: 0, y: 0, width: SwiftMacro().ScreenWidth, height: SwiftMacro().ScreenWidth))
        var urlStr = self.albumInfo["pic_radio"] as! String
        urlStr = urlStr.replaceToScreenSize(old: "_300", new: "_500")
        infoImgV.sd_setImage(with: URL(string: urlStr), placeholderImage: UIImage(named: "QSAMusic_pc.png"))
        return infoImgV
    }()
    
    private lazy var tempView: QSAKitBlurView = {
        let tempView = QSAKitBlurView(frame: CGRect(x: 0, y: 0, width: SwiftMacro().ScreenWidth, height: SwiftMacro().ScreenWidth), type: Blur_whiteColor) as QSAKitBlurView
        tempView.alpha = 0.0
        return tempView
    }()
    
    private lazy var infoLabel: UILabel = {
        let infoLabel = UILabel(frame: CGRect(x: 12, y: 12, width: SwiftMacro().ScreenWidth - 24, height: SwiftMacro().ScreenWidth - 24))
        infoLabel.font = UIFont.systemFont(ofSize: 12)
        infoLabel.alpha = 0.0
        infoLabel.textColor = UIColor.orange
        infoLabel.numberOfLines = 0
        infoLabel.text = self.albumInfo["info"] as? String
        return infoLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(infoImgV)
        view.addSubview(tempView)
        view.addSubview(infoLabel)
        view.addSubview(tableView)
        view.addSubview(navigationView)
        view.addSubview(backBtn)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if songList.count < 13 {
            return 13
        }
        return songList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SwiftMacro().ScreenWidth, height: 44))
        let title = UILabel(frame: CGRect(x: 12, y: 7, width: SwiftMacro().ScreenWidth - 24, height: 30))
        title.font = UIFont.systemFont(ofSize: 12.0)
        title.textColor = UIColor.white
        if !(albumInfo["buy_url"] as! String == "") {
            view.backgroundColor = UIColor.orange
            title.text = "\(albumInfo["title"] as! String) -- \(albumInfo["author"] as! String) , 专辑热卖中"
        } else {
            if songList.count == 0 {
                view.backgroundColor = UIColor.red
                title.text = "暂不支持查看该专辑"
            } else {
                view.backgroundColor = UIColor.lightGray
                if albumInfo["author"] as! String == "" {
                    title.text = albumInfo["title"] as? String
                } else {
                    title.text = String(format: "%@ -- %@ ,  共%ld首", albumInfo["title"] as! String, albumInfo["author"] as! String, songList.count)
                }
            }
        }
        view.addSubview(title)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12.0)
        if indexPath.row < songList.count {
            let song = songList[indexPath.row]
            if !(song["versions"] as! String == "") {
                cell.textLabel?.text = String(format: "%@(%@)", song["title"] as! String, song["versions"] as! String)
            } else {
                cell.textLabel?.text = String(format: "%@", song["title"] as! String)
            }
            cell.isUserInteractionEnabled = true;
        } else {
            cell.textLabel?.text = "";
            cell.isUserInteractionEnabled = false;
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if !(albumInfo["buy_url"] as! String == "") {
            QSAKitAlertView.show(withTitle: String(format: "《%@》", albumInfo["title"] as! String), message: "专辑热卖中，无法试听\n请支持正版", cancelButtonTitle: "支持歌手", otherButtonTitle: nil)
        } else {
            PlayerController.shared.play(playList: songList, index: indexPath.row)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = 250 - SwiftMacro().ScreenWidth
        if (scrollView.contentOffset.y <= offset) {
            self.infoImgV.frame = CGRect(x: 0, y: -scrollView.contentOffset.y + offset, width: SwiftMacro().ScreenWidth, height: SwiftMacro().ScreenWidth)
            self.tempView.alpha = 1.0
            self.tempView.frame = CGRect(x: 0, y: -scrollView.contentOffset.y + offset, width: SwiftMacro().ScreenWidth, height: SwiftMacro().ScreenWidth)
            self.infoLabel.alpha = 1.0
            self.infoLabel.frame = CGRect(x: 12, y: -scrollView.contentOffset.y + offset + 12, width: SwiftMacro().ScreenWidth - 24, height: SwiftMacro().ScreenWidth - 24)
        } else {
            self.infoImgV.frame = CGRect(x: 0, y: 0, width: SwiftMacro().ScreenWidth, height: SwiftMacro().ScreenWidth)
            self.tempView.alpha = 0.0
            self.tempView.frame = CGRect(x: 0, y: 0, width: SwiftMacro().ScreenWidth, height: SwiftMacro().ScreenWidth)
            self.infoLabel.alpha = 0.0
            self.infoLabel.frame = CGRect(x: 12, y: 12, width: SwiftMacro().ScreenWidth - 24, height: SwiftMacro().ScreenWidth - 24)
        }
        if (scrollView.contentOffset.y <= -5) {
            UIView.animate(withDuration: 0.2, animations: { 
                self.navigationView.center = CGPoint(x: self.navigationView.center.x, y: -32)
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.navigationView.center = CGPoint(x: self.navigationView.center.x, y: 32)
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
