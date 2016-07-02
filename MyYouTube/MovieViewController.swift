//
//  MovieViewController.swift
//  MyYouTube
//
//  Created by 松本和也 on 2016/06/04.
//  Copyright © 2016年 kazuya.matsumoto. All rights reserved.
//

import UIKit
import RealmSwift

class MovieViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet var webview:UIWebView!
    @IBOutlet var indicator:UIActivityIndicatorView!
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let urlString = "https://www.youtube.com/watch?v=" + delegate.videoId!
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
        saveFavoriteVideos()
    }
    
    private func saveFavoriteVideos(){
        var favoriteVideos:FavoriteVideos? = realm.objects(FavoriteVideos).first
        let video = Video()
        let videoId = delegate.videoId!
        video.videoId = videoId
        // First or Initialize
        if (favoriteVideos == nil) {
            favoriteVideos = FavoriteVideos()
        }
        try! realm.write{
            favoriteVideos!.videos.append(video)
            realm.add(favoriteVideos!)
        }
        print(favoriteVideos)
    }
}
