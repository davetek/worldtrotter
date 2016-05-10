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
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MapViewController loaded its view")
    }
}
