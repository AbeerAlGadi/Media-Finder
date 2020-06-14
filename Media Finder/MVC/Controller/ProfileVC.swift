//
//  ProfileVC.swift
//  Media Finder

//
//  Created by AbeerSharaf on 5/19/20.
//  Copyright © 2020 Abeer. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var contactNumberLabel: UILabel!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var addressOfUserLabel: UILabel!
    
    // variables
    // var userReg: User!
    //LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Profile "
        self.navigationItem.backBarButtonItem?.isEnabled = false
        loadedUserData()
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super .viewDidDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //Functions
    func loadedUserData(){
        let defaults = UserDefaults.standard
        if let userData = defaults.object(forKey: "SavedUserData") as? Data {
            let decoder = JSONDecoder()
            if let userData = try? decoder.decode(User.self, from: userData){
                fullNameLabel.text = "Hallo\(String(describing: userData.userFullName))"
                emailLabel.text = userData.userEmail
                contactNumberLabel.text = userData.userContactNumber
                genderLabel.text = userData.GenderOfUser
                addressOfUserLabel.text = userData.address1
            }
        }
    }
    func goToSignUpScreen(){
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let sbSignUp = sb.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.viewControllers = [sbSignUp]
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    //Actions
    
    @IBAction func logOutBtnPressed(_ sender: UIButton) {
        let alertLogOut = UIAlertController(title:"Confirm", message: "Are you sure you want to log out ? ", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Yes", style:.default)
        { (UIAlertAction) in
            UserDefaults.standard.set(false, forKey:"UserisLogOut")
            UserDefaults.standard.synchronize()
            self.goToSignUpScreen()
        }
        let noAlertAction = UIAlertAction(title: "No", style: .default,handler: nil)
        alertLogOut.addAction(alertAction)
        alertLogOut.addAction(noAlertAction)
        self.present(alertLogOut, animated: true, completion: nil)
        
    }
    
}


