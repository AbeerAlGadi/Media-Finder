//
//  User.swift
//  Media Finder
//
//  Created by Abeer Sharaf on 5/19/20.
//  Copyright © 2020 Abeer. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

enum Gender: String{
    case femal = "Femal"
    case male = "Male"
}

struct User : Codable {
    var userImage: Image!
    var userFullName: String
    var userPass: String
    var userEmail: String
    var userContactNumber: String
    var genderOfUser: Gender.RawValue
}

struct DetailsAddressFromMap: Codable {
    var fullAddress: String
    var latitude: Double
    var longitude: Double
    var userEmail: String
}

struct Image: Codable{
    var imageData = Data()
    init(withImage image: UIImage) {
        self.imageData = image.pngData()!
    }
    init() {
        
    }
    init(imageData : Data) {
        self.imageData = imageData
    }
    func getImage() -> UIImage? {
        guard case imageData = self.imageData else {
            return nil
        }
        let image = UIImage(data: imageData)
        
        return image
    }
}
