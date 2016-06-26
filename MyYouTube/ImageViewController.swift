//
//  ImageViewController.swift
//  MyYouTube
//
//  Created by 松本和也 on 6/26/16.
//  Copyright © 2016 kazuya.matsumoto. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    var imageSearchClient = ImageSearchAPI()
    var dataArray:[NSDictionary] = []
    var idx = 0
    //Common//
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating()
        initImages()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Indicator//
    @IBOutlet var indicator:UIActivityIndicatorView!

    //ToMovieButton//
    @IBOutlet var toMovieButton:UIButton!
    @IBAction func toMovieButtonTapped(){
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewControllerWithIdentifier("movie_mode") as! ViewController
        self.presentViewController(nextView, animated: true, completion: nil)
    }
    
    //LoadImage//
    @IBOutlet var testButton:UIButton!
    @IBOutlet var mainImage:UIImageView!
    @IBAction func loadImage(){
        if dataArray.count == idx {
            loadMoreImages()
        } else {
            let item = dataArray[idx]
            let urlString = item["link"]! as! String
            let url = NSURL(string: urlString);
            let imageData = try! NSData(contentsOfURL: url!, options: .DataReadingMappedIfSafe)
            let img = UIImage(data:imageData)
            mainImage.image = img
            idx += 1
        }
    }
    
    func initImages(){
        imageSearchClient.getImages({[unowned self] json in
            self.dataArray = json["items"] as! [NSDictionary]
            self.loadImage()
            self.indicator.stopAnimating()
            })
    }
    
    func loadMoreImages(){
        mainImage.image = nil
        indicator.startAnimating()
        imageSearchClient.getImages({[unowned self] json in
            self.dataArray = json["items"] as! [NSDictionary]
            self.loadImage()
            self.indicator.stopAnimating()
            })
        idx = 0
    }
}