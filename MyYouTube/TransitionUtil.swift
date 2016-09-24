//
//  Transition.swift
//  MyYouTube
//
//  Created by 松本和也 on 9/19/16.
//  Copyright © 2016 kazuya.matsumoto. All rights reserved.
//

import Foundation
import UIKit
class TransitionUtil {
    static func moveForward() -> CATransition {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromRight
        return transition;
    }
    
    static func moveBack() -> CATransition {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromLeft
        return transition
    }
}