//
//  DataCell.swift
//  Media Finder
//
//  Created by AbeerSharaf on 6/3/20.
//  Copyright © 2020 Abeer. All rights reserved.
//

import UIKit

class DataCell: UITableViewCell {
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userDataLabel: UILabel!
    @IBOutlet var cursorImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func getRediusImage(){
        self.userImageView?.layer.cornerRadius = (self.userImageView?.frame.size.height ?? 0.0) / 2
        self.userImageView?.clipsToBounds = true
        self.userImageView?.layer.borderWidth = 2.0
        self.userImageView?.layer.borderColor = UIColor.white.cgColor
        self.userImageView.clipsToBounds = true
    }
    @available(iOS 13.0, *)
    func configureCell(userData: User , index : Int){
        switch index {
        case 0:
            if (userData.userFullName) == "" {
                self.userImageView.image = userData.userImage.getImage()
                getRediusImage()
                self.userDataLabel.isHidden = true
            }else{
                let userImage = userData.userImage.getImage()
                getRediusImage()
                self.userDataLabel.text = userData.userFullName
                self.userImageView.image = userImage
            }
        case 1:
          //  let image = UIImage(named: "4")
            getRediusImage()
          ///  self.userImageView.image = image
            self.userDataLabel.text = userData.userEmail
            
        case 2:
            self.userDataLabel.text = "\(userData.genderOfUser)"
            self.userImageView.image = UIImage(named: "mediaFinder")
            self.userImageView.image?.withTintColor(.white)
        case 3:
            self.userDataLabel.text = "\(userData.userContactNumber)"
            self.userImageView.image = UIImage(named:"3")
            self.userImageView.image?.withTintColor(.white)
        default: break
        }
    }
}
