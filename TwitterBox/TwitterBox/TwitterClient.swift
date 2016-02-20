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
  
  static let userDidLogoutNotification = "UserDidLogout"
  
  var loginCompletion: ((user: User?, error: NSError?) -> ())?
  
  class var sharedInstance: TwitterClient {
    struct Static {
      static let instance = TwitterClient(baseURL: twitterBaseURL,
        consumerKey: twitterConsumerKey,
        consumerSecret: twitterConsumerSecret)
      
    }
    return Static.instance
  }
  
  func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
    loginCompletion = completion
    
    // Fetch request token and redirect to authorization page
    TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
    TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token",
      method: "GET", callbackURL: NSURL(string: "ericcptwitterdemo://oauth"), scope: nil,
      success: { (requestToken) -> Void in
        print("Got the request token")
        let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
        UIApplication.sharedApplication().openURL(authURL)
      }) { (error) -> Void in
        print("Failed to get request token")
        self.loginCompletion?(user: nil, error: error)
    }
    
  }
  
  func logout() {
    User.currentUser = nil
    deauthorize()
    
    NSNotificationCenter.defaultCenter().postNotificationName(TwitterClient.userDidLogoutNotification, object: nil)
  }
  
  func openUrl(url: NSURL) -> () {
    fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken) -> Void in
      print("Got the access token")
      TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
      TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (operation, response) -> Void in
        if let response = response {
          let user = User(dictionary: response as! NSDictionary)
          User.currentUser = user
          self.loginCompletion?(user: user, error: nil)
        }
        }, failure: { (operation, error) -> Void in
          self.loginCompletion?(user: nil, error: error)
      })
      }) { (error) -> Void in
        self.loginCompletion?(user: nil, error: error)
    }
  }
  
  func fetchTweetsOlderThan(oldestId: Int?, limit: Int? = 20, callback: ((tweets: [Tweet]?, error: NSError?) -> Void)?) {
    var parameters = [String:AnyObject]()
    if let oldestId = oldestId {
      parameters["max_id"] = oldestId
    }
    if let limit = limit {
      parameters["count"] = limit
    }
    TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json", parameters: parameters, progress: nil, success: { (operation, response) -> Void in
      if let response = response {
        let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
        callback?(tweets: tweets, error: nil)
      }
      }, failure: { (operation, error) -> Void in
        callback?(tweets: nil, error: error)
    })
  }
}
