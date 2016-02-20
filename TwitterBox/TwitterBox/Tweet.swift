//
//  Tweet.swift
//  TwitterBox
//
//  Created by Eric Gonzalez on 2/15/16.
//  Copyright © 2016 Eric Gonzalez. All rights reserved.
//

import UIKit

class Tweet: NSObject {
  var user: User!
  var text: String!
  var createdAtString: String!
  var createdAt: NSDate!
  
  var dictionary: NSDictionary
  
  init(dictionary: NSDictionary) {
    self.dictionary = dictionary
    user = User(dictionary: dictionary["user"] as! NSDictionary)
    text = dictionary["text"] as? String
    createdAtString = dictionary["created_at"] as? String
    
    let formatter = NSDateFormatter()
    formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
    createdAt = formatter.dateFromString(createdAtString!)
  }
  
  class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
    var tweets = [Tweet]()
    
    for dictionary in array {
      tweets.append(Tweet(dictionary: dictionary))
    }
    
    return tweets
  }
}
