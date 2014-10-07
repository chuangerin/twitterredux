//
//  TweetsViewController.swift
//  twitter
//
//  Created by Erin Chuang on 9/27/14.
//  Copyright (c) 2014 Erin Chuang. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tweets: [Tweet]?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if (User.currentUser == nil) {
            return
        }
        let user = User.currentUser!
        if let imgurl = user.profileImageUrl {
            profileImage.setImageWithURL(NSURL(string: imgurl))
        }
        nameLabel.text = user.name
        screenNameLabel.text = user.screenName
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 75
        tableView.rowHeight = UITableViewAutomaticDimension
        
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            if (tweets != nil) {
                println("\(tweets!.count) tweets")
            } else {
                println("no tweets")
            }
            self.tweets = tweets
            self.tableView.reloadData()
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tweets != nil {
            return self.tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("TimelinesCell") as TimelinesCell
        var tweet = self.tweets![indexPath.row] as Tweet
        var user = tweet.user!
        cell.nameLabel.text = user.name
        cell.screenNameLabel.text = "@" + user.screenName! as String
        cell.txtLabel.text = tweet.text
        cell.createdAtLabel.text = tweet.timeDiff
        if let imgurl = user.profileImageUrl {
            cell.profileImage.setImageWithURL(NSURL(string: imgurl))
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    @IBAction func onTap(sender: UITapGestureRecognizer) {
        let vc = self.parentViewController as ContainerViewController
        vc.switchView("profile")
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
