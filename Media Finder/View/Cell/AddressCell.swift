//
//  AddressCell.swift
//  DetailAddress
//
//  Created by AbeerSharaf on 5/26/20.
//  Copyright © 2020 Abeer. All rights reserved.
//

import UIKit

class AddressCell: UITableViewCell {
    @IBOutlet weak var FullAddressLabel: UILabel!
    @IBOutlet weak var LattuideLabel: UILabel!
    @IBOutlet weak var LangtuideLabel: UILabel!
    @IBOutlet weak var AddessNoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configureCell(fullAddress: DetailsAddressFromMap,indexPathForAddress: Int){
        self.AddessNoLabel.text = "Address \(indexPathForAddress) ..."
        self.FullAddressLabel.text = "Address : \(fullAddress.fullAddress)"
        self.LattuideLabel.text = "Lattuide : \(String(fullAddress.latitude))"
        self.LangtuideLabel.text = "Langtuide : \(String(fullAddress.longitude))"
    }
    
}

