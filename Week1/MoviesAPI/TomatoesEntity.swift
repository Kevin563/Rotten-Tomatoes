//
//  TomatoesEntity.swift
//  kevin563-Week1
//
//  Created by Kevin Chang on 2015/6/13.
//  Copyright (c) 2015年 Kevin Chang. All rights reserved.
//

import Foundation

class TomatoesEntity {
    
    var id : String!
    var title: String!
    var year: Int!
    var mpaa_rating: String!
    var runtime: Int!
    var critics_consensus: String!
    var release_dates_theater: String!
    var release_dates_dvd: String!
    var ratings_critics_rating: String!
    var ratings_critics_score: Int!
    var ratings_audience_rating: String!
    var ratings_audience_score: Int!
    var synopsis: String!
    var poster: NSData?
    var posters_thumbnail: String!
    var posters_profile: String!
    var posters_detailed: String!
    var posters_original: String!
    
    init (data: NSDictionary) {
        self.id = getStringFromJSON(data, key: "id")
        self.title = getStringFromJSON(data, key: "title")
        self.year = data["year"] as! Int
        self.mpaa_rating = getStringFromJSON(data, key: "mpaa_rating")
        self.runtime = data["runtime"] as! Int
        self.critics_consensus = getStringFromJSON(data, key: "critics_consensus")
        
        let release_dates = data["release_dates"] as! NSDictionary
        self.release_dates_theater = getStringFromJSON(release_dates, key: "theater")
        self.release_dates_dvd = getStringFromJSON(release_dates, key: "dvd")
        
        let ratings = data["ratings"] as! NSDictionary
        self.ratings_critics_rating = getStringFromJSON(ratings, key: "critics_rating")
        self.ratings_critics_score = ratings["critics_score"] as! Int
        self.ratings_audience_rating = getStringFromJSON(ratings, key: "audience_rating")
        self.ratings_audience_score = ratings["audience_score"] as! Int

        self.synopsis = getStringFromJSON(data, key: "synopsis")

        let posters = data["posters"] as! NSDictionary
        self.posters_thumbnail = getStringFromJSON(posters, key: "thumbnail")
        self.posters_profile = getStringFromJSON(posters, key: "profile")
        self.posters_detailed = getStringFromJSON(posters, key: "detailed")
        self.posters_original = getStringFromJSON(posters, key: "original")
    }
    
    func getStringFromJSON(data: NSDictionary, key: String) -> String {
        if let info = data[key] as? String {
            return info
        }
        return ""
    }
}