//
//  SingerView.swift
//  QSAMusic
//
//  Created by 陈少文 on 17/4/27.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

import UIKit

public class SingerView: QSAKitBaseView, UITableViewDataSource, UITableViewDelegate {
    
    private var topDataArr = [NSDictionary]()
    private var dataArr: Array = [[], ["华语男歌手", "华语女歌手", "华语乐队组合"], ["欧美男歌手手", "欧美女歌手", "欧美乐队组合"], ["韩国男歌手", "韩国女歌手", "韩国乐队组合"], ["日本男歌手", "日本女歌手", "日本乐队组合"]]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.bounds)
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UINib(nibName: "TopTableViewCell", bundle: nil), forCellReuseIdentifier: "TopCell")
        tableView.register(UINib(nibName: "SingerClassTableViewCell", bundle: nil), forCellReuseIdentifier: "SingerClassCell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    static let shared = SingerView(frame: CGRect(x: SwiftMacro().ScreenWidth * 3, y: 0, width: SwiftMacro().ScreenWidth, height: SwiftMacro().ScreenHeight - 64 - 33))
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.backgroundColor = UIColor.white
        
        addSubview(tableView)
        
        getHotSinger()
    }
    
    private init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getHotSinger() {
        NetworkEngine.getHotSinger { (list) in
            self.topDataArr = list
            self.tableView.reloadData()
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return dataArr[section].count
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SwiftMacro().ScreenWidth, height: 4))
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.1)
        return view
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 182
        }
        return 44
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopCell") as! TopTableViewCell
            cell.update(data: topDataArr, superVC: self.superVC)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "SingerClassCell") as! SingerClassTableViewCell
        cell.update(data: dataArr[indexPath.section][indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section != 0 {
            requestList(indexPath: indexPath)
        }
    }
    
    private func requestList(indexPath: IndexPath) {
        let area = ["", "0", "3", "7", "60"]
        let sex = "\(indexPath.row + 1)"
        NetworkEngine.getSingerList(area: area[indexPath.section], sex: sex) { (singerList) in
            let aDetail = SongListDetailView()
            aDetail.dataArr = singerList
            aDetail.titleStr = self.dataArr[indexPath.section][indexPath.row]
            aDetail.indexStr = "Singer"
            self.superVC.navigationController!.pushViewController(aDetail, animated: true)
        }
    }
    
}
