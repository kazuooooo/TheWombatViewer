//
//  YoutubeAPI.swift
//  MyYouTube
//
//  Created by 松本和也 on 6/26/16.
//  Copyright © 2016 kazuya.matsumoto. All rights reserved.
//

import Foundation

class YoutubeAPI:NSObject{
    var nextPageToken:String? = nil
    var order:String? = "date"
    func getJSON(callback: (NSDictionary)->()){
        //        load settings from Const
        //        let id = Const.playlistsId
        let apiKey = Const.apiKey
        let keyword = Const.searchKeyword
        let maxResults = Const.maxResults
        var urlString:String
        //        make request
        if (nextPageToken != nil) {
            urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(keyword)&maxResults=\(maxResults)&key=\(apiKey)&pageToken=\(nextPageToken!)&type=video&order=\(order!)"
        } else {
            urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(keyword)&maxResults=\(maxResults)&key=\(apiKey)&type=video&order=\(order!)"
        }
        let URL = NSURL(string:urlString)
        print(URL)
        let req = NSURLRequest(URL: URL!)
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration, delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        //        make request after completeHandler is colsure
        //        refer them
        //        http://qiita.com/tajihiro/items/332fe94a25209f1e80c1
        //        http://qiita.com/yuinchirn/items/2ebb6fed6de0c9c1c3c9
        
        let task = session.dataTaskWithRequest(req, completionHandler:{
            (data, response, error) -> Void in
            do {
                if((error) != nil){
                    print(error?.description)
                }else{
                    // serialize response data to json
                    // try 例外処理 処理に失敗したときにnilを返す
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments ) as! NSDictionary
                    print(json)
                    // put json['items'](this has youtube items) to dataArray
                    // HACK:本来はこのメソッドはjsondataを返すだけにするべきでここでテーブルをリロードするのはおかしい。
                    self.nextPageToken = json["nextPageToken"] as! String
                    callback(json)
                }
            } catch {
                print("JSON error!")
            }
        })
        // ↑で作ったタスクを実行
        task.resume()
    }
}