//
//  Realm.swift
//  MyYouTube
//
//  Created by 松本和也 on 7/2/16.
//  Copyright © 2016 kazuya.matsumoto. All rights reserved.
//

import RealmSwift

class FavoriteVideos: Object {
    dynamic var testValue = ""
    let videos = List<Video>()
}

class Video: Object {
    dynamic var videoId = ""
}