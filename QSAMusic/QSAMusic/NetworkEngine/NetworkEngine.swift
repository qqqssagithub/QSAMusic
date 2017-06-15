//
//  NetworkEngine.swift
//  QSAMusic
//
//  Created by 陈少文 on 17/4/27.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

import UIKit
import Alamofire

open class NetworkEngine: NSObject {

    private class RequestURL: NSObject {
        
        let albumList = "http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.plaza.getRecommendAlbum&format=json&offset=%ld&limit=25&type=2&from=ios&version=5.8.1&cuid=1bb92ffcf38c17a7d8a3b3e75361f0a85c8b7054&channel=appstore&operator=0"
        let albumDetail = "http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.album.getAlbumInfo&album_id=%@&format=json&from=ios&version=5.8.1&cuid=1bb92ffcf38c17a7d8a3b3e75361f0a85c8b7054&channel=appstore&operator=0"
        
        let songListClass = "http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.diy.gedanCategory&from=ios&version=5.8.1&cuid=1bb92ffcf38c17a7d8a3b3e75361f0a85c8b7054&channel=appstore&operator=0"
        let songListClassDetail = "http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.diy.search&page_no=%ld&page_size=%ld&query=%@&from=ios&version=5.8.1&cuid=1bb92ffcf38c17a7d8a3b3e75361f0a85c8b7054&channel=appstore&operator=0"
        let songListRecommend = "http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.diy.gedan&page_no=%ld&page_size=%ld&from=ios&version=5.8.1&cuid=1bb92ffcf38c17a7d8a3b3e75361f0a85c8b7054&channel=appstore&operator=0"
        let songListDetail = "http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.diy.gedanInfo&from=ios&listid=%@&version=5.8.1&cuid=1bb92ffcf38c17a7d8a3b3e75361f0a85c8b7054&channel=appstore&operator=0"
        
        let list = "http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.billboard.billCategory&format=json&from=ios&kflag=1&version=5.8.1&cuid=1bb92ffcf38c17a7d8a3b3e75361f0a85c8b7054&channel=appstore&operator=0"
        let listDetail = "http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.billboard.billList&type=%ld&format=json&offset=0&size=%ld&from=ios&fields=title,song_id,author,resource_type,havehigh,is_new,has_mv_mobile,album_title,ting_uid,album_id,charge,all_rate&version=5.8.1&cuid=1bb92ffcf38c17a7d8a3b3e75361f0a85c8b7054&channel=appstore&operator=0"
        
        let hotSingerList = "http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.artist.getList&format=json&order=1&limit=30&offset=0&area=0&sex=0&abc=&from=ios&version=5.8.1&cuid=1bb92ffcf38c17a7d8a3b3e75361f0a85c8b7054&channel=appstore&operator=0"
        let singerList = "http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.artist.getList&format=json&order=1&limit=%ld&offset=%ld&area=%@&sex=%@&abc=&from=ios&version=5.8.1&cuid=1bb92ffcf38c17a7d8a3b3e75361f0a85c8b7054&channel=appstore&operator=0"
        
        let radio = "http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.radio.getChannelSong&channelid=0&channelname=%@&pn=%ld&rn=%ld&format=json&from=ios&baiduid=1bb92ffcf38c17a7d8a3b3e75361f0a85c8b7054&version=5.8.1&cuid=1bb92ffcf38c17a7d8a3b3e75361f0a85c8b7054&channel=appstore&operator=0"
        
        let search = "http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.search.merge&query=%@&page_no=%ld&page_size=%ld&from=ios&version=5.8.1&cuid=1bb92ffcf38c17a7d8a3b3e75361f0a85c8b7054&channel=appstore&operator=0"
        
        let song = "http://music.baidu.com/data/music/links?songIds="
    }
    
    private func getData(url: String, responseClosure: @escaping (_ data: DataResponse<Any>) -> Void) {
        QSAKitPromptView.show()
        Alamofire.request(url).validate().responseJSON { response in
            QSAKitPromptView.disappear()
            responseClosure(response)
        }
    }
    
    // MARK: - 歌曲详情
    public class func getSong(songId: String, responseClosure: @escaping (_ oneSong: [String : Any]) -> Void) {
        QSALog("获取歌曲详情: \(songId)")
        let url = RequestURL().song + songId
        NetworkEngine().getData(url: url) { (response) in
            if let json: AnyObject? = response.result.value as AnyObject?? {
                let data = json?.object(forKey: "data") as! [String : Any]
                let songList = data["songList"] as! [[String : Any]]
                responseClosure(songList[0])
            } else {
                responseClosure(["songId" : 0])
            }
        }
    }
    
    // MARK: - 新碟
    public class func getAlbumList(offset : Int = 0, responseClosure: @escaping (_ dataArr: [NSDictionary], _ havemore: Int) -> Void) {
        let url = String(format: RequestURL().albumList, offset)
        NetworkEngine().getData(url: url) { (response) in
            if let json: AnyObject? = response.result.value as AnyObject?? {
                let plaze_album_list = json?.object(forKey: "plaze_album_list") as! NSDictionary
                let RM = plaze_album_list["RM"] as! NSDictionary
                let album_list = RM["album_list"] as! NSDictionary
                let list = album_list["list"] as! [NSDictionary]
                let havemore = Int(album_list["havemore"] as! NSNumber)
                responseClosure(list, havemore)
            }
        }
    }
    
    public class func getAlbumDetail(albumId: String, responseClosure: @escaping (_ albumInfo: NSDictionary, _ songList: [NSDictionary]) -> Void) {
        QSALog("获取新碟详情: \(albumId)")
        let url = String(format: RequestURL().albumDetail, albumId)
        NetworkEngine().getData(url: url) { (response) in
            if let json: AnyObject? = response.result.value as AnyObject?? {
                let albumInfo = json?.object(forKey: "albumInfo") as! NSDictionary
                let songList: AnyObject = json?.object(forKey: "songlist") as AnyObject
                if !songList.isEqual(String.self) {
                    responseClosure(albumInfo, songList as! [NSDictionary])
                } else {
                    responseClosure(albumInfo, [])
                }
            }
        }
    }
    
    // MARK: - 歌单
    public class func getSongListClass(responseClosure: @escaping (_ songListClass: [NSDictionary]) -> Void) {
        let url = RequestURL().songListClass
        NetworkEngine().getData(url: url) { (response) in
            if let json: AnyObject? = response.result.value as AnyObject?? {
                let content = json?.object(forKey: "content") as! [NSDictionary]
                responseClosure(content)
            }
        }
    }
    
    public class func getSongListClassDetail(page: Int = 1, size: Int = 25, tag: String, responseClosure: @escaping (_ content: [NSDictionary], _ havemore: Int) -> Void) {
        let tagURL = tag.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let url = String(format: RequestURL().songListClassDetail, page, size, tagURL)
        NetworkEngine().getData(url: url) { (response) in
            if let json: AnyObject? = response.result.value as AnyObject?? {
                let content = json?.object(forKey: "content") as! [NSDictionary]
                let havemore = Int(json?.object(forKey: "havemore") as! NSNumber)
                responseClosure(content, havemore)
            }
        }
    }
    
    public class func getRecommend(page: Int = 1, size: Int = 25, responseClosure: @escaping (_ content: [NSDictionary], _ havemore: Int) -> Void) {
        let url = String(format: RequestURL().songListRecommend, page, size)
        NetworkEngine().getData(url: url) { (response) in
            if let json: AnyObject? = response.result.value as AnyObject?? {
                let content = json?.object(forKey: "content") as! [NSDictionary]
                let havemore = Int(json?.object(forKey: "havemore") as! NSNumber)
                responseClosure(content, havemore)
            }
        }
    }
    
    public class func getSongListDetail(listId: String, responseClosure: @escaping (_ listInfo:  NSDictionary, _ songList: [NSDictionary]) -> Void) {
        let url = String(format: RequestURL().songListDetail, listId)
        NetworkEngine().getData(url: url) { (response) in
            if let json: AnyObject? = response.result.value as AnyObject?? {
                let listInfo: NSDictionary = ["title": json?.object(forKey: "title") as! String,
                                              "pic_radio": json?.object(forKey: "pic_w700") as! String,
                                              "info": json?.object(forKey: "desc") as! String]
                let songList = json?.object(forKey: "content") as! [NSDictionary]
                responseClosure(listInfo, songList)
            }
        }
    }
    
    // MARK: - 榜单
    public class func getList(responseClosure: @escaping (_ list: [NSDictionary]) -> Void) {
        let url = RequestURL().list
        NetworkEngine().getData(url: url) { (response) in
            if let json: AnyObject? = response.result.value as AnyObject?? {
                let content = json?.object(forKey: "content") as! [NSDictionary]
                responseClosure(content)
            }
        }
    }
    
    public class func getListDetail(listType: Int, responseClosure: @escaping (_ list: [NSDictionary]) -> Void) {
        let url = String(format: RequestURL().listDetail, listType, 30)
        NetworkEngine().getData(url: url) { (response) in
            if let json: AnyObject? = response.result.value as AnyObject?? {
                let song_list = json?.object(forKey: "song_list") as! [NSDictionary]
                responseClosure(song_list)
            }
        }
    }
    
    // MARK: - 歌手
    public class func getHotSinger(responseClosure: @escaping (_ list: [NSDictionary]) -> Void) {
        let url = String(format: RequestURL().hotSingerList)
        NetworkEngine().getData(url: url) { (response) in
            if let json: AnyObject? = response.result.value as AnyObject?? {
                let list = json?.object(forKey: "artist") as! [NSDictionary]
                responseClosure(list)
            }
        }
    }
    
    public class func getSingerList(limit: Int = 30, offset: Int = 0, area: String, sex: String, responseClosure: @escaping (_ list: [NSDictionary]) -> Void) {
        let url = String(format: RequestURL().singerList, limit, offset, area, sex)
        NetworkEngine().getData(url: url) { (response) in
            if let json: AnyObject? = response.result.value as AnyObject?? {
                let list = json?.object(forKey: "artist") as! [NSDictionary]
                responseClosure(list)
            }
        }
    }
    
    //MARK: - 电台
    public class func getChannelSong(channelname: String, page: Int = 1, size: Int = 30, responseClosure: @escaping (_ result: [NSDictionary]) -> Void) {
        let url = String(format: RequestURL().radio, channelname, page, size)
        NetworkEngine().getData(url: url) { (response) in
            if let json: AnyObject? = response.result.value as AnyObject?? {
                let result = json?.object(forKey: "result") as! NSDictionary
                let songList = result["songlist"] as! [NSDictionary]
                responseClosure(songList)
            }
        }
    }
    
    // MARK: - 搜索
    public class func getSearch(query: String, page: Int = 1, size: Int = 25, responseClosure: @escaping (_ result: NSDictionary) -> Void) {
        let queryURL = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let url = String(format: RequestURL().search, queryURL, page, size)
        NetworkEngine().getData(url: url) { (response) in
            if let json: AnyObject? = response.result.value as AnyObject?? {
                let result = json?.object(forKey: "result") as! NSDictionary
                responseClosure(result)
            }
        }
    }
}
