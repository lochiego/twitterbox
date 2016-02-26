//
//  TweetComposeView.swift
//  TwitterBox
//
//  Created by Eric Gonzalez on 2/25/16.
//  Copyright © 2016 Eric Gonzalez. All rights reserved.
//

import UIKit

class TweetComposeView: UIView {
  
  @IBOutlet weak var tweetView: UITextView!
  @IBOutlet weak var sendButton: UIButton!
  /*
  // Only override drawRect: if you perform custom drawing.
  // An empty implementation adversely affects performance during animation.
  override func drawRect(rect: CGRect) {
  // Drawing code
  }
  */
  
  override func awakeFromNib() {
    tweetView.layer.borderWidth = 1
    tweetView.layer.cornerRadius = 8
    tweetView.layer.borderColor = UIColor(white: 0.8, alpha: 1.0).CGColor
  }
  
  class func instantiateFromNib() -> TweetComposeView {
    return UINib(nibName: "TweetComposeView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! TweetComposeView
  }
}
