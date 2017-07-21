//
//  MineViewController.swift
//  QSAMusic
//
//  Created by 陈少文 on 17/7/20.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

import UIKit

class MineViewController: QSAKitBaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    var index = 0
    var dataArr = [Dictionary<String, Dictionary<String, String>>]()
    var isEdit = false
    var editDic = Dictionary<String, String>()
    
    
    // MARK: - sharedInstance
    open static let shared = MineViewController()
    
    private init() {
        super.init(nibName: "MineViewController", bundle: nil)
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) has not been implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteBtn.isHidden = true
        
        tableView.register(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "ListCell")
        let footerView = UILabel(frame: CGRect(x: 0, y: 0, width: SwiftMacro().ScreenWidth, height: 30))
        footerView.textAlignment = .center
        footerView.font = UIFont.systemFont(ofSize: 12.0)
        footerView.text = "没有更多了"
        footerView.backgroundColor = UIColor(white: 0.0, alpha: 0.1)
        tableView.tableFooterView = footerView;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dataArr.removeAll()
        for song in index == 0 ? ArchiveManager.getCacheList() : ArchiveManager.getCollectionList() {
            dataArr.append(song)
        }
        tableView.reloadData()
    }
    
    func itemChange(like: Bool, songId: String) {
        if (index == 1 && like) || (index == 0 && !like) {
            dataArr.removeAll()
            for song in index == 0 ? ArchiveManager.getCacheList() : ArchiveManager.getCollectionList() {
                dataArr.append(song)
            }
            tableView.reloadData()
        } else {
            removeItem(songId: songId)
        }
    }
    
    func removeItem(songId: String) {
        var i = 0
        for item in dataArr {
            for (key, _) in item {
                if key == songId {
                    dataArr.remove(at: i)
                    tableView.deleteRows(at: [IndexPath(row: i, section: 0)], with: .none)
                } else {
                    i += 1
                }
            }
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func changeList(_ sender: UISegmentedControl) {
        index = sender.selectedSegmentIndex
        isEdit = false
        tableView.isEditing = isEdit
        editDic.removeAll()
        editBtn.setTitle("编辑", for: .normal)
        deleteBtn.isHidden = true
        
        dataArr.removeAll()
        for song in sender.selectedSegmentIndex == 0 ? ArchiveManager.getCacheList() : ArchiveManager.getCollectionList() {
            dataArr.append(song)
        }
        tableView.reloadData()
    }

    @IBAction func edit(_ sender: Any) {
        editDic.removeAll()
        isEdit = !isEdit
        tableView.isEditing = isEdit
        if isEdit {
            editBtn.setTitle("取消", for: .normal)
        } else {
            editBtn.setTitle("编辑", for: .normal)
        }
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        deleteBtn.isHidden = true
        var arr = [IndexPath]()
        var rowArr = [Int]()
        for (key, _) in editDic {
            let  row = Int(key)!
            rowArr.append(row)
        }
        rowArr.sort(by: {$0 > $1})
        
        for row in rowArr {
            if index == 0 {
                let cacheList = ArchiveManager.getCacheList()
                for (k, _) in dataArr[row] {
                    ArchiveManager.deleteCache(cacheList: cacheList, songId: k, index: row)
                }
            } else {
                let collectionList = ArchiveManager.getCollectionList()
                for (k, _) in dataArr[row] {
                    ArchiveManager.cancelCollection(collectionList: collectionList, songId: k, index: row)
                }
            }
            dataArr.remove(at: row)
            arr.append(IndexPath(row: row, section: 0))
        }
    
        tableView.deleteRows(at: arr, with: .top)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! ListCell
        for (_, value) in dataArr[indexPath.row] {
            cell.update(data: value as NSDictionary, indexStr: "List")
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tableView.isEditing {
            tableView.deselectRow(at: indexPath, animated: true)
            var list = [NSDictionary]()
            for item in dataArr {
                for value in item.values {
                    list.append(value as NSDictionary)
                }
            }
            PlayerController.shared.play(playList: list, index: indexPath.row)
        } else {
            editDic["\(indexPath.row)"] = ""
            deleteBtn.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        editDic.removeValue(forKey: "\(indexPath)")
        if editDic.count == 0 {
            deleteBtn.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle(rawValue: UITableViewCellEditingStyle.insert.rawValue | UITableViewCellEditingStyle.delete.rawValue)!
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
