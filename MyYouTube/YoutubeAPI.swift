//
//  YoutubeAPI.swift
//  MyYouTube
//
//  Created by 松本和也 on 6/26/16.
//  Copyright © 2016 kazuya.matsumoto. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift
import ObjectMapper

class YoutubeAPI:NSObject{
    var nextPageToken:String? = nil
    var order:String = "relevance"
    static let ORDER_RELEVANCE:String = "relevance"
    static let ORDER_DATE:String      = "date"
    static let ORDER_RATING:String    = "rating"
    static let ORDER_FAVORITE:String    = "favorite"
    let apiKey = Const.apiKey
    
    func getVideosJSON(callback: (JSON)->()){
        
        let keyword = Const.searchKeyword
        let maxResults = Const.maxResults
        
        var urlString:String
        if (nextPageToken != nil) {
            urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(keyword)&maxResults=\(maxResults)&key=\(apiKey)&pageToken=\(nextPageToken!)&type=video&order=\(order)"
        } else {
            urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(keyword)&maxResults=\(maxResults)&key=\(apiKey)&type=video&order=\(order)"
        }
        let URL = NSURL(string:urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
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
                    let json = JSON(try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments ))
                    self.nextPageToken = json["nextPageToken"].stringValue as String
                    callback(json)
                }
            } catch {
                print("JSON error!")
            }
        })
        task.resume()
    }
}