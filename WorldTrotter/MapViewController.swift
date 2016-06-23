//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by David Lawrence on 5/7/16.
//  Copyright © 2016 focusedConcepts. All rights reserved.
//

import UIKit
import MapKit
import AddressBook

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var containerView: UIView!
    var mapView: MKMapView!
    var mapRegion: MKCoordinateRegion!
    
    

    
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
        let userLocationButton = UIButton(type: .Custom)
        userLocationButton.setTitle("Your Location", forState: .Normal)
        
        //set title color
        userLocationButton.setTitleColor(UIColor.grayColor().colorWithAlphaComponent(0.65), forState: .Normal)
        //userLocationButton.titleLabel!.text = "YourLocation"
        //userLocationButton.titleLabel!.hidden = false

        userLocationButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        print(userLocationButton.titleLabel)


        userLocationButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(userLocationButton)
        view.bringSubviewToFront(userLocationButton)

        
        let bottomConstraint = userLocationButton.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor)
        let leadingButtonConstraint = userLocationButton.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor)
        let trailingButtonConstraint = userLocationButton.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor)
        
        bottomConstraint.active = true
        leadingButtonConstraint.active = true
        trailingButtonConstraint.active = true
        
        //userLocationButton.addTarget(self, action: #selector(MapViewController.writeToConsole), forControlEvents: .TouchUpInside)
        userLocationButton.addTarget(self, action: #selector(MapViewController.zoomIn(_:)), forControlEvents: .TouchUpInside)
    }
    
    //test for button action
    func writeToConsole() {
        print("button clicked")
    }
    
    
    //from http://www.techotopia.com/index.php/Working_with_Maps_on_iOS_8_with_Swift,_MapKit_and_the_MKMapView_Class
    func zoomIn(sender: AnyObject) {
        let userLocation = mapView.userLocation
        let region = MKCoordinateRegionMakeWithDistance((userLocation.location?.coordinate)!, 2000, 2000)
        mapView.setRegion(region, animated: true)
    }
    
    //from the top-rated answer in http://stackoverflow.com/questions/25631410/swift-different-images-for-annotation
    // override the MKMapView delegate method viewForAnnotation to set each annotation image programmatically
    //TO DO//
    
    
    //from
    let userIdentifier = "UserLocation"
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MapViewController loaded its view")
        
        //this is the command that determines if user location appears
        mapView.showsUserLocation = true
        
        
        //add pin annotation 01
        let annotation01 = MKPointAnnotation()
        
        let locationBirthplace = CLLocationCoordinate2D(
            latitude: 34.495965,
            longitude: -93.051348
        )
        
        annotation01.coordinate = locationBirthplace
        annotation01.title = "Dave's Birthplace"
        annotation01.subtitle = "Hot Springs, Arkansas"
        
        mapView.addAnnotation(annotation01)
        
        
//        //add pin annotation 02 for the user's location
//        let annotation02 = MKPointAnnotation()
//        
//        //pull latitude and longtitude from user location (my idea)
//        let userLocationLatitude = mapView.userLocation.coordinate.latitude
//        let userLocationLongtitude = mapView.userLocation.coordinate.longitude
//        //use these to create a user location
//        let userLocation = CLLocationCoordinate2D(
//            latitude: userLocationLatitude,
//            longitude: userLocationLongtitude
//        )
//        
//        //create an annotation object for the user's location
//        annotation02.coordinate = userLocation
//        annotation02.title = "You are here"
//        
//        mapView.addAnnotation(annotation02)
        
        
        //add pin annotation
        let annotation03 = MKPointAnnotation()
        
        let locationHiking = CLLocationCoordinate2D(
            latitude: 34.740905,
            longitude: -83.936812
        )
        
        annotation03.coordinate = locationHiking
        annotation03.title = "Blood Mountain"
        annotation03.subtitle = "Blue Ridge Mtns - Georgia"
        
        mapView.addAnnotation(annotation03)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //print("Check This",view.subviews.map {view in return
        //    "\(String.fromCString(object_getClassName(view))) \(view.frame) \(view.constraints)"})
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
