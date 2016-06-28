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
        let nextView = storyboard.instantiateViewControllerWithIdentifier("movie_mode") as! ViewController
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
            print("UIGestureRecognizerState.Began")
            // initialize touch pos of view
            touchStartPosOfView = UIPanGestureRecognizerUtil.touchPosOfView(recognizer)
            print("touchPosofView:\(touchStartPosOfView)")
        case .Changed:
            print("StateChanging")
            centerOfImage = UIPanGestureRecognizerUtil.centerOfView(recognizer)
            print(self.mainImage.center.x)
            //dragging()
        case .Ended:
            print("UIGestureRecognizerState.Ended")
            onEndDrag(UIPanGestureRecognizerUtil.centerOfView(recognizer))
        default:
            break;
        }
        // MoveImage
        print(UIPanGestureRecognizerUtil.touchPosOfView(recognizer))
        UIPanGestureRecognizerUtil.dragView(self, recognizer: recognizer)
    }
    
    
    //Animations//
    func onEndDrag(dragEndPoint:CGPoint){
        let nopeBorderX:CGFloat = viewWidth! * 0.2
        let likeBorderX:CGFloat = viewWidth! * 0.8
        switch dragEndPoint.x {
        case 0...(nopeBorderX):
            nopeAnimation()
        case (likeBorderX)...viewWidth!:
            likeAnimation()
        default:
            returnAnimation(dragEndPoint)
        }
    }
    @IBOutlet var likeButton:UIButton!
    @IBAction func likeTapped(){
        likeAnimation()
        UIImageWriteToSavedPhotosAlbum((mainImage?.image!)!, nil, nil, nil);
    }
    
    @IBOutlet var nopeButton:UIButton!
    @IBAction func nopeTapped(){
        nopeAnimation()
    }
    
    
    func likeAnimation(){
        print("like")
        print(mainImage.center.x)
        print(mainImage.center.y)
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseIn, animations: {
            self.mainImage.center.x += self.view.bounds.width
            }, completion:  {
                (value: Bool) in
                self.resetImage()
        })
    }
    
    func nopeAnimation(){
        print("nope")
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseIn, animations: {
            self.mainImage.center.x -= self.view.bounds.width
            }, completion:  {
                (value: Bool) in
                self.resetImage()
        })
    }
    
    func returnAnimation(dragEndPoint:CGPoint){
        print("return")
        imageContainerView.backgroundColor = UIColor.redColor()
        let returnVecX = dragEndPoint.x - imageContainerInitialPos!.x
        let returnVecY = dragEndPoint.y - imageContainerInitialPos!.y
        print("dragEndpoint \(dragEndPoint)")
        print("imageInitialpos \(imageInitialPos)")
        print("returnX\(returnVecX)")
        print("returnY\(returnVecY)")
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseIn, animations: {
            self.imageContainerView.center.x -= returnVecX
            self.imageContainerView.center.y -= returnVecY
            }, completion: nil)
    }
    
    func resetImage(){
        print("reest")
        loadImage()
        self.mainImage.center = imageInitialPos!
    }
}