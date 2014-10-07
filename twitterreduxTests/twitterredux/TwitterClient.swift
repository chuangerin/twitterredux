//
//  TwitterClient.swift
//  twitterredux
//
//  Created by Erin Chuang on 10/4/14.
//  Copyright (c) 2014 Erin Chuang. All rights reserved.
//

import UIKit

let twitterConsumerKey = "eHCHSVvzwIAAR46unUyHm2dlA"
let twitterConsumerSecret = "l3DjR2t3PEc5Xh7A5JrgMZs8devCDg2NL5aYUv4b6JzoZSIRp4"
let twitterBaseURL = NSURL(string: "https://api.twitter.com");

class TwitterClient: BDBOAuth1RequestOperationManager {
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    class var sharedInstance : TwitterClient {
    struct Static {
        static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params,
            success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
                //println("home timeline: \(response)")
                var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
                completion(tweets: tweets, error: nil)
            },
            failure: { (operation: AFHTTPRequestOperation!, error:NSError!) -> Void in
                println("error getting home timeline")
                completion(tweets: nil, error: error)
            }
        )
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        // fetch request token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterredux://oauth"), scope: nil, success: { (requestToken: BDBOAuthToken!) -> Void in
            println("Got the request token")
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL)
            },
            failure: { (error: NSError!) -> Void in
                println("Failed to request token")
                self.loginCompletion?(user: nil, error: error)
        })
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuthToken(queryString: url.query),
            success: { (accessToken: BDBOAuthToken!) -> Void in
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                println("Got the access token")
                TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil,
                    success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                        //println("user: \(response)")
                        var user = User(dictionary: response as NSDictionary)
                        User.currentUser = user
                        self.loginCompletion?(user: user, error: nil)
                        println("user: \(user.name)")
                    },
                    failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                        println("error getting current user")
                        self.loginCompletion?(user: nil, error: error)
                    }
                )
            }
            )
            { (error: NSError!) -> Void in
                println("Failed to receive access token")
                self.loginCompletion?(user: nil, error: error)
        }
    }
}
