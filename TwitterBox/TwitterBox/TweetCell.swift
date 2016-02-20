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
  
  var tweet: Tweet! {
    didSet {
      if let imageUrl = tweet?.user.profileImageUrl {
        profileView.setImageWithURL(NSURL(string: imageUrl)!)
      }
        displayNameLabel.text = tweet.user.name
        handleLabel.text = "@\(tweet.user.screenname)"
        tweetLabel.text = tweet.text
        timestampLabel.text = tweet.createdAtString
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

}
