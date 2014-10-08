//
//  ContainerViewController.swift
//  twitterredux
//
//  Created by Erin Chuang on 10/4/14.
//  Copyright (c) 2014 Erin Chuang. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, MenuDelegate, TweetsDelegate {
    var menuViewController : UIViewController!
    var activeViewController : UIViewController!
    var previousViewController : UIViewController!
    var subcontrollers : [String: UIViewController]!
    var selectedViewName : String = ""
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var swipeRightGest: UISwipeGestureRecognizer!
    @IBOutlet var swipeLeftGest: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var tweetsViewController = storyboard.instantiateViewControllerWithIdentifier("TweetsViewController") as UIViewController
        self.subcontrollers = [
            "menu" : storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as UIViewController,
            "timeline" : tweetsViewController,
            "profile" : storyboard.instantiateViewControllerWithIdentifier("ProfileViewController") as UIViewController,
            "mentions" : tweetsViewController
        ]
        
        self.menuViewController = self.subcontrollers["menu"]
        let mvc = self.menuViewController as MenuViewController
        mvc.delegate = self
        let tvc = tweetsViewController as TweetsViewController
        tvc.delegate = self
        self.activeViewController = tweetsViewController
        self.addChildViewController(self.activeViewController)
        containerView.addSubview(self.activeViewController.view)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSwipeRight(sender: UISwipeGestureRecognizer) {
        //var location = sender.locationInView(view)
        if (self.activeViewController != menuViewController) {
            if (sender.state == UIGestureRecognizerState.Ended) {
                self.previousViewController = self.activeViewController
                handleViewChange(menuViewController, animateView: menuViewController.view, startX: -view.frame.width, endX: 0)
            }
        }
    }
    
    @IBAction func onSwipeLeft(sender: UISwipeGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.Ended) {
            if (activeViewController == menuViewController) {
                /*
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.activeViewController.view.frame.origin.x = -self.view.frame.width
                    }, completion: { (finished: Bool) -> Void in
                        self.handleViewChange(self.previousViewController)
                })
                */
                handleViewChange(previousViewController, animateView: menuViewController.view, startX: 0, endX: -view.frame.width)
            }
        }
    }
    
    func handleViewChange(vc: UIViewController, animateView: UIView, startX: CGFloat, endX: CGFloat) {
        activeViewController.willMoveToParentViewController(nil)
        addChildViewController(vc)
        self.containerView.addSubview(vc.view)
        if vc.view != animateView {
            self.containerView.bringSubviewToFront(animateView)
        }
        animateView.frame.origin.x = startX
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            animateView.frame.origin.x = endX
            }, completion: { (finished: Bool) -> Void in
                self.activeViewController.view.removeFromSuperview()
                self.activeViewController.removeFromParentViewController()
                self.activeViewController.didMoveToParentViewController(nil)
                vc.didMoveToParentViewController(self)
                self.activeViewController = vc
        })
    }
    
    func handleViewChange(vc: UIViewController) {
        activeViewController.willMoveToParentViewController(nil)
        self.activeViewController.view.removeFromSuperview()
        self.activeViewController.removeFromParentViewController()
        self.activeViewController.didMoveToParentViewController(nil)
        addChildViewController(vc)
        containerView.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
        self.activeViewController = vc
    }
    
    func menuItemSelected(menuItem: String) {
        self.switchView(menuItem)
    }
    
    func userHeaderTapped() {
        self.switchView("profile")
    }
    
    func determineQueryType() -> String {
        return self.selectedViewName
    }
    
    func switchView(viewName: String) -> Void {
        selectedViewName = viewName
        var vc = subcontrollers[viewName]!
        if activeViewController == menuViewController {
            handleViewChange(vc, animateView: menuViewController.view, startX: 0, endX: -view.frame.width)
        } else {
            self.handleViewChange(vc)
        }
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
