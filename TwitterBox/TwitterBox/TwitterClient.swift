//
//  TwitterClient.swift
//  TwitterBox
//
//  Created by Eric Gonzalez on 2/11/16.
//  Copyright © 2016 Eric Gonzalez. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "E81wBWkgBLaOoVZbVsxRCIeeA"
let twitterConsumerSecret = "C319VOllswyFg5BOxs8TgrzNh5XcZn2rRY3mcGfxIQFy5BYhp1"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {

  class var sharedInstance: TwitterClient {
    struct Static {
      static let instance = TwitterClient(baseURL: twitterBaseURL,
        consumerKey: twitterConsumerKey,
        consumerSecret: twitterConsumerSecret)

    }
    return Static.instance
  }
  
}
