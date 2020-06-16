//
//  UserDataTableVC.swift
//  Media Finder
//
//  Created by AbeerSharaf on 6/2/20.
//  Copyright © 2020 Abeer. All rights reserved.
//

import UIKit
import SQLite

class UserDataTableVC: UITableViewController {
    @IBOutlet weak var dataTableViewShow: UITableView!
    //MARK:- varibles
    
    var detailsAddressFromMap = [DetailsAddressFromMap]()
    var userReg: User!
    var database : Connection!
    var database1 : Connection!
    
    //MARK:- Constants
    lazy var section1 = 0
    let cellIdentifier = "DataCell"
    let cellIdentifier1 = "AddressCell"
    let userTable = Table("users")
    let userEmail = Expression<String>("userEmail")
    let userPass = Expression<String>("userPass")
    let userName = Expression<String>("userName")
    let userContactNumber = Expression<String>("userContactNumber")
    let genderOfUser = Expression<String>("genderOfUser")
    let ImageOfUser = Expression<Data>("ImageOfUser")
    let userAddressTable = Table("userAddress")
    let fullAddress = Expression<String>("fullAddress")
    let latitude = Expression<Double>("latitude")
    let longitude = Expression<Double>("longitude")
    
    //MARK:- LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Profile"
        self.navigationItem.backBarButtonItem?.isEnabled = true
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.popToRootViewController(animated: true)
        
        dataTableViewShow.delegate = self
        dataTableViewShow.dataSource = self
        dataTableViewShow.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        dataTableViewShow.register(UINib(nibName: cellIdentifier1, bundle: nil), forCellReuseIdentifier: cellIdentifier1)
        loadDataFromSqlite()
        loadAddressFromSqlite()
        dataTableViewShow.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super .viewDidDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    //MARK: -  Methods
    //********************************* Go Next Screens Functions *******************************************
    func goToMediaListVC() {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let sbUserDataTable = sb.instantiateViewController(withIdentifier: "MediaListVC1") as! MediaListVC1
        self.navigationController?.viewControllers = [sbUserDataTable]
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    func goToUserDataTableVC(){
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let sbUserDataTable = sb.instantiateViewController(withIdentifier: "UserDataTableVC") as! UserDataTableVC
        self.navigationController?.viewControllers = [sbUserDataTable]
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func goToSignInScreen(){
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let sbSignIn = sb.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        self.navigationController?.viewControllers = [sbSignIn]
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //****************************** Loading Data In Different Storage type *********************************
    func loadDataFromSqlite(){
        do{
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            do{
                let users = try self.database.prepare(self.userTable)
                for user in users {
                    userReg = User(userImage:Image(imageData: user[ImageOfUser]), userFullName: user[userName], userPass: user[userPass], userEmail: user[userEmail], userContactNumber: user[userContactNumber], genderOfUser: user[genderOfUser])
                    
                    print("loaded Data from Sqlite3",user[userEmail] )
                }
                print("loaded Data from Sqlite3")
            }catch{
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    func loadAddressFromSqlite(){
        let defaults = UserDefaults.standard
        guard let currentEmail = defaults.string(forKey: "SavedCurrentEmail") else {return}
        print("in User defult: \(currentEmail)")
        do{
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("userAddress").appendingPathExtension("sqlite3")
            let database1 = try Connection(fileUrl.path)
            self.database1 = database1
            do{
                let addresses = try self.database1.prepare(self.userAddressTable)
                for address in addresses {
                    if currentEmail == address[userEmail]{
                        print("email true")
                        detailsAddressFromMap.append(DetailsAddressFromMap(fullAddress: address[fullAddress], latitude: address[latitude], longitude: address[longitude], userEmail: address[userEmail]))
                        print("loaded Data from addresses",address[userEmail] )
                    }
                }
            }catch{
                print(error)
            }
            
            
        } catch {
            print(error)
        }
    }
    
    
    //MARK:- Actions
    @IBAction func backBtnBar(_ sender: UIBarButtonItem) {
        goToMediaListVC()
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 4
        }
        else if section == 1 {
            print("detailsAddressFromMap: \(self.detailsAddressFromMap.count)")
            return detailsAddressFromMap.count
        }else{
            section1 = 1
            return 1
        }
    }
    func checkLogout(){
        let alertLogOut = UIAlertController(title:"Confirm", message: "Are you sure you want to log out ? ", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Yes", style:.default)
        { (UIAlertAction) in
            UserDefaults.standard.set(true, forKey:"UserisLogOut")
            UserDefaults.standard.synchronize()
            self.goToSignInScreen()
        }
        let noAlertAction = UIAlertAction(title: "No", style: .default,handler: nil)
        alertLogOut.addAction(alertAction)
        alertLogOut.addAction(noAlertAction)
        UserDefaults.standard.set(false, forKey: "UserisLogOut")
        self.present(alertLogOut, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            checkLogout()
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        _ = numberOfSections(in: dataTableViewShow)
      //  let returnCell = UITableViewCell()
        if indexPath.section == 0
        {   
            guard let returnCell = dataTableViewShow.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
                as? DataCell else {return UITableViewCell()}
            let index: Int = indexPath.row
            returnCell.configureCell(userData: self.userReg, index : index )
            return returnCell
        }
        else if indexPath.section == 1 {
            
            guard let returnCell = dataTableViewShow.dequeueReusableCell( withIdentifier: cellIdentifier1, for: indexPath)
                as? AddressCell else {return UITableViewCell()}
            let countOfAddress: Int = indexPath.row + 1
            print(countOfAddress)
            returnCell.configureCell(fullAddress: self.detailsAddressFromMap[indexPath.row],indexPathForAddress: countOfAddress)
            return returnCell
        }else {
            guard let returnCell = dataTableViewShow.dequeueReusableCell( withIdentifier: cellIdentifier, for: indexPath)
                as? DataCell else {return UITableViewCell()}
            let index: Int = 4
            returnCell.configureCell(userData: self.userReg, index : index )
            return returnCell
        }
       // return returnCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if  indexPath.section == 0 || indexPath.section == 2 {
            return 80
        } else {
            return 185
        }
    }
    
}
