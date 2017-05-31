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
    
    var navigationName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(navigationView)
        view.addSubview(backBtn)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) { 
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: SwiftMacro().ScreenWidth, height: 203))
            headerView.backgroundColor = UIColor.clear
            self.tableView.tableHeaderView = headerView
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            self.tableView.delegate = self
            self.tableView.dataSource = self
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 13
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 121.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        sectionHeader.frame = CGRect(x: 0, y: 0, width: SwiftMacro().ScreenWidth, height: 121)
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
//        cell.textLabel?.font = UIFont.systemFont(ofSize: 12.0)
//        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //PlayerController.shared.play(playList: songList, index: indexPath.row)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = 250 - SwiftMacro().ScreenWidth
        if (scrollView.contentOffset.y <= offset) {
            self.infoView.frame = CGRect(x: 0, y: -scrollView.contentOffset.y + offset, width: SwiftMacro().ScreenWidth, height: SwiftMacro().ScreenWidth)
        } else {
            self.infoView.frame = CGRect(x: 0, y: 0, width: SwiftMacro().ScreenWidth, height: SwiftMacro().ScreenWidth)
        }
        if (scrollView.contentOffset.y >= 203 - 64) {
            UIView.animate(withDuration: 0.2, animations: {
                self.navigationView.center = CGPoint(x: self.navigationView.center.x, y: 32)
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.navigationView.center = CGPoint(x: self.navigationView.center.x, y: -32)
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
