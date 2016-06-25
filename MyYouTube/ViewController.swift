//
//  ViewController.swift
//  MyYouTube
//
//  Created by 松本和也 on 2016/06/04.
//  Copyright © 2016年 kazuya.matsumoto. All rights reserved.
//

import UIKit
// UITableViewDelegate, UITableViewDataSource プロトコルを追加これらのプロトコルの規約にあるメソッドを実装することを強制する
//UITableViewDelegate : ユーザーがテーブルに何らかの操作を行ったときに実行される処理を定義
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var dataArray:NSArray = []
    // 空のdictionary [:]
    var cacheDic:[String:UIImage] = [:]
    
    @IBOutlet var tableView:UITableView!
    @IBOutlet var scrollView: UIScrollView!
    
//    TableViewの中のセルの数を決める
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
        print("contentOffset\(contentOffset)")
        print("maximumOffset\(maximumOffset)")
        print("value\(maximumOffset - contentOffset)")
        if !isLoadingMore && (maximumOffset - contentOffset <= threshold) {
            // Get more data - API call
            self.isLoadingMore = true
            print("reach bottom")

        }
    }
//    TableViewのcellに表示する内容を指定するメソッド
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // "Cell"をIdentifierとしてUITableViewCellを取り出し
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        
        // indexPath.row is just an Int indicating the selected row of the tableView.
        // dataArrayに入っている各youtubeのjsondataをDictionaryに変換して取り出し
        // 指定した行番号に対応するDataをNSDictionaryにキャストして取り出す
        // こうすることで下のように階層構造的に値を取り出せる
        let itemDic = dataArray[indexPath.row] as! NSDictionary
        
        let title = cell.viewWithTag(1) as! UILabel
        title.text = itemDic["snippet"]?["title"] as? String
        
        let pv = cell.viewWithTag(2) as! UILabel
        pv.text = itemDic["snippet"]?["publishedAt"] as? String
        
        let name = cell.viewWithTag(3) as! UILabel
        name.text = itemDic["snippet"]?["channelTitle"] as? String
        
        let background = cell.viewWithTag(4) as! UIImageView
        let videoId = itemDic["id"]?["videoId"] as! String
        // キャシュされた画像があれば使う、なければ取得
        // オプショナルバインディング
        if let img = cacheDic[videoId] {
            background.image = img
        }else{
            let urlString = itemDic["snippet"]?["thumbnails"]?!["high"]?!["url"] as? String
            let url = NSURL(string: urlString!);
            let imageData = try! NSData(contentsOfURL: url!, options: .DataReadingMappedIfSafe)
            let img = UIImage(data:imageData)
            background.image = img
            cacheDic[videoId] = img
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let videoId = dataArray[indexPath.row]["id"]?!["videoId"] as? String
        delegate.videoId = videoId
        self.performSegueWithIdentifier("ToMovie", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        getJSON()
    }

    func getJSON(){
//        load settings from Const
//        let id = Const.playlistsId
        let apiKey = Const.apiKey
        let keyword = Const.searchKeyword
        let maxResults = Const.maxResults

//        make request
        let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(keyword)&maxResults=\(maxResults)&key=\(apiKey)"
        let URL = NSURL(string:urlString)
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
                    self.dataArray = json["items"] as! NSArray
                    self.tableView.reloadData()
                }
            } catch {
                print("JSON error!")
            }
        })
        
        // ↑で作ったタスクを実行
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

