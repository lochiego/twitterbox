//
//  TweetsViewController.swift
//  TwitterBox
//
//  Created by Eric Gonzalez on 2/19/16.
//  Copyright © 2016 Eric Gonzalez. All rights reserved.
//

import UIKit

class TweetsViewController: UITableViewController {
  
  var tweets = [Tweet]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableViewAutomaticDimension
    
    TwitterClient.sharedInstance.fetchTweetsOlderThan(nil) { (tweets, error) -> Void in
      if let tweets = tweets {
        self.tweets.appendContentsOf(tweets)
        self.tableView.reloadData()
      }
      else {
        self.alert("Error", message: "Unable to download feed. Try again later.", confirmAction: nil)
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return tweets.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
    
    // Configure the cell...
    let tweet = tweets[indexPath.row]
    cell.tweet = tweet
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  @IBAction func onLogoutButton(sender: AnyObject) {
    TwitterClient.sharedInstance.logout()
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

extension UIViewController {
  
  func alert(title: String?, message: String?, cancelAction: Bool = false, confirmAction: ((UIAlertAction) -> Void)?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    if cancelAction {
      alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
    }
    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: confirmAction))
    self.presentViewController(alert, animated: true, completion: nil)
  }
  
}