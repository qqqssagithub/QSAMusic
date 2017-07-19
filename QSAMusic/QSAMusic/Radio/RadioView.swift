//
//  RadioView.swift
//  QSAMusic
//
//  Created by 陈少文 on 17/4/27.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

import UIKit
import iCarousel
import FXImageView

open class RadioView: QSAKitBaseView, iCarouselDelegate, iCarouselDataSource {
    
    private lazy var radioPics: Array<String> = {
        let radioPics = ["jd.jpg", "jg.jpg", "cmq.jpg", "om.jpg", "wl.jpg", "sbtt.jpg", "dy.jpg"]
        return radioPics
    }()
    
    private lazy var radioNames: Array<String> = {
        let radioNames = ["经典老歌", "劲爆热歌", "成名金曲", "流行欧美", "网络歌曲", "随便听听", "电影原声"]
        return radioNames
    }()
    
    private lazy var chArr: Array<String> = {
        let chArr = ["public_shiguang_jingdianlaoge", "public_tuijian_rege", "public_tuijian_chengmingqu", "public_yuzhong_oumei", "public_tuijian_wangluo", "public_tuijian_suibiantingting", "public_fengge_dianyingyuansheng"]
        return chArr
    }()
    
    private lazy var tags: Array = { () -> [Int] in 
        let tags = [3000, 3001, 3002, 3003, 3004, 3005, 3006]
        return tags
    }()
    
    private lazy var carousel: iCarousel = {
        let carousel = iCarousel(frame: self.bounds)
        carousel.delegate = self
        carousel.dataSource = self
        carousel.type = iCarouselType.rotary
        carousel.isVertical = true
        carousel.isPagingEnabled = true
        return carousel
    }()
    
    static let shared = RadioView(frame: CGRect(x: SwiftMacro().ScreenWidth * 4, y: 0, width: SwiftMacro().ScreenWidth, height: SwiftMacro().ScreenHeight - 64 - 33))
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.backgroundColor = UIColor.white
        
        addSubview(carousel)
        carousel.reloadData()
    }
    
    private init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - iCarouselDelegate
    public func numberOfItems(in carousel: iCarousel) -> Int {
        return 7
    }
    
    public func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        if view == nil {
            let imgV = FXImageView(frame: CGRect(x: 0, y: 0, width: SwiftMacro().ScreenWidth * 0.6, height: SwiftMacro().ScreenWidth * 0.6))
            imgV.image = UIImage(named: radioPics[index])
            imgV.shadowOffset = CGSize(width: 8.0, height: 8.0)
            imgV.shadowBlur = 10.0
            
            let label = UILabel(frame: CGRect(x: 12, y: 12, width: 80, height: 20))
            label.font = UIFont.systemFont(ofSize: 12.0)
            label.text = radioNames[index]
            
            imgV.addSubview(label)
            
            return imgV
        }
        return view!
    }
    
    public func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        NetworkEngine.getChannelSong(channelname: chArr[index]) { (songList) in
            //歌曲列表最后会出现错误信息
            var list:[NSDictionary] = songList;
            for i in (0..<list.count).reversed() {
                let song: NSDictionary = list[i]
                if (song["songid"] is NSNull) {
                    list.remove(at: i)
                }
            }
            PlayerController.shared.play(playList: list, index: 0)
        }
    }
    
}
