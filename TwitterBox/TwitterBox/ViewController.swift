//
//  ViewController.swift
//  TwitterBox
//
//  Created by Eric Gonzalez on 2/11/16.
//  Copyright © 2016 Eric Gonzalez. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onLogin(sender: AnyObject) {
    TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
    TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token",
      method: "GET", callbackURL: NSURL(string: "ericcptwitterdemo://oauth"), scope: nil,
      success: { (requestToken) -> Void in
      print("Got the request token")
        let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
        UIApplication.sharedApplication().openURL(authURL)
      }) { (error) -> Void in
        print("Failed to get request token")
    }
  }
  
  
}

