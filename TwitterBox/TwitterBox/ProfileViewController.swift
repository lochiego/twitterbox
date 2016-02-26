//
//  ProfileViewController.swift
//  TwitterBox
//
//  Created by Eric Gonzalez on 2/25/16.
//  Copyright © 2016 Eric Gonzalez. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
  @IBOutlet weak var bannerView: UIImageView!
  @IBOutlet weak var profileView: UIImageView!
  @IBOutlet weak var nameView: UILabel!
  @IBOutlet weak var handleView: UILabel!
  
  @IBOutlet weak var tweetCountLabel: UILabel!
  @IBOutlet weak var followingCountLabel: UILabel!
  @IBOutlet weak var followersCountLabel: UILabel!
  
  var user: User!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    if let bannerUrl = user.bannerImageUrl {
      bannerView.setImageWithURL(NSURL(string:bannerUrl)!)
    }
    if let profileUrl = user.profileImageUrl {
      profileView.setImageWithURL(NSURL(string:profileUrl)!)
    }
    nameView.text = user.name
    handleView.text = "@\(user.screenname)"
    
    tweetCountLabel.text = "\(user.tweetsCount)"
    followingCountLabel.text = "\(user.followingCount)"
    followersCountLabel.text = "\(user.followersCount)"
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  
  @IBAction func logout(sender: AnyObject?) {
    TwitterClient.sharedInstance.logout()
  }
  
}
