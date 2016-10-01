//
//  FavoriteVideo.swift
//  MyYouTube
//
//  Created by 松本和也 on 9/20/16.
//  Copyright © 2016 kazuya.matsumoto. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class FavoriteVideo: Video {
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    static func favoriteVideo(video:Video){
        let realm = try! Realm()
        let isExisting = isExistingVideo(video.videoId!)
        // add if not registered already
        if(!isExisting){
            print("save video")
            let favoriteVideo = FavoriteVideo()
            favoriteVideo.videoId = video.videoId
            favoriteVideo.title  = video.title
            favoriteVideo.thumbnailURL = video.thumbnailURL
            print(video.channelTitle)
            print(video.publishedAt)
            favoriteVideo.channelTitle = video.channelTitle
            favoriteVideo.publishedAt = video.publishedAt
            try! realm.write{
                realm.add(favoriteVideo)
            }
        }
        print(realm.objects(FavoriteVideo.self))
    }
    
    static func unfavoriteVideo(video:Video){
        let realm = try! Realm()
        let filterString = "videoId == '\(video.videoId!)'"
        print("unfavorite_filter:"+filterString)
        let existingVideo = realm.objects(FavoriteVideo.self).filter(filterString).first
        // なぜかexistingVideoがnilになる
        print(existingVideo)
        try! realm.write{
            realm.delete(existingVideo!)
        }
        print(realm.objects(FavoriteVideo.self))
    }
    
    static func isExistingVideo(videoId:String) -> Bool{
        let realm = try! Realm()
        let filterString = "videoId == '\(videoId)'"
        print("existing_filter:"+filterString)
        let existingVideo = realm.objects(FavoriteVideo.self).filter(filterString)
        if(existingVideo.count == 0){
            return false
        } else {
            return true
        }
    }
    
    static func getFavoriteVideos() -> [Video]{
        //Load FavoriteVideos
        let realm = try! Realm()
        let favoriteVideos = realm.objects(FavoriteVideo.self)
        var videos:[Video] = []
        debugPrint("FAVORITEVIEOES\(favoriteVideos)")
        debugPrint("FAVORITEVIEOESCOUNT\(favoriteVideos.count)")
        if(favoriteVideos.count > 0){
            for i in 0...(favoriteVideos.count - 1){
                print("INDEX\(i)")
                print("VIDEOID\(i)")
                debugPrint(favoriteVideos[i].videoId)
                print("TITLE\(i)")
                debugPrint(favoriteVideos[i].title)
                print("URL\(i)")
                debugPrint(favoriteVideos[i].thumbnailURL)
                let video = Video()
                video.videoId = favoriteVideos[i].videoId
                video.title = favoriteVideos[i].title
                video.thumbnailURL = favoriteVideos[i].thumbnailURL
                video.channelTitle = favoriteVideos[i].channelTitle
                video.publishedAt = favoriteVideos[i].publishedAt
                videos.append(video)
            }
            debugPrint(videos)
        }
        return videos
    }
}