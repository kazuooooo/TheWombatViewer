
//
//  UIPanGestureRecognizerUtil.swift
//  MyYouTube
//
//  Created by 松本和也 on 6/27/16.
//  Copyright © 2016 kazuya.matsumoto. All rights reserved.
//

import Foundation
import UIKit
class UIPanGestureRecognizerUtil{
    
    class func touchPosOfView(recognizer:UIPanGestureRecognizer) -> CGPoint {
        return recognizer.locationInView(recognizer.view!)
    }
    
    class func centerOfView(recognizer:UIPanGestureRecognizer) -> CGPoint{
        return recognizer.view!.center
    }
    
    class func dragView(viewController:UIViewController, recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(viewController.view)
        recognizer.view!.center = CGPoint(x: recognizer.view!.center.x + translation.x, y: recognizer.view!.center.y + translation.y)
        recognizer.setTranslation(CGPointZero, inView: viewController.view)
    }
}