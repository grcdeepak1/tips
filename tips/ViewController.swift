//
//  ViewController.swift
//  tips
//
//  Created by Deepak on 8/20/14.
//  Copyright (c) 2014 Deepak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet var animatedView: UIView!
    @IBOutlet var tipControl: UISegmentedControl!
    @IBOutlet var billField: UITextField!
    
    @IBOutlet var anTip: UILabel!
    @IBOutlet var anTotal3: UILabel!
    @IBOutlet var anTotal1: UILabel!
    @IBOutlet var anTotal2: UILabel!
    @IBOutlet var anTotal4: UILabel!
    
    //Getting the currentLocale, so we can format the currency
    var locale = NSLocale.currentLocale()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        anTip.text = currencyFormatter.stringFromNumber(0);
        anTotal1.text = currencyFormatter.stringFromNumber(0);
        anTotal2.text = currencyFormatter.stringFromNumber(0);
        anTotal3.text = currencyFormatter.stringFromNumber(0);
        anTotal4.text = currencyFormatter.stringFromNumber(0);
        
        //Hide the animated view the main view is loaded
        animatedView.hidden=true;
        tipControl.hidden=true;
        billField.selected=true;
        billField.becomeFirstResponder();
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        billField.frame = CGRect(x: 100,y: 200,width: 204,height: 82);
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
                    if(billAmount != 0) {
                        billField.text = String(format: "%.2f", billAmount);
                    } else {
                        billField.text = "";
                    }
                    onEditingChanged(billField);
                }
            }
        }
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        var billAmountString = NSString(string: billField.text);
        var billAmount =  billAmountString.doubleValue;
        if(billAmount != 0) {
            self.animatedView.hidden=false;
            self.tipControl.hidden=false;
            UIView.animateWithDuration(0.5, delay: 0.0,
                options: UIViewAnimationOptions.TransitionFlipFromBottom,
                animations: {
                    self.animatedView.alpha=1;
                    self.tipControl.alpha=1;
                    self.billField.frame = CGRect(x: 100,y: 80,width: 204,height: 82);
                }, completion: { _ in  } );
            
        } else {
            billField.frame = CGRect(x: 100,y: 200,width: 204,height: 82);
            UIView.animateWithDuration(0.5, delay: 0.0,
                options: UIViewAnimationOptions.TransitionFlipFromBottom ,
                animations: {
                    self.animatedView.alpha=0;
                    self.tipControl.alpha=0;
                }, completion: { _ in  } );
            
            self.tipControl.hidden=true;
        }
        
        let tipPercentages = [0.18, 0.2, 0.22];
        var tipPercentage = tipPercentages[tipControl.selectedSegmentIndex];
        var tip =  billAmount*tipPercentage;
        var amount = billAmount+tip;
        
        //Animated Labels
        anTip.text = currencyFormatter.stringFromNumber(tip);
        anTotal1.text = currencyFormatter.stringFromNumber(amount);
        anTotal2.text = currencyFormatter.stringFromNumber(amount/2);
        anTotal3.text = currencyFormatter.stringFromNumber(amount/3);
        anTotal4.text = currencyFormatter.stringFromNumber(amount/4);

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
        formatter.locale = locale
        return formatter
    }
}

