//
//  settingsViewController.swift
//  tips
//
//  Created by Deepak on 8/20/14.
//  Copyright (c) 2014 Deepak. All rights reserved.
//

import UIKit

class settingsViewController: UIViewController {

    @IBOutlet var tipDefaultControl: UISegmentedControl!
    @IBAction func doneSetting(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func defTipChanged(sender: UISegmentedControl) {
        var tipPercentageIndex = tipDefaultControl.selectedSegmentIndex;
        var defaults = NSUserDefaults.standardUserDefaults();
        defaults.setObject(tipPercentageIndex, forKey: "defTipPercentageIndex");
        defaults.synchronize();
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //self.view.backgroundColor = UIColor.lightGrayColor();
        //get the default values for tip percentage
        var defaults = NSUserDefaults.standardUserDefaults();
        var defTipPercentageIndex = defaults.integerForKey("defTipPercentageIndex");
        tipDefaultControl.selectedSegmentIndex = defTipPercentageIndex;
    }

}
