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
    var annotationCoordinates = [CLLocationCoordinate2D]()
    var annotationCoordinatesIndex: Int!
    
    
    override func loadView() {
        
        //create a container view
        containerView = UIView()
        
        
        //set this as the main view of this view controller
        view = containerView
        view.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
        
        // define a map view
        mapView = MKMapView()
        
        //set map view as MKMapViewDelegate
        mapView.delegate = self
        
        
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

        let standardString = NSLocalizedString("Standard", comment: "Standard map view")
        let satelliteString = NSLocalizedString("Satellite", comment: "Satellite map view")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid map view")
        let segmentedControl = UISegmentedControl(items: [standardString, hybridString, satelliteString])
        
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
        
        
        
       
        //add a button programmatically for zooming to the user's location
        let userLocationButton = UIButton(type: .Custom)
        
        //set up the button title for localization
        let userLocationButtonTitleString = NSLocalizedString("Your Location", comment: "Title for Your Location button")
        userLocationButton.setTitle(userLocationButtonTitleString, forState: .Normal)
        
        //set title color, background color, and border width, radius, and color
        userLocationButton.setTitleColor(UIColor.grayColor().colorWithAlphaComponent(0.75), forState: .Normal)
        userLocationButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        userLocationButton.layer.borderWidth = 0.5
        userLocationButton.layer.cornerRadius = 5
        userLocationButton.layer.borderColor = UIColor.blueColor().CGColor

        userLocationButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(userLocationButton)
        view.bringSubviewToFront(userLocationButton)

        //let bottomConstraint = userLocationButton.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor)
        let bottomConstraint = userLocationButton.bottomAnchor.constraintLessThanOrEqualToAnchor(bottomLayoutGuide.topAnchor, constant: -10.0)
        let leadingButtonConstraint = userLocationButton.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor)
        let trailingButtonConstraint = userLocationButton.trailingAnchor.constraintEqualToAnchor(margins.centerXAnchor)
        
        bottomConstraint.active = true
        leadingButtonConstraint.active = true
        trailingButtonConstraint.active = true
        
        //userLocationButton.addTarget(self, action: #selector(MapViewController.writeToConsole), forControlEvents: .TouchUpInside)
        userLocationButton.addTarget(self, action: #selector(MapViewController.zoomIn(_:)), forControlEvents: .TouchUpInside)
        
        
        
        
        //add another button programatically for zooming to each pin annotation on the map
        let goToPinButton = UIButton(type: .Custom)
        let goToPinButtonTitleString = NSLocalizedString("Go to Pin", comment: "Title for Go to Pin button")
        goToPinButton.setTitle(goToPinButtonTitleString, forState: .Normal)
        
        goToPinButton.setTitleColor(UIColor.grayColor().colorWithAlphaComponent(0.75), forState: .Normal)
        goToPinButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        goToPinButton.layer.borderWidth = 0.5
        goToPinButton.layer.cornerRadius = 5
        goToPinButton.layer.borderColor = UIColor.blueColor().CGColor
        
        goToPinButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(goToPinButton)
        
        //let bottomConstraintGoToButton = goToPinButton.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor)
        let bottomConstraintGoToButton = goToPinButton.bottomAnchor.constraintLessThanOrEqualToAnchor(bottomLayoutGuide.topAnchor, constant: -10.0)
        let leadingButtonConstraintGoToButton = goToPinButton.leadingAnchor.constraintEqualToAnchor(margins.centerXAnchor)
        let trailingButtonConstraintGoToButton = goToPinButton.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor)
        
        bottomConstraintGoToButton.active = true
        leadingButtonConstraintGoToButton.active = true
        trailingButtonConstraintGoToButton.active = true
        
        //goToPinButton.addTarget(self, action: #selector(MapViewController.writeToConsole), forControlEvents: .TouchUpInside)
        goToPinButton.addTarget(self, action: #selector(MapViewController.goToAnnotation), forControlEvents: .TouchUpInside)

    }
    
    //test for button action
    func writeToConsole() {
        print("button clicked")
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
    
    
    //from http://www.techotopia.com/index.php/Working_with_Maps_on_iOS_8_with_Swift,_MapKit_and_the_MKMapView_Class
    func zoomIn(sender: AnyObject) {
        let userLocation = mapView.userLocation
        let region = MKCoordinateRegionMakeWithDistance((userLocation.location?.coordinate)!, 2000, 2000)
        mapView.setRegion(region, animated: true)
    }
    
    func goToAnnotation() {
        let pinRegion = MKCoordinateRegionMakeWithDistance(annotationCoordinates[annotationCoordinatesIndex], 8000, 8000)
        mapView.setRegion(pinRegion, animated: true)
        //can use array index generator to automatically provide index that is within array bounds
        
        //increment annotation coordinates array index for the next time the function is called
        if (annotationCoordinatesIndex < annotationCoordinates.count - 1) {
            annotationCoordinatesIndex = annotationCoordinatesIndex + 1
        }
        else {
            annotationCoordinatesIndex = 0
        }
        
    }
    
    //from the top-rated answer in http://stackoverflow.com/questions/25631410/swift-different-images-for-annotation
    // override the MKMapView delegate method viewForAnnotation to set each annotation image programmatically
    //TO DO//
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        annotationCoordinatesIndex = 0 //restart counter
        
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
        annotationCoordinates.append(locationBirthplace)
        
        
        //add pin annotation 02
        let annotation02 = MKPointAnnotation()
        
        let locationScotland = CLLocationCoordinate2D(
            latitude: 56.253786,
            longitude: -4.581686
        )
        
        annotation02.coordinate = locationScotland
        annotation02.title = "Loch Lomond & The Trossachs Nat'l Park"
        annotation02.subtitle = "Scotland"
        
        mapView.addAnnotation(annotation02)
        annotationCoordinates.append(locationScotland)
        

        
        
        //add pin annotation 03
        let annotation03 = MKPointAnnotation()
        
        let locationHiking = CLLocationCoordinate2D(
            latitude: 34.740905,
            longitude: -83.936812
        )
        
        annotation03.coordinate = locationHiking
        annotation03.title = "Blood Mountain"
        annotation03.subtitle = "Blue Ridge Mtns - Georgia"
        
        mapView.addAnnotation(annotation03)
        annotationCoordinates.append(locationHiking)

    }
    
    //implement the MKMapViewDelegate method called when an annotation is added
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        print("annotation was added: ", views[0].annotation?.title, ", coordinates ", views[0].annotation?.coordinate)
    }
    

    
   
    
    

}
