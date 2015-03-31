//
//  InterfaceController.swift
//  Currency Converter WatchKit Extension
//
//  Created by Soojin Ro on 3/31/15.
//  Copyright (c) 2015 NSoojin. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController, NSXMLParserDelegate {
    
    @IBOutlet weak var currencyTable: WKInterfaceTable!
    
    var elementName = ""
    var attributeName = ""
    var getConversionRate = -1
    
    var currencies = ["KRW", "JPY", "INR", "EUR"]
    var conversionRates = [Double](count: 4, repeatedValue: 0.0)
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        let url = NSURL(string: "http://finance.yahoo.com/webservice/v1/symbols/allcurrencies/quote")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if error == nil {
                var xmlParser = NSXMLParser(data: data)
                xmlParser.delegate = self
                xmlParser.parse()
                
                self.currencyTable.setNumberOfRows(self.currencies.count, withRowType: "tableRowController")
                for (index, currency) in enumerate(self.currencies) {
                    if let rowController = self.currencyTable.rowControllerAtIndex(index) as? TableRowController {
                        rowController.currencyLabel.setText(self.currencies[index])
                    }
                }
            } else {
                println(error)
            }
        })
        task.resume()
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        if (segueIdentifier == "showDetail") {
            var context = NSMutableDictionary(capacity: 2)
            context.setObject(currencies[rowIndex], forKey: "currency")
            context.setObject(conversionRates[rowIndex], forKey: "rate")
            return context
        }
        return nil;
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    // MARK: NSXMLParserDelegate
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        self.elementName = elementName
        
        if let attributeName = attributeDict["name"] as? String {
            self.attributeName = attributeName
        } else {
            self.attributeName = ""
        }
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        if elementName == "field" && attributeName == "name" {
            for (index, currency) in enumerate(currencies) {
                if string == "USD/"+currency {
                    getConversionRate = index
                }
            }
        } else if elementName == "field" && attributeName == "price" && getConversionRate != -1{
            if let rate = NSNumberFormatter().numberFromString(string) as? Double {
                conversionRates.insert(rate, atIndex: getConversionRate)
                conversionRates.removeAtIndex(getConversionRate+1)
            }
            getConversionRate = -1
        }
    }
}
