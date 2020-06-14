//
//  LoginVC.swift
//  Media Finder
//
//  Created by AbeerSharaf on 5/19/20.
//  Copyright © 2020 Abeer. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SignInVC: UIViewController {
    
    //variables
    var userSignIn: User!
    
    
    @IBOutlet weak var loginLab: UILabel!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    
    //LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Sign In "
        self.navigationController?.navigationBar.isHidden = true
        UserDefaults.standard.set(false, forKey: "isFirstTime")
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super .viewDidDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    //Functions
    func isValidEmail(email:String?) -> Bool {
        guard let email = email?.trimmed, !email.isEmpty else{
            self.showAlert(title: "Error", message: "Enter  valid email")
            return false
        }
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        if !pred.evaluate(with: email){
            self.showAlert(title: "Error", message: "Enter Valid Email")
        }
        return true
    }
    
    func isValidPassword(password:String?) -> Bool {
        guard password != nil else {
            self.showAlert(title: "Error", message: "Enter your account password")
            return false
        }
        // at least two uppercase,
        // at least one digit
        // at least one lowercase
        // 8 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        if !passwordTest.evaluate(with: password){
            self.showAlert(title: "Error", message: "Enter Valid Password")
        }
        return passwordTest.evaluate(with: password)
    }
    func isValidLogin(email: String,password: String)-> Bool {
        let defaults = UserDefaults.standard
        if let userData = defaults.object(forKey: "SavedUserData") as? Data {
            let decoder = JSONDecoder()
            if let userData = try? decoder.decode(User.self, from: userData){
                if email == userData.userEmail && password == userData.userPass{
                    return true
                }else{
                    self.showAlert(title: "Error", message: "Invalid Credentials")
                    return false
                }
            }
        }
        return true
    }
    func goToProfileScreen(){
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let sbProfile = sb.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.navigationController?.pushViewController(sbProfile, animated: true)
    }
    //Actions
    @IBAction func signInBtnPressed(_ sender: UIButton) {
        guard let email = emailTxtField.text, isValidEmail(email: email) else {return}
        guard let password = passwordTxtField.text, isValidPassword(password: password) else {return}
        let login = isValidLogin(email: email,password: password)
        if login {
            goToProfileScreen()
        }
    }
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let sbSignUp = sb.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(sbSignUp, animated: true)

    }
}
