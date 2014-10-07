//
//  ContainerViewController.swift
//  twitterredux
//
//  Created by Erin Chuang on 10/4/14.
//  Copyright (c) 2014 Erin Chuang. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    var menuViewController : UIViewController!
    var activeViewController : UIViewController!
    var previousViewController : UIViewController!
    var subcontrollers : [String: UIViewController]!
    var startX : CGFloat = 0
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var swipeRightGest: UISwipeGestureRecognizer!
    @IBOutlet var swipeLeftGest: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.subcontrollers = [
            "menu" : storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as UIViewController,
            "timeline" : storyboard.instantiateViewControllerWithIdentifier("TweetsViewController") as UIViewController,
            "profile" : storyboard.instantiateViewControllerWithIdentifier("ProfileViewController") as UIViewController
        ]
        self.menuViewController = self.subcontrollers["menu"]
        self.activeViewController = self.subcontrollers["timeline"]
        self.addChildViewController(self.activeViewController)
        containerView.addSubview(self.activeViewController.view)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPan(sender: UIPanGestureRecognizer) {
        var location =  sender.locationInView(view)
        /*
        if (sender.state == UIGestureRecognizerState.Began) {
            //println("begin: \(location.x)")
            startX = location.x
            if activeView != menuView {
                menuView.frame.origin.x = -self.view.frame.width
                containerView.addSubview(menuView)
                activeView = menuView
            } else {
                activeView = nil
            }
            //menuViewController.view.frame.origin.x = -self.view.frame.width
            //containerView.addSubview(menuViewController.view)
        } else if (sender.state == UIGestureRecognizerState.Changed) {
            if activeView != menuView {
                menuView.frame.origin.x = location.x - startX
            } else {
                menuView.frame.origin.x = -self.view.frame.width + (location.x - startX)
            }
            //menuViewController.view.frame.origin.x = -self.view.frame.width + (location.x - startX)
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            //println("end: \(location.x)")
            //var velocity = sender.velocityInView(view)
            if activeView != menuView {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.menuView.frame.origin.x = self.view.frame.width
                    //self.menuViewController.view.frame.origin.x = 0
                    //self.panGest.enabled = false
                })
            } else {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.menuView.frame.origin.x = 0
                    //self.menuViewController.view.frame.origin.x = 0
                    //self.panGest.enabled = false
                })
            }
        }
        */
    }

    @IBAction func onSwipeRight(sender: UISwipeGestureRecognizer) {
        var location = sender.locationInView(view)
        if (self.activeViewController != menuViewController) {
            if (sender.state == UIGestureRecognizerState.Ended) {
                self.previousViewController = self.activeViewController
                self.handleViewChange(menuViewController)
                self.activeViewController.view.frame.origin.x = -self.view.frame.width
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.activeViewController.view.frame.origin.x = 0
                })
            }
        }
    }
    
    @IBAction func onSwipeLeft(sender: UISwipeGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.Ended) {
            if (self.activeViewController == menuViewController) {
                self.activeViewController.view.frame.origin.x = 0
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.activeViewController.view.frame.origin.x = -self.view.frame.width
                    }, completion: { (finished: Bool) -> Void in
                    self.handleViewChange(self.previousViewController)
                })
            }
        }
    }
    
    func handleViewChange(vc: UIViewController) {
        self.activeViewController.willMoveToParentViewController(nil)
        self.activeViewController.removeFromParentViewController()
        self.activeViewController.didMoveToParentViewController(nil)
        self.addChildViewController(vc)
        self.activeViewController = vc
        self.containerView.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
    }
    
    func switchView(viewName: String) -> Void {
        var vc = self.subcontrollers[viewName]!
        self.handleViewChange(vc)
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
