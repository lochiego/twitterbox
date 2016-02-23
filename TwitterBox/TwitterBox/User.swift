//
//  User.swift
//  TwitterBox
//
//  Created by Eric Gonzalez on 2/15/16.
//  Copyright © 2016 Eric Gonzalez. All rights reserved.
//

import UIKit

let currentUserKey = "currentUserData"

class User: NSObject {
  var name: String!
  var screenname: String!
  var profileImageUrl: String?
  var bannerImageUrl: String?
  var tagline: String?
  
  var dictionary: NSDictionary
  
  init(dictionary:NSDictionary) {
    self.dictionary = dictionary
    name = dictionary["name"] as? String
    screenname = dictionary["screen_name"] as? String
    profileImageUrl = dictionary["profile_image_url"] as? String
    bannerImageUrl = dictionary["profile_banner_url"] as? String
    tagline = dictionary["description"] as? String
  }
  
  static var _currentUser: User?
  
  class var currentUser: User? {
    get {
      if _currentUser == nil {
        if let userData = NSUserDefaults.standardUserDefaults().dataForKey(currentUserKey) {
          let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
          _currentUser = User(dictionary: dictionary)
        }
      }
      return _currentUser
    }
    set(user) {
      _currentUser = user
      
      let defaults = NSUserDefaults.standardUserDefaults()
      if let user = user {
        let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary, options: [])
        defaults.setObject(data, forKey: currentUserKey)
      }
      else {
        defaults.setObject(nil, forKey: currentUserKey)
      }
      defaults.synchronize()
    }
  }
}
