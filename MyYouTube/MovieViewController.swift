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

    @IBOutlet var starButton:UIButton!
    @IBOutlet var starEmptyButton:UIButton!
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
        indicator.color = UIColor.blackColor()
        webview.hidden = true;
        
        if(FavoriteVideo.isExistingVideo(videoId!)){
            setStarActive(false)
        } else {
            setStarEmpty()
        }
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
        print("push close")
        let transition = TransitionUtil.moveBack()
        self.view.window?.layer.addAnimation(transition, forKey: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    // Add Favorite
    let realm = try! Realm()
    
    
    @IBAction func emptyStarTapped(sender:UIButton){
        FavoriteVideo.favoriteVideo(video!)
        setStarActive(true)
    }
    
    @IBAction func starTapped(sendr:UIButton){
        FavoriteVideo.unfavoriteVideo(video!)
        setStarEmpty()
    }
    
    private func setStarEmpty(){
        starButton.hidden = true
        starEmptyButton.hidden = false
    }
    
    private func setStarActive(animate:Bool){
        starButton.hidden = false
        starEmptyButton.hidden = true
        if(animate){
            UIView.animateWithDuration(0.2, delay: 0.0,options:UIViewAnimationOptions.CurveEaseOut, animations: {
                self.starButton?.transform = CGAffineTransformMakeScale(1.5, 1.5)
                }, completion:{(_) in
                    self.starButton?.transform = CGAffineTransformIdentity
            })
        }
    }
    
    @IBOutlet var deleteAllButton:UIButton!
    @IBAction func deleteTapped(sender:UIButton){
        try! realm.write{
            realm.deleteAll()
        }
        print(realm.objects(Video.self))
    }
}
