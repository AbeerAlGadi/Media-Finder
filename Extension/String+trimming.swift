//
//  String+trimming.swift
//  Media Finder
//
//  Created by AbeerSharaf on 5/19/20.
//  Copyright © 2020 Abeer. All rights reserved.
//

import Foundation
extension String{
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
