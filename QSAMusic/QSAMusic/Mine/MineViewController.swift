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
    var index = 0
    var dataArr = [Dictionary<String, Dictionary<String, String>>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func back(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func changeList(_ sender: UISegmentedControl) {
        dataArr.removeAll()
        for song in sender.selectedSegmentIndex == 0 ? ArchiveManager.getCacheList() : ArchiveManager.getCollectionList() {
            dataArr.append(song)
        }
        tableView.reloadData()
    }

    @IBAction func edit(_ sender: Any) {
        
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
        tableView.deselectRow(at: indexPath, animated: true)
        var list = [NSDictionary]()
        for item in dataArr {
            for value in item.values {
                list.append(value as NSDictionary)
            }
        }
        PlayerController.shared.play(playList: list, index: indexPath.row)
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
