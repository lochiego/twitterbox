//
//  Tweet.swift
//  TwitterBox
//
//  Created by Eric Gonzalez on 2/15/16.
//  Copyright © 2016 Eric Gonzalez. All rights reserved.
//

import UIKit

class Tweet: NSObject {
  var id: Int!
  var user: User!
  var text: String!
  var createdAtString: String!
  var createdAt: NSDate!
  var retweeted: Bool!
  var retweetCounts: Int!
  var liked: Bool!
  var likedCount: Int!
  
  var dictionary: NSDictionary
  
  static var formatter: NSDateFormatter {
    let df = NSDateFormatter()
    df.dateFormat = "EEE MMM d HH:mm:ss Z y"
    return df
  }
  
  static var humanFormatter: NSDateFormatter {
    let df = NSDateFormatter()
    df.dateFormat = "hh:mm a - d MMM y"
    return df
  }
  
  
  init(dictionary: NSDictionary) {
    self.dictionary = dictionary
    user = User(dictionary: dictionary["user"] as! NSDictionary)
    id = (dictionary["id"] as! NSNumber).integerValue
    text = dictionary["text"] as! String
    let dateString = dictionary["created_at"] as! String
    
    createdAt = Tweet.formatter.dateFromString(dateString)
    let components = NSCalendar.currentCalendar().components([.Year,.Month,.Day,.Hour,.Minute], fromDate: createdAt, toDate: NSDate(), options: [])
    
    if components.year >= 1 {
      createdAtString = "\(components.year)yr"
    }
    else if components.month >= 1 {
      createdAtString = "\(components.month)mo"
    }
    else if components.day >= 1 {
      createdAtString = "\(components.day)d"
    }
    else if components.hour >= 1 {
      createdAtString = "\(components.hour)h"
    }
    else if components.minute >= 1 {
      createdAtString = "\(components.minute)m"
    }
    else {
      createdAtString = "<1m"
    }
    
    liked = dictionary["favorited"] as! Bool
    likedCount = dictionary["favorite_count"] as! Int
    
    retweeted = dictionary["retweeted"] as! Bool
    retweetCounts = dictionary["retweet_count"] as! Int
  }
  
  class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
    var tweets = [Tweet]()
    
    for dictionary in array {
      tweets.append(Tweet(dictionary: dictionary))
    }
    
    return tweets
  }
}

extension Tweet {
  
  func retweet(retweet: Bool, completion: ((success: Bool, error: NSError?) -> Void)) {
    TwitterClient.sharedInstance.POST("1.1/statuses/\(retweet ? "" : "un")retweet/\(id).json", parameters: nil, progress: nil, success: { (operation, response) -> Void in
      completion(success: true, error: nil)
      }) { (operation, error) -> Void in
        completion(success: false, error: error)
    }
  }
  
  func likeTweet(like: Bool, completion: ((success: Bool, error: NSError?) -> Void)) {
    TwitterClient.sharedInstance.POST("1.1/favorites/\(like ? "create" : "destroy").json", parameters: ["id":id], progress: nil, success: { (operation, response) -> Void in
      completion(success: true, error: nil)
      }) { (operation, error) -> Void in
        completion(success: false, error: error)
    }
  }
  
  func reply(reply: String, completion: ((success: Bool, error: NSError?) -> Void)) {
    if reply.characters.count > 140 {
      completion(success: false, error: NSError(domain: "TwitterBox", code: 1, userInfo: nil))
    }
    else {
      TwitterClient.sharedInstance.POST("1.1/statuses/update.json", parameters: ["status":reply,"in_reply_to_status_id":id], progress: nil, success: { (operation, response) -> Void in
        completion(success: true, error: nil)
        }) { (operation, error) -> Void in
          completion(success: false, error: error)
      }
    }
  }

}
