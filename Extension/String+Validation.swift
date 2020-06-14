//
//  String+Validation.swift
//  Media Finder
//
//  Created by AbeerSharaf on 5/29/20.
//  Copyright © 2020 Abeer. All rights reserved.
//

import Foundation
extension String {
    
     public func isContactNumber() -> Bool {
        if self.isAllDigits() == true {
            let phoneRegex = "[+270689][0-9]{9}([0-9]{3})?"
            let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            return  predicate.evaluate(with: self)
        }else {
            return false
        }
    }
    
    private func isAllDigits()->Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = self.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  self == filtered
    }
}
