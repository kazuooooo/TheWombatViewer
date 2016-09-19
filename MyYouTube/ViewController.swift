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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var cacheDic:[String:UIImage] = [:]
    let youtubeAPIClient = YoutubeAPI()
    var dataArray:[Video] = []
    let API_ORDERS = [YoutubeAPI.ORDER_RELEVANCE, YoutubeAPI.ORDER_DATE, YoutubeAPI.ORDER_RATING]
    
    //Common//
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        initVideosTable(YoutubeAPI.ORDER_RELEVANCE)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //SegmentControl//
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBAction func indexChanged(sender:UISegmentedControl){
        switch segmentControl.selectedSegmentIndex
        {
        case 0:
            initVideosTable(YoutubeAPI.ORDER_RELEVANCE)
        case 1:
            initVideosTable(YoutubeAPI.ORDER_DATE)
        case 2:
            initVideosTable(YoutubeAPI.ORDER_RATING)
        case 3:
            initVideosTable(YoutubeAPI.ORDER_FAVORITE)
        default:
            print("other tapped??")
        }
        self.tableView.setContentOffset(CGPointZero, animated:true)
    }
    
    //Initial loadings
    private func initVideosTable(order:String){
        if API_ORDERS.contains(order){
            youtubeAPIClient.order = order
            youtubeAPIClient.getVideosJSON({ [unowned self] json -> Void in
                let videos = self.extractVideosFromJson(json)
                self.initVideosTableCallBack(videos)
                })
        }else{
            let videos = FavoriteVideo.getFavoriteVideos()
            self.initVideosTableCallBack(videos)
        }
    }
    
    private func initVideosTableCallBack(videos:[Video]){
        self.youtubeAPIClient.nextPageToken = nil
        self.dataArray = videos
        self.tableView.reloadData()
        self.isLoadingMore = false
    }
    
    // Scroll
    @IBOutlet var scrollView: UIScrollView!
    let threshold:CGFloat = 100.0 // threshold from bottom of tableView
    var isLoadingMore = false // flag
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        // additional load on scroll near bottom
        if !isLoadingMore && (maximumOffset - contentOffset <= threshold) {
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
        return dataArray.count
    }
    
    //Table Cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // set data
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        let video = dataArray[indexPath.row]
        let title = cell.viewWithTag(1) as! UILabel
        title.text = video.title
        let background = cell.viewWithTag(4) as! UIImageView
        let videoId = video.videoId
        
        // cache image
        if let img = cacheDic[videoId!] {
            background.image = img
        }else{
            let urlString = video.thumbnailURL
            let url = NSURL(string: urlString!);
            let imageData = try! NSData(contentsOfURL: url!, options: .DataReadingMappedIfSafe)
            let img = UIImage(data:imageData)
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
    
    //ToMovieButton//
//    @IBOutlet var toImageButton:UIButton!
//    @IBAction func toImageButtonTapped(){
//        let storyboard: UIStoryboard = self.storyboard!
//        let nextView = storyboard.instantiateViewControllerWithIdentifier("image_mode") as! ImageViewController
//        self.presentViewController(nextView, animated: true, completion: nil)
//    }
}

