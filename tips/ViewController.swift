//
//  ViewController.swift
//  tips
//
//  Created by Deepak on 8/20/14.
//  Copyright (c) 2014 Deepak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet var tipControl: UISegmentedControl!
    @IBOutlet var billField: UITextField!
    @IBOutlet var tipLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tipLabel.text = "$0.00";
        totalLabel.text = "$0.00";
        

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //get the default values for tip percentage
        var defaults = NSUserDefaults.standardUserDefaults();
        var defTipPercentageIndex = defaults.integerForKey("defTipPercentageIndex");
        tipControl.selectedSegmentIndex = defTipPercentageIndex;
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        var billAmount =  billField.text.bridgeToObjectiveC().doubleValue;
        let tipPercentages = [0.18, 0.2, 0.22];
        var tipPercentage = tipPercentages[tipControl.selectedSegmentIndex];
        var tip =  billAmount*tipPercentage;
        var amount = billAmount+tip;
        tipLabel.text = String(format: "$%.2f", tip);
        totalLabel.text = String(format: "$%.2f", amount);
        
    }
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true);
    }

}

