//
//  ImageViewController.swift
//  MyYouTube
//
//  Created by 松本和也 on 6/26/16.
//  Copyright © 2016 kazuya.matsumoto. All rights reserved.
//
import RealmSwift
import UIKit

class ImageViewController: UIViewController {
    
    var imageSearchClient = ImageSearchAPI()
    var dataArray:[NSDictionary] = []
    var dataArrayIdx = 0
    var viewWidth:CGFloat?
    var imageInitialPos:CGPoint?
    var imageContainerInitialPos:CGPoint?
    //Common//
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating()
        initImages()
        initVals()
        imageContainerView.backgroundColor = UIColor.redColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func initVals(){
        viewWidth = self.view.frame.width
        imageInitialPos = mainImage.center
        imageContainerInitialPos = imageContainerView.center
    }
    
    //Indicator//
    @IBOutlet var indicator:UIActivityIndicatorView!
    
    //ToMovieButton//
    @IBOutlet var toMovieButton:UIButton!
    @IBAction func toMovieButtonTapped(){
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewControllerWithIdentifier("movie_list") as! MovieListViewController
        self.presentViewController(nextView, animated: true, completion: nil)
    }
    
    //LoadImage//
    @IBOutlet var imageContainerView: UIView!
    @IBOutlet var mainImage:UIImageView!
    @IBAction func loadImage(){
        if dataArray.count == dataArrayIdx {
            loadMoreImages()
        } else {
            let item = dataArray[dataArrayIdx]
            let urlString = item["link"]! as! String
            let url = NSURL(string: urlString);
            let imageData = try! NSData(contentsOfURL: url!, options: .DataReadingMappedIfSafe)
            let img = UIImage(data:imageData)
            mainImage.image = img
            dataArrayIdx += 1
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
        dataArrayIdx = 0
    }
    
    //ImageDragControl
    var touchStartPosOfView:CGPoint?
    var centerOfImage:CGPoint?
    
    @IBAction func dragImage(recognizer: UIPanGestureRecognizer) {
        //recognize state
        switch recognizer.state {
        case .Began:
            touchStartPosOfView = UIPanGestureRecognizerUtil.touchPosOfView(recognizer)
        case .Changed:
            centerOfImage = UIPanGestureRecognizerUtil.centerOfView(recognizer)
        case .Ended:
            onEndDrag(UIPanGestureRecognizerUtil.centerOfView(recognizer))
        default:
            break;
        }
        // MoveImage
        print(UIPanGestureRecognizerUtil.touchPosOfView(recognizer))
        UIPanGestureRecognizerUtil.dragView(self, recognizer: recognizer)
    }
    
    //Animation called on end drag
    func onEndDrag(dragEndPoint:CGPoint){
        let nopeBorderX:CGFloat = viewWidth! * 0.2
        let likeBorderX:CGFloat = viewWidth! * 0.8
        switch dragEndPoint.x {
        case 0...(nopeBorderX):
            ImageAnimation.nopeAnimation(mainImage, viewController: self, resetImage: {[unowned self] void in self.resetImage()})
        case (likeBorderX)...viewWidth!:
            ImageAnimation.likeAnimation(mainImage, viewController: self, resetImage: {[unowned self] void in self.resetImage()})
        default:
            ImageAnimation.returnAnimation(dragEndPoint, imageContainerInitialPos: imageContainerInitialPos, imageContainerView: imageContainerView)
        }
    }
    
    //resetImage
    func resetImage(){
        print("reest")
        loadImage()
        self.mainImage.center = imageInitialPos!
    }
}