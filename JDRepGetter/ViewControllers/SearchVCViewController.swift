//
//  SearchVCViewController.swift
//  JDRepGetter
//
//  Created by jonathan thornburg on 11/25/17.
//  Copyright © 2017 jon-thornburg. All rights reserved.
//

import UIKit
import GooglePlaces

class SearchVCViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    var placesClient: GMSPlacesClient!
    let locationManager = CLLocationManager()
    var isAutoCompleting = true
    var currentSearchString = ""
    var places = [GMSPlace]()
    var reps = [CongressPerson]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placesClient = GMSPlacesClient.shared()
        locationManager.delegate = self
        textField.delegate = self
        locationManager.distanceFilter = 500
        locationManager.startUpdatingLocation()
        let googlePlaceCellNib = UINib(nibName: "GooglePlaceCell", bundle: nil)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(googlePlaceCellNib, forCellReuseIdentifier: "GooglePlaceCell")
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: view.frame.width - 212, bottom: 0, right: 0)
        getCurrentPlace()
    }

    func placeAutoComplete(component: String) {
        places = []
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        placesClient.autocompleteQuery(component, bounds: nil, filter: filter) { (results, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                if let rslts = results {
                    for result in rslts {
                        let x = result.placeID
                        self.getGooglePlaceNameFrom(id: x!, handler: { (place) in
                            self.places.append(place)
                            self.tableView.reloadData()
                        })
                    }
                }
            }
        }
    }
    
    func getGooglePlaceNameFrom(id: String, handler:@escaping (GMSPlace) -> Void) {
        placesClient.lookUpPlaceID(id) { (place, error) in
            if let plc = place {
                DispatchQueue.main.async(execute: {
                    handler(plc)
                })
            }
        }
    }
    
    func greenGrass(completion: () -> ()) {
        RepGetter.shared.getRepsBy(zip: textField.text!) { (dictionary) in
            
        }
    }
    
    func getCurrentPlace() {
        placesClient.currentPlace { (list, error) in
            if let lst = list {
                if let lklyhd = lst.likelihoods.first {
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
    }
    
    
    //UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        greenGrass {
            
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        places = []
        tableView.reloadData()
        let combinedString = textField.text! + string
        placeAutoComplete(component: combinedString)
        currentSearchString = combinedString.capitalizingFirstLetter()
        
        return true
    }
    
    // UITableViewDataSource UItableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isAutoCompleting {
            return places.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isAutoCompleting {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GooglePlaceCell") as? GooglePlaceCell
            cell?.placeNameLabel.text = places[indexPath.row].name
            switch indexPath.row {
            case 0:
                cell?.setUpForOdd(isLate: false)
                return cell!
            case 1:
                cell?.setUpForEven(isLate: false)
                return cell!
            default:
                if indexPath.row % 2 == 0 {
                    cell?.setUpForOdd(isLate: true)
                    return cell!
                }
                cell?.setUpForEven(isLate: true)
                return cell!
            }
        } else {
            return UITableViewCell()
        }
    }
}
