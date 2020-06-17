//
//  LoginVC.swift
//  Media Finder
//
//  Created by AbeerSharaf on 5/19/20.
//  Copyright © 2020 Abeer. All rights reserved.
//

import UIKit
import SQLite
import NVActivityIndicatorView

class SignInVC: UIViewController {
    
    
    var  loading : NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 70, height: 70), type: .ballRotateChase, color: UIColor.darkGray, padding: 2) // for animated loading
    
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    
    //variables
    var userSignIn: User!
    var database : Connection!
    let userTable = Table("users")
    let userEmail = Expression<String>("userEmail")
    let userPass = Expression<String>("userPass")
    
    
    //MARK: - LifeCycle Methods
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
    
    //MARK: - Functions for validation
    
    func isValidEmail(email:String?) -> Bool {
        guard let email = email?.trimmed, !email.isEmpty else {
            self.showAlert(title: "Error", message: "Enter  valid email")
            return false
        }
        return true
    }
    
    func isValidPassword(password:String?) -> Bool {
        guard let password = password, !password.isEmpty else {
            self.showAlert(title: "Error", message: "Enter your account password")
            return false
        }
        return true
    }
    
    func saveCurrentEmailInUserDefault(_ email: String){
        let userEmailToSave = email
            let defaults = UserDefaults.standard
            defaults.set(userEmailToSave, forKey: "SavedCurrentEmail")
            print("email Current Email saved")
        }
//    func saveEmailForSearchResult(_ email: String) {
//    let userEmailToResult = email
//        let defaults = UserDefaults.standard
//        defaults.set(userEmailToResult, forKey: "userEmailToResult")
//        print("email saved for result")
//    }
    
    func isValidLogin(email1: String,password: String)-> Bool {
        let defaults = UserDefaults.standard
        let userEmail = defaults.stringArray(forKey: "SavedUserEmail") ?? [""]
        for email in userEmail{
            if email1 == email {
                let emailCheck = email1
                print("in User defult: \(email)")
                do{
                    let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
                    let database = try Connection(fileUrl.path)
                    self.database = database
                    do{
                        let users = try self.database.prepare(self.userTable)
                        for user in users {
                            print("inSqlite:\(String(describing: userEmail))")
                            if (emailCheck == email){
                                saveCurrentEmailInUserDefault(email1)
                                print("email true")
                                if emailCheck == email1 {
                                    if password == user[userPass] {
                                    print("password true")
                                    return true
                                } else{
                                    self.showAlert(title: "Error", message: "Invalid Credentials")
                                    return false
                                }
                            }else{
                                self.showAlert(title: "Error", message: "Invalid Credentials")
                                return false
                            }
                        }
                        print("loaded Data from Sqlite3")
                    }
                    }catch{
                        print(error)
                    }
                } catch {
                    print(error)
                }
            }}
        return true
    }
    
    //MARK: - Go To Function
    func goToSignUpScreen(){
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let sbSignUp = sb.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.viewControllers = [sbSignUp]
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func goToMediaListScreenVC(){
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let sbMediaList = sb.instantiateViewController(withIdentifier: "MediaListVC1") as! MediaListVC1
        self.navigationController?.viewControllers = [sbMediaList]
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: - Actions
    @IBAction func signInBtnPressed(_ sender: UIButton) {
        loading.startAnimating()
        guard let email = emailTxtField.text, isValidEmail(email: email) else {return}
        guard let password = passwordTxtField.text, isValidPassword(password: password) else {return}
        let login = isValidLogin(email1: email,password: password)
        if login {
            loading.stopAnimating()
            goToMediaListScreenVC()
        }else {
            self.showAlert(title: "Error", message: "could'nt be logged in your account, try agin")
        }
    }
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        goToSignUpScreen()
    }

}

