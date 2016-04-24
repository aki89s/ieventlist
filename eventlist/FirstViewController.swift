//
//  FirstViewController.swift
//  eventlist
//
//  Created by SuzukiAkinori on 2016/04/24.
//  Copyright © 2016年 kosa. All rights reserved.
//

import UIKit
import BWWalkthrough

class FirstViewController: UIViewController, BWWalkthroughViewControllerDelegate {

    var walkthrough : BWWalkthroughViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if !userDefaults.boolForKey("walkthroughPresented") {
            showWalkthrough()
        }
    }

    @IBAction func showWalkthrough(){
        let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
        walkthrough = stb.instantiateViewControllerWithIdentifier("walk") as? BWWalkthroughViewController
        walkthrough?.delegate = self
        let page_zero = stb.instantiateViewControllerWithIdentifier("walk0")
        let page_one = stb.instantiateViewControllerWithIdentifier("walk1")
        let page_two = stb.instantiateViewControllerWithIdentifier("walk2")
        let page_three = stb.instantiateViewControllerWithIdentifier("walk3")
        walkthrough!.addViewController(page_one)
        walkthrough!.addViewController(page_two)
        walkthrough!.addViewController(page_three)
        walkthrough!.addViewController(page_zero)
        self.presentViewController(walkthrough!, animated: true, completion: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Walkthrough delegate -

    func walkthroughPageDidChange(pageNumber: Int) {
        print("Current Page \(pageNumber)")
    }

    func walkthroughCloseButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}

