//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by David Lawrence on 5/7/16.
//  Copyright © 2016 focusedConcepts. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var mapView: MKMapView!
    
    override func loadView() {
        // create a map view
        mapView = MKMapView()
        
        //set it as the main view of this view controller
        view = mapView
        
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor)
        
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor)
        
        topConstraint.active = true
        leadingConstraint.active = true
        trailingConstraint.active = true
        
        // In http://stackoverflow.com/questions/36160075/xcode-7-3-swift-2-no-method-declared-with-objective-c-selector-warning
        // ogres stated that "Swift 2.2 / Xcode 7.3 has a new way to use selector: Selector("funcName") was changed to #selector(ClassName.funcName)"
        // referring to https://github.com/apple/swift-evolution/blob/master/proposals/0022-objc-selectors.md 
        // so I used the #selector(classname.funcname) syntax to point the action to my function, after moving the function up to class scope
        // the errors for the segmentedControl.addTarget method call then went away
        
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged), forControlEvents: .ValueChanged)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MapViewController loaded its view")
    }
    
    //for use in segmented control in override of loadView()
    func mapTypeChanged(segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0: mapView.mapType = .Standard
        case 1: mapView.mapType = .Hybrid
        case 2: mapView.mapType = .Satellite
        default: break
        }
    }

}
