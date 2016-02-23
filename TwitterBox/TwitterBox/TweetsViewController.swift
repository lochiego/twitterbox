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
    
    let image = UIImageView(image: UIImage(named: "TwitterLogo"))
    self.navigationItem.titleView = image
    
    tableView.dataSource = self
    tableView.delegate = self
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableViewAutomaticDimension
    
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: Selector("onRefresh:"), forControlEvents: .ValueChanged)
    self.refreshControl = refreshControl
    
    
    // Set up Infinite Scroll loading indicator
    let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
    loadingMoreView = InfiniteScrollActivityView(frame: frame)
    loadingMoreView!.hidden = true
    tableView.addSubview(loadingMoreView!)
    
    var insets = tableView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    tableView.contentInset = insets
    
    
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
  
  func onRefresh(event: UIEvent) {
    TwitterClient.sharedInstance.fetchTweetsOlderThan(nil) { (tweets, error) -> Void in
      if let tweets = tweets {
        self.tweets = tweets
        self.tableView.reloadData()
      }
      else {
        self.alert("Error", message: "Unable to download feed. Try again later.", confirmAction: nil)
      }
      self.refreshControl?.endRefreshing()
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
  
  var isMoreDataLoading: Bool = false
  var loadingMoreView: InfiniteScrollActivityView!
}

extension TweetsViewController {
  func loadMoreData() {
    let lastTime = tweets.last?.id
    TwitterClient.sharedInstance.fetchTweetsOlderThan(lastTime) { (tweets, error) -> Void in
      if let tweets = tweets {
        // ... Use the new data to update the data source ...
        self.tweets.appendContentsOf(tweets)
        self.tableView.reloadData()
      }
      
      self.loadingMoreView.stopAnimating()
      
      // Update flag
      self.isMoreDataLoading = false
    }
  }
  
  
  override func scrollViewDidScroll(scrollView: UIScrollView) {
    if (!isMoreDataLoading) {
      
      let scrollViewContentHeight = tableView.contentSize.height
      let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.height * 2
      
      if (scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
        isMoreDataLoading = true
        
        // Update position of loadingMoreView, and start loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView.frame = frame
        loadingMoreView.startAnimating()
        
        loadMoreData()
      }
    }
  }

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
