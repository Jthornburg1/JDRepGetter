//game.
//  AppDelegate.swift
//  JDRepGetter
//
//  Created by jonathan thornburg on 11/25/17.
//  Copyright © 2017 jon-thornburg. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker
import GoogleMaps
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    let locationManager = CLLocationManager()
    
    // propublica api key:
    // Y8WBeb3Tu5gMMu5K4uwD0vIXjKMsIEPxESurgAy3
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        }
        GMSPlacesClient.provideAPIKey(KeysAndEndPoints.googlePlacesAPIKey)
        GMSServices.provideAPIKey(KeysAndEndPoints.googleMapsAPIKey)
        
        presentRootView()
        
        return true
    }
    
    func presentRootView() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = SearchVCViewController(nibName: "SearchVCViewController", bundle: nil)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}

