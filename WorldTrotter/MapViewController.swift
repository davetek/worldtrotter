//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by David Lawrence on 5/7/16.
//  Copyright © 2016 focusedConcepts. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var containerView: UIView!
    var mapView: MKMapView!
    
    override func loadView() {
        
        //create a container view
        containerView = UIView()
        
        
        //set this as the main view of this view controller
        view = containerView
        view.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
        
        // create a map view
        mapView = MKMapView()
        
        
        //set this
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        //set the map view as a subview of the container view
        view.addSubview(mapView)
        
        let margins = view.layoutMarginsGuide
        
        let topMapConstraint = mapView.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor)
        let leadingMapConstraint = mapView.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor)
        let trailingMapConstraint = mapView.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor)
        let bottomMapConstraint = mapView.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor)
        
        topMapConstraint.active = true
        leadingMapConstraint.active = true
        trailingMapConstraint.active = true
        bottomMapConstraint.active = true
        
        
        view.bringSubviewToFront(mapView)

        
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor)
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
        
       
        //add a button programmatically
        let userLocationButton = UIButton()
        userLocationButton.titleLabel?.text = "YourLocation"
        userLocationButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)

        userLocationButton.translatesAutoresizingMaskIntoConstraints = true

        view.addSubview(userLocationButton)
        view.bringSubviewToFront(userLocationButton)

        
        let bottomConstraint = userLocationButton.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor)
        let leadingButtonConstraint = userLocationButton.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor)
        let trailingButtonConstraint = userLocationButton.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor)
        
        bottomConstraint.active = true
        leadingButtonConstraint.active = true
        trailingButtonConstraint.active = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MapViewController loaded its view")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print("Check This",view.subviews.map {view in return
            "\(String.fromCString(object_getClassName(view))) \(view.frame) \(view.constraints)"})
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
