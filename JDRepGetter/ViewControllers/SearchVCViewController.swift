//
//  SearchVCViewController.swift
//  JDRepGetter
//
//  Created by jonathan thornburg on 11/25/17.
//  Copyright © 2017 jon-thornburg. All rights reserved.
//

import UIKit
import GooglePlaces

class SearchVCViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    var placesClient: GMSPlacesClient!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placesClient = GMSPlacesClient.shared()
        locationManager.delegate = self
        textField.delegate = self
        locationManager.distanceFilter = 500
        locationManager.startUpdatingLocation()
        getCurrentPlace()
    }

    func placeAutoComplete() {
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        placesClient.autocompleteQuery(self.textField.text!, bounds: nil, filter: filter) { (results, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                if let rslts = results {
                    for result in rslts {
                        print("Result \(result.attributedFullText) with place id \(String(describing: result.placeID))")
                    }
                }
            }
        }
    }
    
    func greenGrass(completion: () -> ()) {
        RepGetter.shared.getRepsBy(zip: textField.text!) { (dictionary) in
            
        }
    }
    
    func getCurrentPlace() {
        placesClient.currentPlace { (list, error) in
            if let lklyhd = list!.likelihoods.first {
                let plc = lklyhd.place
                self.textField.placeholder = plc.name
                let coord = plc.coordinate
                let urlString = String(format: KeysAndEndPoints.districtFromCoordinateEndpoint,String(describing:coord.latitude),String(describing:coord.longitude))
                RepGetter.shared.getJSONFrom(urlString: urlString, handler: { (jsonArray) in
                    print(jsonArray)
                })
            }
        }
    }
    
    
    //UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        greenGrass {
            
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        placeAutoComplete()
        return true
    }
}
