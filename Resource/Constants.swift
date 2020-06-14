//
//  Constants.swift
//  Media Finder
//
//  Created by AbeerSharaf on 6/7/20.
//  Copyright © 2020 Abeer. All rights reserved.
//

import UIKit

struct Urls{
    static let madiaBaseUrl = "https://itunes.apple.com/search"
}

struct Params {
    static let term = "term"
    static let media = "media"
}


let image : UIImage = UIImage(named:"userImage")!
let imageData:NSData = image.pngData()! as NSData
let imageInSql = imageData.base64EncodedString(options: .lineLength64Characters)
let dataDecoded:NSData = NSData(base64Encoded: imageInSql, options: NSData.Base64DecodingOptions(rawValue: 0))!
let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
var arrOfAddresses: [DetailsAddressFromMap] = []

