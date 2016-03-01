//
//  ComposeTweetViewController.swift
//  TwitterBox
//
//  Created by Eric Gonzalez on 2/25/16.
//  Copyright © 2016 Eric Gonzalez. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController {

  @IBOutlet weak var tweetTextView: UITextView!
  
    override func viewDidLoad() {
        super.viewDidLoad()

      tweetTextView.becomeFirstResponder()
      tweetTextView.selectAll(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBAction func onTweet(sender: AnyObject?) {
    Tweet.tweet(tweetTextView.text) { (success, error) -> Void in
      if success {
        self.onCancel(nil)
      }
      else {
        self.alert("Error", message: "Problem sending tweet. You lose.", confirmAction: nil)
      }
    }
  }

  @IBAction func onCancel(sender: AnyObject?) {
    self.navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
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
