//
//  ImageViewController.swift
//  MyYouTube
//
//  Created by 松本和也 on 6/26/16.
//  Copyright © 2016 kazuya.matsumoto. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //ToMovieButton//
    @IBOutlet var toMovieButton:UIButton!
    @IBAction func toMovieButtonTapped(){
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewControllerWithIdentifier("movie_mode") as! ViewController
        self.presentViewController(nextView, animated: true, completion: nil)
    }
}
