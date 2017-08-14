//
//  ListView.swift
//  QSAMusic
//
//  Created by 陈少文 on 17/4/27.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

import UIKit

public class ListView: QSAKitBaseView, UITableViewDelegate, UITableViewDataSource {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.bounds)
        tableView.register(UINib(nibName: "ListViewTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private var dataArr = [NSDictionary]()
    
    static let shared = ListView(frame: CGRect(x: SwiftMacro().ScreenWidth * 2, y: 0, width: SwiftMacro().ScreenWidth, height: SwiftMacro().ScreenHeight - 64 - 33))
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.backgroundColor = UIColor.white
        
        addSubview(tableView)
        
        getList()
    }
    
    private init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getList() {
        NetworkEngine.getList { (list) in
            self.dataArr = list
            self.tableView.reloadData()
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == dataArr.count - 1) {
            return 136;
        }
        return 106;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ListViewTableViewCell
        cell.update(data: dataArr[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = dataArr[indexPath.row] 
        NetworkEngine.getListDetail(listType: Int(data["type"] as! NSNumber)) { (listDetail) in
            let aDetail = SongListDetailView()
            aDetail.dataArr = listDetail
            aDetail.titleStr = data["name"] as! String
            aDetail.indexStr = "List"
            self.superVC.navigationController!.pushViewController(aDetail, animated: true)
        }
    }
}
