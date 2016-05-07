//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by David Lawrence on 4/27/16.
//  Copyright © 2016 focusedConcepts. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ConversionViewController loaded its view.")
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
        if let text = textField.text, value = Double(text) {
            farenheitValue = value
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
        let existingTextHasDecimalSeparator = textField.text?.rangeOfString(".")
        let replacementTextHasDecimalSeparator = string.rangeOfString(".")
        
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
