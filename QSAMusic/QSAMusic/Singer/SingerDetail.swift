//
//  SingerDetail.swift
//  QSAMusic
//
//  Created by 陈少文 on 17/5/25.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

import UIKit

class SingerDetail: QSAKitBaseViewController, UITableViewDelegate, UITableViewDataSource {

    private lazy var navigationView: QSAKitBlurView = {
        let navigationView = QSAKitBlurView(frame: CGRect(x: 0, y: -64, width: SwiftMacro().ScreenWidth, height: 64), type: Blur_blackColor) as QSAKitBlurView
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: SwiftMacro().ScreenWidth - 100, height: 20))
        title.text = self.navigationName
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 14)
        navigationView.contentViewAddSubview(title)
        title.center = CGPoint(x: navigationView.center.x, y: 32 + 5)
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
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var area: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var infoImgV: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var sectionHeader: UIView!
    
    @IBOutlet weak var songTF: UITextField!
    @IBOutlet weak var albumTF: UITextField!
    
    var navigationName: String = ""
    var  page = 1
    
    private lazy var bottomLabel: UILabel = {
        let bottomLabel = UILabel(frame: CGRect(x: 12.0, y: 7.0, width: SwiftMacro().ScreenWidth - 24.0, height: 16.0))
        bottomLabel.textAlignment = .center
        bottomLabel.font = UIFont.systemFont(ofSize: 12.0)
        bottomLabel.textColor = UIColor.lightGray
        bottomLabel.text = ""
        return bottomLabel
    }()
    private var bottomLabelStr: String = "加载完成"
    private lazy var footerView: UIView = {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: SwiftMacro().ScreenWidth, height: 30))
        footerView.backgroundColor = UIColor.white
        footerView.addSubview(self.bottomLabel)
        return footerView
    }()
    
    var result: NSDictionary!
    var songArr = NSMutableArray()
    var albumArr = NSMutableArray()
    
    var songNoMore = false
    var albumNoMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(navigationView)
        view.addSubview(backBtn)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) { 
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: SwiftMacro().ScreenWidth, height: 183))
            headerView.backgroundColor = UIColor.clear
            self.tableView.tableHeaderView = headerView
            
            self.tableView.register(UINib(nibName: "SingerDetailCell", bundle: nil), forCellReuseIdentifier: "cell")
            self.tableView.delegate = self
            self.tableView.dataSource = self
            
            let artist_info = self.result["artist_info"] as! NSDictionary
            let artist_list = artist_info["artist_list"] as! NSArray
            let artist = artist_list[0] as! NSDictionary
            var  urlStr = artist["avatar_middle"] as! String
            urlStr = urlStr.replacingOccurrences(of: "w_120", with: "w_414")
            self.infoImgV.sd_setImage(with: URL(string: urlStr), placeholderImage: UIImage(named: "QSAMusic_pc.png"))
            self.name.text = self.result["query"] as? String
            var country = artist["country"] as! String
            if country == "" {
                country = "未知"
            }
            self.area.text = "地区: " + country
            
            let song_info = self.result["song_info"] as! NSDictionary
            let song_num = song_info["total"] as! NSNumber
            if song_info["song_list"] != nil {
                let song_list = song_info["song_list"] as! Array<NSDictionary>
                for item: NSDictionary in song_list {
                    self.songArr.add(item)
                }
            }
            if self.songArr.count < 25 {
                self.songNoMore = true
            }
            self.songTF.text = "单曲(\(song_num))"
            self.songTF.backgroundColor = .groupTableViewBackground
            self.songTF.textColor = .purple
            
            let album_info = self.result["album_info"] as! NSDictionary
            let album_num = album_info["total"] as! NSNumber
            if album_info["album_list"] != nil {
                let album_list = album_info["album_list"] as! Array<NSDictionary>
                for item: NSDictionary in album_list {
                    self.albumArr.add(item)
                }
            }
            if self.albumArr.count < 25 {
                self.albumNoMore = true
            }
            self.albumTF.text = "专辑(\(album_num))"
        }
    }

    @IBAction func songAndAlbumBtnAction(_ sender: UIButton) {
        if sender.tag == 0 {
            if songTF.textColor != .purple {
                songTF.backgroundColor = .groupTableViewBackground
                songTF.textColor = .purple
                albumTF.backgroundColor = .white
                albumTF.textColor = .black
                tableView.reloadData()
            }
        } else {
            if albumTF.textColor != .purple {
                albumTF.backgroundColor = .groupTableViewBackground
                albumTF.textColor = .purple
                songTF.backgroundColor = .white
                songTF.textColor = .black
                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if songTF.textColor == .purple {
            if songNoMore {
                footerView.backgroundColor = UIColor(white: 0.0, alpha: 0.1)
                bottomLabel.text = "没有更多了"
            } else {
                footerView.backgroundColor = UIColor.white
                bottomLabel.text = ""
            }
            return songArr.count
        }
        if albumNoMore {
            footerView.backgroundColor = UIColor(white: 0.0, alpha: 0.1)
            bottomLabel.text = "没有更多了"
        } else {
            footerView.backgroundColor = UIColor.white
            bottomLabel.text = ""
        }
        return albumArr.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 91.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        sectionHeader.frame = CGRect(x: 0, y: 0, width: SwiftMacro().ScreenWidth, height: 91)
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SingerDetailCell
        if songTF.textColor == .purple {
            let song = songArr[indexPath.row] as! NSDictionary
            let pic = song["pic_small"] as! String
            var title = song["title"] as! String
            title = title.remove(excess: ["<em>", "</em>"])
            let other = song["album_title"] as! String
            cell.update(data: ["pic": pic, "title": title, "other": "专辑: \(other)"])
        } else {
            let album = albumArr[indexPath.row] as! NSDictionary
            let pic = album["pic_small"] as! String
            var title = album["title"] as! String
            title = title.remove(excess: ["<em>", "</em>"])
            let other = album["publishtime"] as! String
            cell.update(data: ["pic": pic, "title": title, "other": other])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if songTF.textColor == .purple {
            var playList = [NSDictionary]()
            for item in songArr {
                playList.append(item as! NSDictionary)
            }
            PlayerController.shared.play(playList: playList, index: indexPath.row)
        } else {
            let album = albumArr[indexPath.row] as! NSDictionary
            NetworkEngine.getAlbumDetail(albumId: album["album_id"] as! String) { (albumInfo, songList) in
                let aDetails = AlbumDetails()
                aDetails.albumInfo = albumInfo
                aDetails.songList = songList
                self.navigationController!.pushViewController(aDetails, animated: true)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = 250 - SwiftMacro().ScreenWidth
        if (scrollView.contentOffset.y <= offset) {
            self.infoView.frame = CGRect(x: 0, y: -scrollView.contentOffset.y + offset, width: SwiftMacro().ScreenWidth, height: SwiftMacro().ScreenWidth)
        } else {
            self.infoView.frame = CGRect(x: 0, y: 0, width: SwiftMacro().ScreenWidth, height: SwiftMacro().ScreenWidth)
        }
        if (scrollView.contentOffset.y >= 183 - 64) {
            UIView.animate(withDuration: 0.2, animations: {
                self.navigationView.center = CGPoint(x: self.navigationView.center.x, y: 32)
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.navigationView.center = CGPoint(x: self.navigationView.center.x, y: -32)
            })
        }
        
        if (scrollView.contentOffset.y >= scrollView.contentSize.height - SwiftMacro().ScreenHeight - 30 - 20) {
            if (bottomLabelStr != "" && bottomLabel.text != "没有更多了") {
                bottomLabelStr = "";
                page += 1
                getData(page: page)
            }
        }
    }
    
    private func getData(page: Int) {
        NetworkEngine.getSearch(query: navigationName, page: page) { (result) in
            self.bottomLabelStr = "加载完成"
            
            let song_info = result["song_info"] as! NSDictionary
            if song_info["song_list"] != nil {
                let song_list = song_info["song_list"] as! Array<NSDictionary>
                for item: NSDictionary in song_list {
                    self.songArr.add(item)
                }
                if song_list.count < 25 {
                    self.songNoMore = true
                }
            } else {
                self.songNoMore = true
            }
            
            let album_info = result["album_info"] as! NSDictionary
            if album_info["album_list"] != nil {
                let album_list = album_info["album_list"] as! Array<NSDictionary>
                for item: NSDictionary in album_list {
                    self.albumArr.add(item)
                }
                if album_list.count < 25 {
                    self.albumNoMore = true
                }
            } else {
                self.albumNoMore = true
            }
            
            self.tableView.reloadData()
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
