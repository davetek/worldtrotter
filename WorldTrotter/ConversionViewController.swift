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
    @IBOutlet var textField: UITextField!
    
    @IBAction func farenheitFieldEditingChanged(textField: UITextField) {
        if let text = textField.text where !text.isEmpty {
            celsiusLabel.text = text
        } else {
            celsiusLabel.text = "???"
        }
    }
    
    @IBAction func dismissKeyboard(sender: AnyObject) {
        textField.resignFirstResponder()
    }
}
