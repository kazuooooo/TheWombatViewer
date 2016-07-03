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
//    var dataArray:[JSON] = []
    var dataArray:[Video] = []
    
    
    //Common//
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        setDataBySearch(YoutubeAPI.ORDER_RELEVANCE)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //ToMovieButton//
    @IBOutlet var toImageButton:UIButton!
    @IBAction func toImageButtonTapped(){
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewControllerWithIdentifier("image_mode") as! ImageViewController
        self.presentViewController(nextView, animated: true, completion: nil)
    }
    
    //Table | ScrollView
    @IBOutlet var tableView:UITableView!
    @IBOutlet var scrollView: UIScrollView!
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    // TableViewで一番下までいったときに取得するイベント
    let threshold:CGFloat = 100.0 // threshold from bottom of tableView
    var isLoadingMore = false // flag
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // 今いる位置の座標
        let contentOffset = scrollView.contentOffset.y
        // bottomの座標
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if !isLoadingMore && (maximumOffset - contentOffset <= threshold) {
            // Get more data - API call
            self.isLoadingMore = true
            print("reach bottom")
            youtubeAPIClient.getVideosJSON({ [unowned self] json in
                let videos = self.extractVideosFromJson(json)
                self.initVideosTable(videos)
                })
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // "Cell"をIdentifierとしてUITableViewCellを取り出し
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        
        // indexPath.row is just an Int indicating the selected row of the tableView.
        // dataArrayに入っている各youtubeのjsondataをDictionaryに変換して取り出し
        // 指定した行番号に対応するDataをNSDictionaryにキャストして取り出す
        // こうすることで下のように階層構造的に値を取り出せる
        let video = dataArray[indexPath.row]
        
        let title = cell.viewWithTag(1) as! UILabel

        title.text = video.title
        
        let background = cell.viewWithTag(4) as! UIImageView
        
        let videoId = video.videoId
        
        // キャシュされた画像があれば使う、なければ取得
        // オプショナルバインディング
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
        //このvideoItemにはitemのJSONをそのまま入れる必要あり
        delegate.currentVideo = videoItem
        print("SELECT VIDEOITEM\(videoItem)")
        self.performSegueWithIdentifier("ToMovie", sender: self)
    }
    
    //SegmentControl//
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBAction func indexChanged(sender:UISegmentedControl){
        switch segmentControl.selectedSegmentIndex
        {
        // might add relevance column
        case 0:
            setDataBySearch(YoutubeAPI.ORDER_RELEVANCE)
        case 1:
            setDataBySearch(YoutubeAPI.ORDER_DATE)
        case 2:
            setDataBySearch(YoutubeAPI.ORDER_RATING)
        case 3:
            setDataByFavorite()
        default:
            print("other tapped??")
        }
        self.tableView.setContentOffset(CGPointZero, animated:true)
    }
    
    
    private func setDataBySearch(order:String){
        setORDER(order)
        youtubeAPIClient.getVideosJSON({ [unowned self] json -> Void in
            let videos = self.extractVideosFromJson(json)
            self.initVideosTable(videos)
            })
    }
    
    private func setDataByFavorite(){
        setORDER(YoutubeAPI.ORDER_FAVORITE)
        youtubeAPIClient.getFavoriteVideosJson({[unowned self] videos -> Void in
            self.initVideosTable(videos)
            })
    }
    
    //
    private func extractVideosFromJson(rawJson:JSON) -> [Video]{
        let itemsJson = rawJson["items"]
        var videos:[Video] = []
        for (index,subJson):(String, JSON) in itemsJson {
            let video:Video = Mapper<Video>().map(subJson.rawValue)!
            videos.append(video)
        }
        return videos
    }
    //loadVideos//
    private func initVideosTable(videos:[Video]){
        self.youtubeAPIClient.nextPageToken = nil
        self.dataArray = videos
        self.tableView.reloadData()
        self.isLoadingMore = false
    }
    
    private func reloadVideosTable(videos:[Video]){
        self.dataArray += videos
        self.tableView.reloadData()
        self.isLoadingMore = false
    }
    
    private func setORDER(order:String){
        youtubeAPIClient.order = order
    }
}

