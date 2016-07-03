//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by David Lawrence on 4/27/16.
//  Copyright © 2016 focusedConcepts. All rights reserved.
//

import UIKit

//Extend NSDate to conform to the Comparable protocol
//from Stack Overflow http://stackoverflow.com/questions/29652771/how-to-check-if-time-is-within-a-specific-range-in-swift


//from Stack Overflow http://footle.org/2014/11/05/fun-with-swift-extensions/ - Comparison Operators for NSDate

class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ConversionViewController loaded its view.")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //code to implement bg color chg based on time-of-day 
        print("ConversionViewController appeared")
        
        //set base constants
        let currentDate = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let currentDateComponents = calendar.components([.Minute, .Hour, .Day, .Month, .Year], fromDate: currentDate)
        
        //set up day components for current day at start of daylight
        let startDayComponents = NSDateComponents()
        startDayComponents.year = currentDateComponents.year
        startDayComponents.month = currentDateComponents.month
        startDayComponents.day = currentDateComponents.day
        startDayComponents.hour = 7
        startDayComponents.minute = 00
        
        //create an NSDate for start of day
        let startDay = calendar.dateFromComponents(startDayComponents)
        
        //set up day components for current day at end of daylight
        let endDayComponents = NSDateComponents()
        endDayComponents.year = currentDateComponents.year
        endDayComponents.month = currentDateComponents.month
        endDayComponents.day = currentDateComponents.day
        endDayComponents.hour = 19
        endDayComponents.minute = 00
        
        //create an NSDate for end of day
        let endDay = calendar.dateFromComponents(endDayComponents)
        
        //compare current date (in particular, time) against start of day and end of day
        var isNight: Bool
        
        let currentToStartTimeComparisonResult: NSComparisonResult = currentDate.compare(startDay!)
        let currentToEndTimeComparisonResult: NSComparisonResult = currentDate.compare(endDay!)
        
        if(currentToStartTimeComparisonResult == NSComparisonResult.OrderedAscending) {
            isNight = true //true if current time is less than (earlier than) time at start of day
        } else if (currentToEndTimeComparisonResult == NSComparisonResult.OrderedDescending) {
            isNight = true //true if current time is greater than (later than) time at end of day
        } else {
            isNight = false  // true if current time is between start and end of day
        }
        
        //change the background color of the conversion view based on whether it is day or night
        //  as learned at http://stackoverflow.com/questions/29759224/change-background-color-of-viewcontroller-swift-single-view-application
        if isNight {
            //set background color dark and text light
            print("set conversion view background color dark and text light")
            self.view.backgroundColor = UIColor.darkGrayColor()
        } else {
            //set background color light and text dark
            print("set conversion view background color light and text dark")
            self.view.backgroundColor = UIColor.whiteColor()
        }
        
        
    }

    
    @IBOutlet var celsiusLabel: UILabel!
    var farenheitValue: Double? {
        didSet {
            updateCelsiusLabel()
        }
    }
    
    var celsiusValue: Double? {
        if let value = farenheitValue {
            return (value - 32) * (5/9)
        }
        else {
            return nil
        }
    }
    
    let numberFormatter: NSNumberFormatter = {
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    @IBOutlet var textField: UITextField!
    
    @IBAction func farenheitFieldEditingChanged(textField: UITextField) {
        if let text = textField.text, number = numberFormatter.numberFromString(text) {
            farenheitValue = number.doubleValue
        }
        else {
            farenheitValue = nil
        }
    }
    
    @IBAction func dismissKeyboard(sender: AnyObject) {
        textField.resignFirstResponder()
    }
    
    func updateCelsiusLabel() {
        if let value = celsiusValue {
            celsiusLabel.text = numberFormatter.stringFromNumber(value)
        }
        else {
            celsiusLabel.text = "???"
        }
    }
    
    func textField(textField: UITextField,
                   shouldChangeCharactersInRange range: NSRange,
                                                 replacementString string: String) -> Bool {
        
        let currentLocale = NSLocale.currentLocale()
        let decimalSeparator = currentLocale.objectForKey(NSLocaleDecimalSeparator) as! String
        
        let existingTextHasDecimalSeparator = textField.text?.rangeOfString(decimalSeparator)
        let replacementTextHasDecimalSeparator = string.rangeOfString(decimalSeparator)
        
        if existingTextHasDecimalSeparator != nil && replacementTextHasDecimalSeparator != nil {
            return false
        }
        else {
            return true
        }
        
        
        //new code based on NSCharacterSet Class Reference and
        // http://stackoverflow.com/questions/24502669/swift-how-to-find-out-if-letter-is-alphanumeric-or-digit
        let alphaCharSet = NSCharacterSet.letterCharacterSet() //create an NSCharacterSet of Unicode letters
        
        var isAlphaChar: Bool = false

        //convert the Swift String entered into an array of Unicode UTF16 characters
        //  then check if any unicode character in the array is an alphabetic character
        for codeUnit in string.utf16 {
            if alphaCharSet.characterIsMember(codeUnit) {
                isAlphaChar = true
            }
        }
      
        if existingTextHasDecimalSeparator != nil && replacementTextHasDecimalSeparator != nil {
            return false
        }
        else if isAlphaChar {
            return false
        }
        else {
            return true
        }
    }
    
    
}
