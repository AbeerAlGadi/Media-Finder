//
//  User.swift
//  taskOfSession12
//
//  Created by Abeer Sharaf on 5/7/20.
//  Copyright © 2020 Abeer. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import MapKit


struct User : Codable {
    //Better: let constants
    var UserImage: Image?
    var userFullName: String?// Better don't initilize the variable
    var userPass: String!
    var userEmail: String!
    var userContactNumber: String!
    var GenderOfUser: String!
    var address1: String!
    //var address1: Coordinate!
    //var address2: Coordinate?
    //var address3: Coordinate?
}
struct Image: Codable{
    let imageData: Data?
    
    init(withImage image: UIImage) {
        self.imageData = image.pngData()
    }
    
    func getImage() -> UIImage? {
        guard let imageData = self.imageData else {
            return nil
        }
        let image = UIImage(data: imageData)
        
        return image
    }
}

struct Coordinate: Codable {
    let latitude: Double
    let longitude: Double
    
    func locationCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude,
                                      longitude: self.longitude)
    }
}

