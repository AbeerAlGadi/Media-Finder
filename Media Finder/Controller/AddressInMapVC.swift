//
//  AddressInMapVC.swift
//  Media Finder
//
//  Created by AbeerSharaf on 5/19/20.
//  Copyright © 2020 Abeer. All rights reserved.
//
import MapKit
import CoreLocation
import UIKit

protocol LocationOfUserAddressDelegate{
    func setDelailLocationInAddress1(delailsAddress1: String, latitude: Double, longitude: Double)
}

class AddressInMapVC: UIViewController {
    //variables
    var delegate: LocationOfUserAddressDelegate?
    let locationManager = CLLocationManager()
    let regionMeters: Double = 10000
    var previousLocation:CLLocation?
    
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var takeAddressLoacationLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    //Life cycle
    override func viewDidLoad() {
        super .viewDidLoad()
        checkLocationService()
        mapView.delegate = self
        locationManager.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super .viewDidDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    //Actions
    @IBAction func submitAddressLocationPressed(_ sender: UIButton) {
        sendDataOfLocation()
    }
    // Functions
    func sendDataOfLocation(){
        guard let locationOfAddress = takeAddressLoacationLabel.text, !locationOfAddress.isEmpty else{return}
        let longitude1 = Double(longitudeLabel.text ?? "")
        let altitude1 =  Double(altitudeLabel.text ?? "")
        self.delegate?.setDelailLocationInAddress1(delailsAddress1: locationOfAddress, latitude: altitude1 ?? 0 , longitude: longitude1 ?? 0 )
        self.navigationController?.popViewController(animated: true)
    }
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
// extension :
extension AddressInMapVC : MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for : mapView)
        let geocoder = CLGeocoder()
        guard let previousLocation = self.previousLocation else {return }
        guard center.distance(from: previousLocation) > 100 else {return}
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
            let country = placeMark.country
            let city = placeMark.administrativeArea
            let longitude = mapView.centerCoordinate.longitude
            let latitude = mapView.centerCoordinate.latitude
            let region = placeMark.name
            self.takeAddressLoacationLabel.text = "\(country ?? ""), \(city ?? ""), \(region ?? "" )"
            self.altitudeLabel.text = String(latitude)
            self.longitudeLabel.text = String(longitude)
        }
    }
}
