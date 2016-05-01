//
//  ELProfileController.swift
//  eventlist
//
//  Created by SuzukiAkinori on 2016/04/27.
//  Copyright © 2016年 kosa. All rights reserved.
//

import Foundation
import UIKit

class ELProfileController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func editButtonPushed(sender: AnyObject) {
        performSegueWithIdentifier("editProfileSegue", sender: self)
    }
}