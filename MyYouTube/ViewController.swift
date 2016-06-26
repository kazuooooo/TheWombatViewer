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


    // 空のdictionary [:]
    var cacheDic:[String:UIImage] = [:]
    let youtubeAPIClient = YoutubeAPI()
    var dataArray:[NSDictionary] = []
    
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

        if !isLoadingMore && (maximumOffset - contentOffset <= threshold) {
            // Get more data - API call
            self.isLoadingMore = true
            print("reach bottom")
            youtubeAPIClient.getJSON({ [unowned self] json in
                self.dataArray += json["items"] as! [NSDictionary]
                self.tableView.reloadData()
                self.isLoadingMore = false
            })
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
        let videoId = itemDic["id"]?["videoId"] as! String?
        if  (videoId != nil) {
            
        }else{
            print(itemDic)
            print("videoID nil")
        }
        
        // キャシュされた画像があれば使う、なければ取得
        // オプショナルバインディング
        if let img = cacheDic[videoId!] {
            background.image = img
        }else{
            let urlString = itemDic["snippet"]!["thumbnails"]!!["high"]!!["url"] as! String
                    
                        let url = NSURL(string: urlString);
                        let imageData = try! NSData(contentsOfURL: url!, options: .DataReadingMappedIfSafe)
                        let img = UIImage(data:imageData)
                        background.image = img
                        cacheDic[videoId!] = img
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let videoId = dataArray[indexPath.row]["id"]?["videoId"] as? String
        delegate.videoId = videoId
        self.performSegueWithIdentifier("ToMovie", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        // callbackを変数としてselfが参照
        // callback内でselfの変数(dataArrayとtableView)を参照しているので相互でstrong参照してしまっている
        // のでunownedにする必要がある
        // https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html
        youtubeAPIClient.getJSON({ [unowned self] json in
            self.dataArray += json["items"] as! [NSDictionary]
            self.tableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func reloadTable(){
        
    }
}

