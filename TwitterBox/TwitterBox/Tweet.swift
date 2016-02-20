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
    df.dateFormat = "hh:mm a - d MMM y "
    return df
  }
  
  init(dictionary: NSDictionary) {
    self.dictionary = dictionary
    user = User(dictionary: dictionary["user"] as! NSDictionary)
    id = (dictionary["id"] as! NSNumber).integerValue
    text = dictionary["text"] as! String
    let dateString = dictionary["created_at"] as! String
    
    createdAt = Tweet.formatter.dateFromString(dateString)
    createdAtString = Tweet.humanFormatter.stringFromDate(createdAt)
    
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
