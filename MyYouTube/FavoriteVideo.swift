//
//  Realm.swift
//  MyYouTube
//
//  Created by 松本和也 on 7/2/16.
//  Copyright © 2016 kazuya.matsumoto. All rights reserved.
//

import RealmSwift
import ObjectMapper

class FavoriteVideo: Object, Mappable {
    dynamic var videoId:String?
    dynamic var title: String?
    dynamic var thumbnailURL: String?
    
    required convenience init?(_ map: Map) {
        self.init()
    }

    // Mappable
    func mapping(map: Map) {
        videoId      <- map["id.videoId"]
        title        <- map["snippet.title"]
        thumbnailURL <- map["snippet.thumbnails.high.url"]
    }
}