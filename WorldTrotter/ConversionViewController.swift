//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by David Lawrence on 4/27/16.
//  Copyright © 2016 focusedConcepts. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController {
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
            celsiusLabel.text = "\(value)"
        }
        else {
            celsiusLabel.text = "???"
        }
    }
}
