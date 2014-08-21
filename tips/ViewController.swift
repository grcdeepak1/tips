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
    @NSCopying var locale: NSLocale?
    
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
        
        //Get the current Date and calc the timeInterval since, last changed Amount
        var possiblePastDate : AnyObject? = defaults.objectForKey("lastChangedDate");
        var possibleBillAmount : AnyObject? = defaults.objectForKey("lastAmount");
        var curDate = NSDate();
        if let pastDate = possiblePastDate as? NSDate {
            var timeSince = curDate.timeIntervalSinceDate(pastDate);
            if let billAmount = possibleBillAmount as? Double {
                if(timeSince < 60) {
                    billField.text = billAmount.bridgeToObjectiveC().stringValue;
                    onEditingChanged(billField);
                }
            }
        }
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        var billAmount =  billField.text.bridgeToObjectiveC().doubleValue;
        let tipPercentages = [0.18, 0.2, 0.22];
        var tipPercentage = tipPercentages[tipControl.selectedSegmentIndex];
        var tip =  billAmount*tipPercentage;
        var amount = billAmount+tip;
        tipLabel.text = currencyFormatter.stringFromNumber(tip);
        totalLabel.text = currencyFormatter.stringFromNumber(amount);

        //Save the NSDate, we can remember the billAmount 1 min
        var curDate = NSDate();
        var defaults = NSUserDefaults.standardUserDefaults();
        defaults.setObject(curDate, forKey: "lastChangedDate");
        
        //Save the lastChanged billAmount
        defaults.setObject(billAmount, forKey: "lastAmount");
        defaults.synchronize();
    }
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true);
    }
    
    //Helper Functions
    var currencyFormatter: NSNumberFormatter {
    let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        return formatter
    }
}

