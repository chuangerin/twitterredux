//
//  Tweet.swift
//  twitter
//
//  Created by Erin Chuang on 9/27/14.
//  Copyright (c) 2014 Erin Chuang. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user : User?
    var text : String?
    var createdAtString : String?
    var createdAt : NSDate?
    var timeDiff : String?
    var detailCreatedAt : String?
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    
    init(dictionary: NSDictionary) {
        let hourInDay : Double = 24
        let minInHour : Double = 60
        let secInMin : Double = 60
        let maxDiff = hourInDay * minInHour * secInMin
        let now : NSDate = NSDate()
        user = User(dictionary: dictionary["user"] as NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        formatter.dateFormat = "M/d/yy"
        var diffInSec = abs(now.timeIntervalSinceDate(createdAt!) as Double)
        if diffInSec < maxDiff {
            var diff = Int(diffInSec / secInMin / minInHour)
            if diff > 0 {
                timeDiff = "\(diff)h"
            } else {
                diff = Int(diffInSec / secInMin)
                timeDiff = "\(diff)m"
            }
        } else {
            timeDiff = formatter.stringFromDate(createdAt!)
        }
        formatter.dateFormat = "M/d/yy hh:mm a"
        detailCreatedAt = formatter.stringFromDate(createdAt!)
        retweetCount = dictionary["retweet_count"] as Int
        favoriteCount = dictionary["favorite_count"] as Int
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
}
