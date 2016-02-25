//
//  DetailViewController.swift
//  TwitterBox
//
//  Created by Eric Gonzalez on 2/22/16.
//  Copyright © 2016 Eric Gonzalez. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  
  @IBOutlet weak var bannerView: UIImageView!
  @IBOutlet weak var profileView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var handleLabel: UILabel!
  @IBOutlet weak var tweetLabel: UILabel!
  @IBOutlet weak var timestampLabel: UILabel!
  
  @IBOutlet weak var retweetButton: UIButton!
  @IBOutlet weak var retweetCountLabel: UILabel!
  @IBOutlet weak var likeButton: UIButton!
  @IBOutlet weak var likeCountLabel: UILabel!
  
  @IBOutlet weak var doneButton: UIButton!
  
  @IBOutlet weak var replyTextView: UITextView!
  
  var tweet: Tweet!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    doneButton.clipsToBounds = true
    doneButton.layer.backgroundColor = UIColor(red: 0.4, green: 0.8, blue: 1.0, alpha: 1.0).CGColor
    doneButton.layer.cornerRadius = 4
    
    replyTextView.layer.borderWidth = 1
    replyTextView.layer.cornerRadius = 8
    replyTextView.layer.borderColor = UIColor(white: 0.8, alpha: 1.0).CGColor
    
    if let bannerUrlString = tweet.user.bannerImageUrl, bannerUrl = NSURL(string: bannerUrlString) {
      bannerView.setImageWithURL(bannerUrl)
    }
    if let profileUrlString = tweet.user.profileImageUrl, profileUrl = NSURL(string:profileUrlString) {
      profileView.setImageWithURL(profileUrl)
      profileView.clipsToBounds = true
      profileView.layer.cornerRadius = 8
      profileView.layer.borderColor = UIColor.whiteColor().CGColor
      profileView.layer.borderWidth = 2
    }
    
    nameLabel.text = tweet.user.name
    handleLabel.text = tweet.user.screenname
    tweetLabel.text = tweet.text
    timestampLabel.text = Tweet.humanFormatter.stringFromDate(tweet.createdAt)
    retweetButton.setImage(tweet.liked! ? UIImage(named: "retweetOn") : UIImage(named: "retweetOff"), forState: .Normal)
    retweetCountLabel.text = "\(tweet.retweetCounts)"
    likeButton.setImage(tweet.liked! ? UIImage(named: "likeOn") : UIImage(named: "likeOff"), forState: .Normal)
    likeCountLabel.text = "\(tweet.likedCount)"
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onDone(sender: AnyObject) {
    self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func onRetweet(sender: AnyObject) {
    tweet.retweet(!tweet.retweeted) { (success, error) in
      if success {
        let newRetweetStatus = !self.tweet.retweeted!
        self.tweet.retweetCounts! += newRetweetStatus ? 1 : -1
        self.retweetCountLabel.text = "\(self.tweet.retweetCounts)"
        self.tweet.retweeted = newRetweetStatus
        self.retweetButton.setImage(newRetweetStatus ? UIImage(named: "retweetOn") : UIImage(named: "retweetOff"), forState: .Normal)
      }
    }
  }
  
  @IBAction func onLike(sender: AnyObject) {
    tweet.likeTweet(!tweet.liked) { (success, error) in
      if success {
        let newLikeStatus = !self.tweet.liked!
        self.tweet.likedCount! += newLikeStatus ? 1 : -1
        self.likeCountLabel.text = "\(self.tweet.likedCount)"
        self.tweet.liked = newLikeStatus
        self.likeButton.setImage(newLikeStatus ? UIImage(named: "likeOn") : UIImage(named: "likeOff"), forState: .Normal)
      }
    }
  }

  @IBAction func onReply(sender: AnyObject) {
    let replyText = replyTextView.text
    let length = replyText.characters.count
    if length > 0 && length <= 140 {
      tweet.reply(replyText) { (success, error) in
        if success {
          self.replyTextView.editable = false
          self.replyTextView.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        }
      }
    }
  }
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}
