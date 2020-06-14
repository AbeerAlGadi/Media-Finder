//
//  SignUpVC.swift
//  Media Finder
//
//  Created by AbeerSharaf on 5/19/20.
//  Copyright © 2020 Abeer. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SQLite
import SkyFloatingLabelTextField

class SignUpVC: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var fullNameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var passwordConformTxtField: UITextField!
    @IBOutlet weak var contactNumberTxtField: UITextField!
    @IBOutlet weak var addressOfUserTxtField: UITextField!
    @IBOutlet weak var address2OfUserTxtField: UITextField!
    @IBOutlet weak var address3OfUserTxtField: UITextField!
    @IBOutlet weak var femalLabel: UILabel!
    @IBOutlet weak var maleLabel: UILabel!
    
    //MARK: - variables
    var firstAddress: DetailsAddressFromMap?
    var secondAddress: DetailsAddressFromMap?
    var thirdAddress: DetailsAddressFromMap?
    var arrOfAddresses: [DetailsAddressFromMap] = []
    var noOfAddress: Int!
    var imagePicker: ImagePicker!
    var imagePicker1 = UIImagePickerController()
    var signInImage: UIImage!
    var userImage: UIImage!
    var userImage1: UIImage!
    var gender = Gender.femal.rawValue
    var email: String = ""
    //***************************** FOR SQLITE3 BUILD TABLE **************************************************
    var database : Connection!
    var database1 : Connection!
    
    //MARK: - Constants
    let userAddressTable = Table("userAddress")
    let fullAddress = Expression<String>("fullAddress")
    let latitude = Expression<Double>("latitude")
    let longitude = Expression<Double>("longitude")
    
    let userTable = Table("users")
    let id = Expression<Int>("id")
    let userName = Expression<String>("userName")
    let userPass = Expression<String>("userPass")
    let userEmail = Expression<String>("userEmail")
    let userContactNumber = Expression<String>("userContactNumber")
    let genderOfUser = Expression<String>("genderOfUser")
    let arrOfUserAddresses = Expression<[String]>("arrOfUserAddresses")
    let ImageOfUser = Expression<Data>("ImageOfUser")
    //***************************************************************************************
    
    //MARK: -LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "CREATR ACCOUNT"
        self.navigationItem.titleView?.tintColor = femalLabel.textColor
        self.imagePicker = ImagePicker(presentationController: self, delegate: self) // to view from what i chioce my image
        userImage = UIImage(named: "userImage")
        imageView.image = userImage
        //***************************** FOR LINK PAHT OF DATABASE OF USER ************************************
        openDBTocreateUserTable()
        createUserTable()
        openDBTocreateAddressTable()
        createAddressTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .clear
    }
    
    //MARK: - ***************************** Actions ************************************
    @IBAction func joinBtnPressed(_ sender: UIButton){
        chackUserData()
    }
    
    @IBAction func imageBtnPressed(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func isMaleOrFemal(_ sender: UISwitch) {
        if !sender.isOn{
            gender = Gender.male.rawValue
        }
    }
    
    @IBAction func addressLoctionPressed(_ sender: UIButton) {
        goToMapScreen()
        noOfAddress = 1
    }
    
    @IBAction func address2LoctionPressed(_ sender: UIButton) {
        goToMapScreen()
        noOfAddress = 2
    }
    
    @IBAction func address3LoctionPressed(_ sender: UIButton) {
        goToMapScreen()
        noOfAddress = 3
    }
    
    //MARK: - Functions
    
    //MARK: - ************************** Validation Functions ********************************************************
    
    func isValidEmail(email:String?) -> Bool {
        guard let email = email?.trimmed, !email.isEmpty else{
            self.showAlert(title: "Error", message: "Enter Valid Email")
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
        // at least two uppercase, at least one digit, at least one lowercase, 8 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        if !passwordTest.evaluate(with: password){
            self.showAlert(title: "Error", message: "Enter Valid Password")
            return false
        }
        return passwordTest.evaluate(with: password)
    }
    
    func isConfirmPassword(confirmPassword: String?, password: String) -> Bool {
        guard confirmPassword != nil else {
            self.showAlert(title: "Error", message: "Enter your Confirm of your password")
            return false
        }
        if confirmPassword == password{
            return true
        }else {
            self.showAlert(title: "Error", message: "Enter the correct Confirm of your password")
        }
        return  true
    }
    
    func chackUserData(){
        let name = fullNameTxtField.text ?? ""
        guard let email = emailTxtField.text, isValidEmail(email: email) else {return}
        guard let password = passwordTxtField.text, isValidPassword(password: password) else {return}
        guard let confirmPassword = passwordConformTxtField.text, isConfirmPassword(confirmPassword: confirmPassword, password: password) else {return}
        guard let contactNumber = contactNumberTxtField.text, !contactNumber.isEmpty, contactNumber.isContactNumber() else {
            self.showAlert(title: "Error", message: "Enter Valid Contact Number (list of 13 number that begin by one of [[+270689]])")
            return
        }
        guard let firstAddress = addressOfUserTxtField.text, !firstAddress.isEmpty else {
            self.showAlert(title: "Sorry", message: "Enter at least one address ...")
            return
        }
        
        guard UIImage(named: "userImage") != nil else  {
            self.showAlert(title: "Error", message: "enter your image ,please! ")
            return
        }
        
        userImage = self.imageView.image
        let imageData:NSData = userImage.pngData()! as NSData
        
        saveDataInSQLite(name, email, password, contactNumber, imageData as Data, Gender(rawValue: gender as Gender.RawValue)!)
        self.email = email
        saveEmailInUserDefault(email)
        
        goToSignInScreen()
    }
    
    
    //MARK:- ********************************* Go Next Screens Functions *******************************************
    
    func goToSignInScreen(){
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let sbSignIn = sb.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        self.navigationController?.pushViewController(sbSignIn, animated: true)
        print("go to SignInVC")
    }
    
    func goToMapScreen(){
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let sbMapScreen = sb.instantiateViewController(withIdentifier: "AddressInMapVC") as! AddressInMapVC
        sbMapScreen.delegate = self
        self.navigationController?.pushViewController(sbMapScreen, animated: true)
    }
    
    //MARK:- ******************************** Saving Data In Different Storage type *********************************
    func saveEmailInUserDefault(_ email: String){
        let userEmailToSave = email
        let defaults = UserDefaults.standard
        var userEmail = defaults.stringArray(forKey: "SavedUserEmail")
        userEmail?.append(email)
        defaults.set(userEmail, forKey: "SavedUserEmail")
        print("email saved\([userEmailToSave])")
    }
    
    func saveDataInSQLite(_ name: String, _ email: String, _ password: String, _ contactNumber: String, _ userImage: Data,_ gender: Gender){
        let insertUser = self.userTable.insert(self.userName <- name, self.userEmail <- email, self.userPass <- password, self.userContactNumber <- contactNumber, self.ImageOfUser <- userImage, self.genderOfUser <- gender.rawValue)
        do{
            try self.database.run(insertUser)
            print("Inserted User")
        }catch{
            print(error)
        }
    }
    
    func saveAddressesInSQLite(_ fullAddress: String, _ email: String, _ latitude: Double, _ longitude: Double){
        let insertaddress = self.userAddressTable.insert(self.userEmail <- email, self.fullAddress <- fullAddress, self.latitude <- latitude, self.longitude <- longitude)
        print("insertaddress \(insertaddress)")
        do{
            try self.database1.run(insertaddress)
            print("Inserted Address")
        }catch{
            print(error)
        }
    }
    //MARK:- Functions to Open Data Base
    
    func openDBTocreateUserTable(){
        do{
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
    }
    
    func openDBTocreateAddressTable(){
        do{
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl2 = documentDirectory.appendingPathComponent("userAddress").appendingPathExtension("sqlite3")
            let database1 = try Connection(fileUrl2.path)
            self.database1 = database1
        } catch {
            print(error)
        }
    }
    
    //MARK:- Functions To create Tables in SQLITE
    func createAddressTable(){
        let createAddressTable = self.userAddressTable.create { (table) in
            table.column(self.userEmail)
            table.column(self.fullAddress)
            table.column(self.latitude)
            table.column(self.longitude)
        }
        do {
            try self.database1.run(createAddressTable)
            print("Created address Table..")
        } catch {
            print(error)
        }
    }
    func createUserTable(){
        // TO CREATE TABLE OF USER IN SQLITE3:
        let createUserTable = self.userTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.userName)
            table.column(self.userEmail, unique: true)
            table.column(self.userPass)
            table.column(self.userContactNumber)
            table.column(self.genderOfUser)
            table.column(self.ImageOfUser)
        }
        do {
            try self.database.run(createUserTable)
            print("Created user Table..")
        } catch {
            print(error)
        }
    }
    
    
}
//MARK:- Extensions

extension SignUpVC: ImagePickerDelegate , UIImagePickerControllerDelegate{
    func didSelect(image : UIImage?) {
        self.imageView.image = image
        userImage = self.imageView.image
    }
    
} // end of extension

//confirm the delegate protocal
extension SignUpVC: LocationOfUserAddressDelegate {
    func setDelailLocationInAddress1(delailsAddress1: String, latitude: Double, longitude: Double) {
        switch noOfAddress{
        case 1:
            firstAddress =  DetailsAddressFromMap(fullAddress: delailsAddress1 , latitude: latitude , longitude: longitude, userEmail: self.email )
            print("detaillAddress2:\(String(describing: delailsAddress1))")
            addressOfUserTxtField.text = delailsAddress1
            saveAddressesInSQLite(delailsAddress1,self.email, latitude, longitude)
            self.arrOfAddresses.append(firstAddress!)
            print("table of address:\(String(describing: saveAddressesInSQLite))")
            
        case 2:
            secondAddress = DetailsAddressFromMap(fullAddress: delailsAddress1 , latitude: latitude , longitude: longitude, userEmail: self.email )
            print("detaillAddress2:\(String(describing: secondAddress))")
            address2OfUserTxtField.text = delailsAddress1
            saveAddressesInSQLite(delailsAddress1,self.email, latitude, longitude)
            self.arrOfAddresses.append(secondAddress!)
            
        case 3:
            thirdAddress = DetailsAddressFromMap(fullAddress: delailsAddress1 , latitude: latitude , longitude: longitude, userEmail: self.email )
            print("detaillAddress3:\(String(describing: thirdAddress))")
            address3OfUserTxtField.text = delailsAddress1
            saveAddressesInSQLite(delailsAddress1,self.email, latitude, longitude)
            self.arrOfAddresses.append(thirdAddress!)
            
        default:
            break
        }
        
    }
}
