//
//  AddressInMapVC.swift
//  Media Finder
//
//  Created by AbeerSharaf on 5/19/20.
//  Copyright © 2020 Abeer. All rights reserved.
//
import Foundation
import MapKit
import CoreLocation
import UIKit
import SkyFloatingLabelTextField

protocol LocationOfUserAddressDelegate{
    func setDelailLocationInAddress(delailsAddress: String)
}
class AddressInMapVC: UIViewController {
    //variables
    var delegate: LocationOfUserAddressDelegate?
    let locationManager = CLLocationManager()
    let regionMeters: Double = 5000
    var previousLocation:CLLocation?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var takeAddressLoacationLabel: UILabel!
    // @IBOutlet weak var submitAddressLocationPressed: UIButton!
    
    
    override func viewDidLoad() {
        super .viewDidLoad()
        checkLocationService()
        mapView.delegate = self

    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super .viewDidDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    @IBAction func submitAddressLocationPressed(_ sender: UIButton) {
        guard let locationOfAddress = takeAddressLoacationLabel.text, !locationOfAddress.isEmpty else{return}
        delegate?.setDelailLocationInAddress(delailsAddress: locationOfAddress)
        self.navigationController?.popViewController(animated: true)
    }
    //functions
    func setUpLocationManger(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationService(){
        if CLLocationManager.locationServicesEnabled(){
            setUpLocationManger()
            checkLocationAuthorrization()
        }else{
            self.showAlert(title: "Sorry", message: "it can not take your location ")
        }
    }
    func startTrackingUserLocation(){
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)

    }
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func getCenterLocation(for mapView: MKMapView)-> CLLocation {
        let addressLatitude = mapView.centerCoordinate.latitude
        let addressLongitude = mapView.centerCoordinate.longitude
        return CLLocation(latitude: addressLatitude, longitude: addressLongitude)
    }
    
    func checkLocationAuthorrization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTrackingUserLocation()
            break
        case .denied:
            self.showAlert(title: "waring", message: "you can not take your location ")
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    func startUserLocation(){
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }
}

extension AddressInMapVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        checkLocationAuthorrization()
    }
}

extension AddressInMapVC: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for : mapView)
        let geocoder = CLGeocoder()
        guard let previousLocation = self.previousLocation else {return }
        guard center.distance(from: previousLocation) > 50 else {return}
        self.previousLocation = center
        geocoder.reverseGeocodeLocation(center){[weak self](placemark,error) in
            guard let self = self  else {return}
            if let _ = error{
                self.showAlert(title: "Error", message: "it can not take your location ")
                return
            }
            guard let placeMark = placemark?.first else{
                return
            }
            let streetNumber = placeMark.subThoroughfare ?? ""
            let proven = placeMark.administrativeArea ?? ""
            let country = placeMark.country ?? ""
            let city = placeMark.administrativeArea ?? ""
          //  let region = placeMark.name
            //DispatchQueue.main.sync {
                self.takeAddressLoacationLabel.text = "\(country) , \(city) ,\(proven), \(streetNumber)"
           // }
        }
    }
}
