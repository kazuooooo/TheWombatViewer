//
//  Const.swift
//  MyYouTube
//
//  Created by 松本和也 on 6/23/16.
//  Copyright © 2016 kazuya.matsumoto. All rights reserved.
//

import Foundation
import UIKit
class Const: NSObject {
    
    // movie search
    static let playlistsId = "RDEMjJwyoVnrXWAjTqxy3NU-Gw"
    static let apiKey = "AIzaSyBrnf1utjawWnWVIbGyzolutHVAfDJUbwA"
    static let csecx="011414427028001942649:vfbik7d0qd8"
    static let searchKeyword = "ウォンバット|wombat|袋熊|вомбат|웜뱃"
    static let maxResults = 10
    
    // list title
    static let listTitleRate = "人気"
    static let listTitleDate = "最新"
    static let listTitleRelevance = "おすすめ"
    static let listTitleFavorite = "お気に入り"
    
    // UI
    static let menuHeight : CGFloat = 64
    static let applicationColor = UIColor(red: 46.0/255.0, green: 204.0/255.0, blue: 113/255.0, alpha: 1.0)
    static let backgroundBrownLight = UIColor(red: 219.0/255.0, green: 161.0/255.0, blue: 106/255.0, alpha: 1.0)
    static let backgroundBrown = UIColor(red: 208.0/255.0, green: 131.0/255.0, blue: 78/255.0, alpha: 1.0)
    static let menuIndicatorColor = UIColor(red: 38.0/255.0, green: 217.0/255.0, blue: 215/255.0, alpha: 1.0)
//    static let backgroundBrown2 = UIColor(red:)
    static let menuOrder = [YoutubeAPI.ORDER_RELEVANCE,
                            YoutubeAPI.ORDER_RATING,
                            YoutubeAPI.ORDER_DATE,
                            YoutubeAPI.ORDER_FAVORITE
    ]
//    static let tabIndicatorColor = UIColor(red:, green:, blue:)
}
