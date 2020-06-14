//
//  APIManager.swift
//  NetworkingDemo
//
//  Created by AbeerSharaf on 6/3/20.
//  Copyright © 2020 Abeer. All rights reserved.
//

import UIKit
import Alamofire


class APIManager {
    static func loadMedia(_ term: String, _ media: String, complation: @escaping (_ error: Error?, _ media: [Media]?) -> Void  /*clouser */) {
        let param = [Params.term: term, Params.media: media]
        AF.request(Urls.madiaBaseUrl, method:HTTPMethod.get, parameters: param, encoding: URLEncoding.default, headers: nil).response { (response) in
            //clouser
            guard response.error == nil else {
                complation(response.error,nil)
                print("error in response")
                return
            }
            guard let data = response.data  else{ //parsing Data
                print("we didn't have any media")
                return
            }
            do{
                let mediaResponse = try JSONDecoder().decode(MediaResponse.self, from: data)
                let meidaArr = mediaResponse.results
                complation(nil,meidaArr)
                print(meidaArr)
                
            }catch{
                print(error)
                print("don't catch array in media")
            }
        }
    }
}
