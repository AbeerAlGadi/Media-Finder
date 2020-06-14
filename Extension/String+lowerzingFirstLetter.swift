//
//  String+lowerzingFirstLetter.swift
//  Media Finder
//
//  Created by AbeerSharaf on 6/10/20.
//  Copyright © 2020 Abeer. All rights reserved.
//

import Foundation
extension String {
    func lowerzatingFirstLetter() -> String {
        return prefix(1).lowercased()+self.dropFirst()
    }

    mutating func lowerzatingFirstLetter() {
      self = self.lowerzatingFirstLetter()
    }
}


