//
//  ViewController.swift
//  MyYouTube
//
//  Created by 松本和也 on 2016/06/04.
//  Copyright © 2016年 kazuya.matsumoto. All rights reserved.
//

import UIKit
import SwiftyJSON
import ObjectMapper

class MovieListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var indicator:UIActivityIndicatorView!
    var cacheDic:[String:UIImage] = [:]
    let youtubeAPIClient = YoutubeAPI()
    var dataArray:[Video] = []
    let API_ORDERS = [YoutubeAPI.ORDER_RELEVANCE, YoutubeAPI.ORDER_DATE, YoutubeAPI.ORDER_RATING]
    var apiOrder:String?
    
    //Common//
    override func viewDidLoad() {
        print("call vied did load"+apiOrder!)
        super.viewDidLoad()
        scrollView.delegate = self
        indicator.color = UIColor.blackColor()
        indicator.startAnimating()
        initVideosTable()
    }
    
    override func viewDidAppear(animated: Bool) {
        if isFavoirteOrder() {
            initVideosTable()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Initial loadings
    private func initVideosTable(){
        if isFavoirteOrder(){
            let videos = FavoriteVideo.getFavoriteVideos()
            self.initVideosTableCallBack(videos)
        } else {
            youtubeAPIClient.order = apiOrder!
            youtubeAPIClient.getVideosJSON({ [unowned self] json -> Void in
                let videos = self.extractVideosFromJson(json)
                self.initVideosTableCallBack(videos)
                })
        }
    }
    
    private func isFavoirteOrder() -> Bool {
        return apiOrder == YoutubeAPI.ORDER_FAVORITE
    }
    
    private func initVideosTableCallBack(videos:[Video]){
        self.youtubeAPIClient.nextPageToken = nil
        self.dataArray = videos
        self.tableView.reloadData()
        self.isLoadingMore = false
        indicator.stopAnimating()
        indicator.hidden = true
    }
    
    // Scroll
    @IBOutlet var scrollView: UIScrollView!
    let threshold:CGFloat = 100.0 // threshold from bottom of tableView
    var isLoadingMore = false // flag
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        // additional load on scroll near bottom
        if !isLoadingMore && (maximumOffset - contentOffset <= threshold) && !isFavoirteOrder() {
            self.isLoadingMore = true
            print("reach bottom")
            addVideosTable()
        }
    }
    
    //AdditionalLoad
    private func addVideosTable(){
        if API_ORDERS.contains(youtubeAPIClient.order){
            youtubeAPIClient.getVideosJSON({ [unowned self] json -> Void in
                let videos = self.extractVideosFromJson(json)
                self.addVideosTableCallBack(videos)
                })
        }
    }
    
    private func addVideosTableCallBack(videos:[Video]){
        self.dataArray += videos
        self.tableView.reloadData()
        self.isLoadingMore = false
    }
    
    private func extractVideosFromJson(rawJson:JSON) -> [Video]{
        let itemsJson = rawJson["items"]
        var videos:[Video] = []
        for (_,subJson):(String, JSON) in itemsJson {
            let video:Video = Mapper<Video>().map(subJson.rawValue)!
            videos.append(video)
        }
        return videos
    }
    
    //Table
    @IBOutlet var tableView:UITableView!
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(dataArray.count == Const.maxResults || isFavoirteOrder()){
            tableView.fadeIn(FadeType.Slow, completed:nil)
        }
        return dataArray.count
    }
    
    //Table Cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // set data
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        let video = dataArray[indexPath.row]
        let title = cell.viewWithTag(1) as! UILabel
        let channelTitle = cell.viewWithTag(3) as! UILabel
        let publishedAt = cell.viewWithTag(5) as! UILabel
        let contentView = cell.viewWithTag(10)
        if(indexPath.row % 2 == 0){
            contentView!.backgroundColor = Const.backgroundBrown
        }else{
            contentView!.backgroundColor = Const.backgroundBrownLight
        }
        title.text = video.title
        
        publishedAt.text = DateUtil.sharedInstance.timeStampToDateString(video.publishedAt!)
        channelTitle.text = video.channelTitle
        let background = cell.viewWithTag(4) as! UIImageView
        let videoId = video.videoId
        
        
        // cache image
        if let img = cacheDic[videoId!] {
            background.image = img
        }else{
            let urlString = video.thumbnailURL
            let url = NSURL(string: urlString!);
            var imageData: NSData?
            do {
                imageData = try NSData(contentsOfURL: url!, options: .DataReadingMappedIfSafe)
            } catch {
                imageData = nil
            }
            var img: UIImage;
            if let imageData = imageData {
                img = UIImage(data:imageData)!
            } else {
                img = UIImage(named: "icon")!
            }
            background.image = img
            cacheDic[videoId!] = img
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let videoItem = dataArray[indexPath.row]
        delegate.currentVideo = videoItem
        print("SELECT VIDEOITEM\(videoItem)")
        let transition = TransitionUtil.moveForward()
        self.view.window?.layer.addAnimation(transition, forKey: nil)
        self.performSegueWithIdentifier("ToMovie", sender: self)
    }
}

