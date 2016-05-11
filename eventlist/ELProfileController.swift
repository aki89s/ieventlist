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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let def : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if def.objectForKey("userRegistered") != nil {
            nameLabel.text = def.objectForKey("userName") as? String
            descLabel.text = def.objectForKey("userDesc") as? String
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func editButtonPushed(sender: AnyObject) {
        performSegueWithIdentifier("editProfileSegue", sender: self)
    }
}