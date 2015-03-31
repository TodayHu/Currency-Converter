//
//  DetailInterfaceController.swift
//  Currency Converter
//
//  Created by Soojin Ro on 3/31/15.
//  Copyright (c) 2015 NSoojin. All rights reserved.
//

import WatchKit
import Foundation


class DetailInterfaceController: WKInterfaceController {

    @IBOutlet weak var dollarsLabel: WKInterfaceLabel!
    @IBOutlet weak var conversionLabel: WKInterfaceLabel!
    @IBOutlet weak var currencyLabel: WKInterfaceLabel!
    
    var rate: Double = 0.0
    var converted: Double = 0.0 {
        didSet {
            conversionLabel.setText(NSString(format: "%.2f", converted))
        }
    }
    
    @IBAction func baseAmountChanged(value: Float) {
        //println(value)
        var numberOfDollars = Int(value)
        dollarsLabel.setText("\(numberOfDollars) USD =")
        converted = Double(numberOfDollars)*rate
    }
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if let dictionary = context as? NSDictionary {
            if let currency = dictionary.objectForKey("currency") as? String {
                currencyLabel.setText(currency)
            }
            if let rate = dictionary.objectForKey("rate") as? Double {
                self.rate = rate
                converted = rate
            }
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}
