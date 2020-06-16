//
//  MediaResponse.swift
//  Media Finder
//
//  Created by AbeerSharaf on 6/9/20.
//  Copyright © 2020 Abeer. All rights reserved.
//

import Foundation
import Alamofire

struct MediaResponse: Decodable {
    var resultCount: Int
    var results: [Media]
}


struct Media: Decodable {
    var trackName: String
    var imageUrl: String
    var longDescription: String?
    var artistName: String
    var artistViewUrl: String? // View the artist's works in music & tvShow
    var trackViewUrl: String? // View the track of movie or music & tvShow
    
    enum CodingKeys: String,CodingKey {
        case trackName
        case imageUrl = "artworkUrl100"
        case longDescription
        case artistName
        case artistViewUrl
        case trackViewUrl
    }
}

enum MediaType: String {
    case music = "music"
        case movie = "movie"
    case tvShow = "tvShow"
    case myFavarote = "My Favarote"

}

//struct MyResult {
//    var media: [Media]
//    var userEmail: String
//    
//    enum CodingKeys: String,CodingKey {
//        case userEmail
//    }
//
//}
