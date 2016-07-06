//
//  MovieViewController.swift
//  MyYouTube
//
//  Created by 松本和也 on 2016/06/04.
//  Copyright © 2016年 kazuya.matsumoto. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON

class MovieViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet var webview:UIWebView!
    @IBOutlet var indicator:UIActivityIndicatorView!
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var video:Video? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        video =  delegate.currentVideo
        let videoId = video?.videoId
        let urlString = "https://www.youtube.com/watch?v=" + videoId!
        let url = NSURL(string: urlString)
        let request = NSURLRequest(URL: url!)
        webview.loadRequest(request)
        webview.delegate = self
        
        indicator.startAnimating()
        webview.hidden = true;
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        indicator.stopAnimating()
        indicator.hidden = true
        webview.fadeIn(FadeType.Slow, completed:nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(sender:AnyObject){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    // Add Favorite
    let realm = try! Realm()
    @IBAction func favoriteTapped(sender:UIButton){
        saveAsFavoriteVideo()
    }
    
    private func saveAsFavoriteVideo(){
        let favoriteVideo = Video()
        favoriteVideo.videoId = (video?.videoId)!
        favoriteVideo.title = video?.title
        favoriteVideo.thumbnailURL = video?.thumbnailURL
        debugPrint("save \(favoriteVideo)")
        try! realm.write{
            realm.add(favoriteVideo)
        }
        print(realm.objects(Video.self))
    }
    
    @IBOutlet var deleteAllButton:UIButton!
    @IBAction func deleteTapped(sender:UIButton){
        try! realm.write{
            realm.deleteAll()
        }
        print(realm.objects(Video.self))
    }
}
