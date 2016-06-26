//
//  ImageSearchAPI.swift
//  MyYouTube
//
//  Created by 松本和也 on 6/26/16.
//  Copyright © 2016 kazuya.matsumoto. All rights reserved.
//

import Foundation

class ImageSearchAPI:NSObject{
    var idx = 1
    let apiKey = Const.apiKey
    let keyword = Const.searchKeyword
    let cx = Const.csecx
    
    func getImages(callback: (NSDictionary)->()){
        //        load settings from Const
        //        let id = Const.playlistsId
        let urlString:String = "https://www.googleapis.com/customsearch/v1?q=\(keyword)&cx=\(cx)&searchType=image&key=\(apiKey)&start=\(idx)"
        let URL = NSURL(string:urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        let req = NSURLRequest(URL: URL!)
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration, delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        
        let task = session.dataTaskWithRequest(req, completionHandler:{
            (data, response, error) -> Void in
            do {
                if((error) != nil){
                    print(error?.description)
                }else{
                    // serialize response data to json
                    // try 例外処理 処理に失敗したときにnilを返す
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments ) as! NSDictionary
                    callback(json)
                    self.idx += 10
                }
            } catch {
                print("JSON error!")
            }
        })
        // ↑で作ったタスクを実行
        task.resume()
    }
}