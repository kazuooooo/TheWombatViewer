//
//  ImageAnimation.swift
//  MyYouTube
//
//  Created by 松本和也 on 7/1/16.
//  Copyright © 2016 kazuya.matsumoto. All rights reserved.
//

import Foundation
import UIKit
class ImageAnimation{

    static let moveAmount:CGFloat = 400;
    static let animationTime = 0.2
    
    class func likeAnimation(image:UIImageView, viewController:UIViewController, resetImage:()->Void){
        print("like")
        print(image.center.x)
        print(image.center.y)
        UIView.animateWithDuration(animationTime, delay: 0, options: .CurveEaseIn, animations: {
            image.center.x += moveAmount
            }, completion:  {
                (value: Bool) in
                resetImage()
        })
    }
    
    class func nopeAnimation(image:UIImageView, viewController:UIViewController, resetImage:()->Void){
        print("nope")
        UIView.animateWithDuration(animationTime, delay: 0, options: .CurveEaseIn, animations: {
            image.center.x -= moveAmount
            }, completion:  {
                (value: Bool) in
                resetImage()
        })
    }

    class func returnAnimation(dragEndPoint:CGPoint, imageContainerInitialPos:CGPoint?, imageContainerView: UIView){
        print("return")
        let returnVecX = dragEndPoint.x - imageContainerInitialPos!.x
        let returnVecY = dragEndPoint.y - imageContainerInitialPos!.y
        print("dragEndpoint \(dragEndPoint)")
        print("returnX\(returnVecX)")
        print("returnY\(returnVecY)")
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseIn, animations: {
            imageContainerView.center.x -= returnVecX
            imageContainerView.center.y -= returnVecY
        }, completion: nil)
    }
}