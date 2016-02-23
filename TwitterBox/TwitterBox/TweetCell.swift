//
//  TweetCell.swift
//  TwitterBox
//
//  Created by Eric Gonzalez on 2/19/16.
//  Copyright © 2016 Eric Gonzalez. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {
  
  @IBOutlet weak var profileView: UIImageView!
  @IBOutlet weak var displayNameLabel: UILabel!
  @IBOutlet weak var handleLabel: UILabel!
  @IBOutlet weak var tweetLabel: UILabel!
  @IBOutlet weak var timestampLabel: UILabel!
  
  @IBOutlet weak var retweetButton: UIButton!
  @IBOutlet weak var retweetCountLabel: UILabel!
  
  @IBOutlet weak var likeButton: UIButton!
  @IBOutlet weak var likeCountLabel: UILabel!
  
  var tweet: Tweet! {
    didSet {
      if let imageUrl = tweet?.user.profileImageUrl {
        profileView.setImageWithURL(NSURL(string: imageUrl)!)
      }
      displayNameLabel.text = tweet.user.name
      handleLabel.text = "@\(tweet.user.screenname)"
      tweetLabel.text = tweet.text
      timestampLabel.text = tweet.createdAtString
      retweetButton.setImage(tweet.liked! ? UIImage(named: "retweetOn") : UIImage(named: "retweetOff"), forState: .Normal)
      retweetCountLabel.text = "\(tweet.retweetCounts)"
      likeButton.setImage(tweet.liked! ? UIImage(named: "likeOn") : UIImage(named: "likeOff"), forState: .Normal)
      likeCountLabel.text = "\(tweet.likedCount)"
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    profileView.clipsToBounds = true
    profileView.layer.cornerRadius = 4
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
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
}
