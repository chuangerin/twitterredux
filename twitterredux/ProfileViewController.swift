//
//  ProfileViewController.swift
//  twitterredux
//
//  Created by Erin Chuang on 10/7/14.
//  Copyright (c) 2014 Erin Chuang. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetsLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    
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
        followersLabel.text = String(user.followersCount)
        followingLabel.text = String(user.following)
        tweetsLabel.text = String(user.statusesCount)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
