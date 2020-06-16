//
//  MediaListVC1.swift
//  Media Finder
//
//  Created by AbeerSharaf on 6/8/20.
//  Copyright © 2020 Abeer. All rights reserved.
//

import UIKit
import Alamofire
import SQLite
import NVActivityIndicatorView

class MediaListVC1: UIViewController  {
    
    @IBOutlet weak var mediaTableView: UITableView!
    @IBOutlet weak var mediaSearchBar: UISearchBar!
    @IBOutlet weak var mediaSegment: UISegmentedControl!
    
    //MARK:- variables
    
    lazy var  filteredData = [Media]()
    var database : Connection!
    var arrOfMedia = [Media]()
    var favorateMedia : Media!
    var filtrerSearch : Media!
    var currentarrOfMedia = [Media]()
    var selectedSegmentIndex: Int = 0
    var typeOfMedia = MediaType.music
    var  loading : NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 70, height: 70), type: .ballRotateChase, color: UIColor.darkGray, padding: 2)
    
    
    //MARK:- Constants
    let mediaTable = Table("mediaTable")
    let mediaType = Expression<String>("mediaType")
    let trackName = Expression<String>("trackName")
    let imageUrl = Expression<String>("imageUrl")
    let longDescription = Expression<String>("longDescription")
    let artistName = Expression<String>("artistName")
    let artistViewUrl = Expression<String>("artistViewUrl")
    let trackViewUrl = Expression<String>("trackViewUrl")
    let userEmail = Expression<String>("userEmail")
    let cellIdentifier = "MediaCell"
    
    
    // MARK:- lifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(false, forKey: "UserisLogOut")
        // for data base configuration
        openDBTocreateFavorateMediaTable()
        createTable()
        //deleteData()
        loading.center = view.center
        view.addSubview(loading)
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "MEDIA LIST"
        mediaSearchBar.delegate = self
        mediaTableView.dataSource = self
        mediaTableView.delegate = self
        mediaTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        //MARK:- For save the last open list and open it
        openLastOpenList()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super .viewDidDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //MARK:- Methods
    
    //Function For open the last open list and open it
    func openLastOpenList() {
        let isOpenMusic = UserDefaults.standard.bool(forKey: MediaType.music.rawValue)
        let isOpenMovie = UserDefaults.standard.bool(forKey: MediaType.movie.rawValue)
        let isOpentvShow = UserDefaults.standard.bool(forKey: MediaType.tvShow.rawValue)
        let isOpenFavorate = UserDefaults.standard.bool(forKey: MediaType.myFavarote.rawValue)
        
        switch true {
        case isOpenMusic : typeOfMedia = MediaType(rawValue: MediaType.music.rawValue)!
        mediaSegment.selectedSegmentIndex = 0
            
        case isOpenMovie :  typeOfMedia = MediaType(rawValue: MediaType.movie.rawValue)!
        mediaSegment.selectedSegmentIndex = 1
            
        case isOpentvShow :  typeOfMedia = MediaType(rawValue: MediaType.tvShow.rawValue)!
        mediaSegment.selectedSegmentIndex = 2
            
        case isOpenFavorate :  typeOfMedia = MediaType(rawValue: MediaType.myFavarote.rawValue)!
        mediaSegment.selectedSegmentIndex = 3
            
        default:
             typeOfMedia = MediaType(rawValue: MediaType.music.rawValue)!
        }
        
        if typeOfMedia != MediaType.myFavarote {
            arrOfMedia = getMedia(term:"all", media:typeOfMedia.rawValue)
            mediaTableView.reloadData()
        } else {
            arrOfMedia = loadDataFromSqlite()
            mediaSearchBar.isHidden = true
            mediaTableView.reloadData()
        }
    }
    
    
    //MARK: - Methods For SQLITE
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // To Load from SQLITE for search media
    
    func loadDataFromSqlite() -> [Media] {
       // loading.startAnimating()
        arrOfMedia.removeAll()
        let defaults = UserDefaults.standard
        let userEmail1 = defaults.string(forKey: "SavedCurrentEmail")
        do{
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("mediaTable").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
           // loading.stopAnimating()
            self.database = database
            do{
                let favorateMedia = try self.database.prepare(self.mediaTable)
                print("arrOfMedia.count in sqlite\(arrOfMedia.count)")
                for media in favorateMedia {
                //  guard let email = media[userEmail] else {return}
                  if userEmail1 ==  media[userEmail] {
                    arrOfMedia.append(Media(trackName: media[trackName], imageUrl: media[imageUrl], longDescription: media[longDescription], artistName: media[artistName], artistViewUrl: media[artistViewUrl], trackViewUrl: media[trackViewUrl]))
                    print("loaded Data from Sqlite3\(media[trackName])" )
                  }
                }
                print("loaded Data from Sqlite3")
                loading.stopAnimating()

            }catch{
                print(error)
            }
        } catch {
            print(error)
        }
        return arrOfMedia
    }
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // For delete All data  from SQLITE
    func deleteData(){
        do{
            try database.run(mediaTable.delete())
        }catch{
            print(error)
        }
    }
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // For Save Data to SQLite
    func saveDataInSQLite(_ typeOfMedia : String, _ arrOfMedia: [Media]){
        for media in arrOfMedia {
            let defaults = UserDefaults.standard
            let userEmail1 = defaults.string(forKey: "SavedCurrentEmail")
            let insertFavorateMedia = self.mediaTable.insert(self.artistName <- media.artistName, self.artistViewUrl <- media.artistViewUrl  ?? "" , self.imageUrl <- media.imageUrl, self.longDescription <- media.longDescription ?? "" , self.trackName <- media.artistName, self.trackViewUrl <- media.trackViewUrl ?? "" ,self.mediaType <- typeOfMedia, self.userEmail <- userEmail1! )
            do{
                try self.database.run(insertFavorateMedia)
                print("Inserted media")
            }catch{
                print(error)
            }
        }
    }
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //open database
    func openDBTocreateFavorateMediaTable(){
        do{
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("mediaTable").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
    }
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // Create mediaTable
    func createTable(){
        // TO CREATE TABLE OF FAVORATE LISt IN SQLITE:
        let createFavorateMediaTable = self.mediaTable.create { (table) in
            table.column(self.artistName)
            table.column(self.artistViewUrl)
            table.column(self.imageUrl)
            table.column(self.longDescription)
            table.column(self.mediaType)
            table.column(self.trackName)
            table.column(self.trackViewUrl)
            table.column(self.userEmail, unique: true )
        }
        do {
            try self.database.run(createFavorateMediaTable)
            print("Created user Table..")
        } catch {
            print(error)
        }
    }
    // MARK:- GO TO Methods:
    func goToSignInScreen(){
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let sbSignIn = sb.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        self.navigationController?.viewControllers = [sbSignIn]
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func gotoProfile(){
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let sbUserDataTable = sb.instantiateViewController(withIdentifier: "UserDataTableVC") as! UserDataTableVC
        self.navigationController?.viewControllers = [sbUserDataTable]
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    //MARK:- API
    func getMedia(term: String, media: String)-> [Media] {
        loading.startAnimating()
        arrOfMedia.removeAll()
        APIManager.loadMedia(term, media) { (error, media) in
            self.loading.stopAnimating()
            if let error = error {
                print(error.localizedDescription)
            } else if let media = media {
                for media in media{
                    let mediaSup =  Media(trackName: media.trackName, imageUrl: media.imageUrl, longDescription: media.longDescription, artistName: media.artistName, artistViewUrl: media.artistViewUrl, trackViewUrl: media.trackViewUrl)
                    print("media catch \(media)")
                    self.arrOfMedia.append(mediaSup)
                    self.mediaTableView.reloadData()
                }
                print("self.arrOfMedia.count: \(self.arrOfMedia.count)")
            }
        }
        return arrOfMedia
    }
    
    //MARK:- Validate Medthods
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
    
    //MARK:- Actions
    @IBAction func backBtnBar(_ sender: UIBarButtonItem) {
        gotoProfile()
    }
    
    @IBAction func logOutBtnBar(_ sender: UIBarButtonItem) {
        checkLogout()
    }
    
    @IBAction func mediaSegmentControl(_ sender: UISegmentedControl) {
        
        mediaSearchBar.placeholder = sender.titleForSegment(at: 0)
        switch sender.selectedSegmentIndex {
        case 0:
            
            UserDefaults.standard.set(true, forKey: MediaType.music.rawValue)
            UserDefaults.standard.set(false, forKey:MediaType.movie.rawValue)
            UserDefaults.standard.set(false, forKey:MediaType.tvShow.rawValue)
            UserDefaults.standard.set(false, forKey:MediaType.myFavarote.rawValue)
            
            mediaSearchBar.isHidden = false
            mediaSearchBar.text = ""
            mediaSearchBar.placeholder = sender.titleForSegment(at: 0)
            self.typeOfMedia = MediaType(rawValue: MediaType.music.rawValue)!
            arrOfMedia = getMedia(term:"all", media:typeOfMedia.rawValue)
            
        case 1:
            UserDefaults.standard.set(false, forKey: MediaType.music.rawValue)
            UserDefaults.standard.set(true, forKey:  MediaType.movie.rawValue)
            UserDefaults.standard.set(false, forKey: MediaType.tvShow.rawValue)
            UserDefaults.standard.set(false, forKey: MediaType.myFavarote.rawValue)
            
            mediaSearchBar.isHidden = false
            mediaSearchBar.text = ""
            mediaSearchBar.placeholder = sender.titleForSegment(at: 1)
            self.typeOfMedia = MediaType(rawValue: MediaType.movie.rawValue)!
            arrOfMedia = getMedia(term:"all", media:typeOfMedia.rawValue)
            
        case 2:
            UserDefaults.standard.set(false, forKey: MediaType.music.rawValue)
            UserDefaults.standard.set(false, forKey: MediaType.movie.rawValue)
            UserDefaults.standard.set(true, forKey:  MediaType.tvShow.rawValue)
            UserDefaults.standard.set(false, forKey: MediaType.myFavarote.rawValue)
            
            mediaSearchBar.isHidden = false
            mediaSearchBar.text = ""
            mediaSearchBar.placeholder = sender.titleForSegment(at: 2)
            self.typeOfMedia = MediaType(rawValue: MediaType.tvShow.rawValue)!
            arrOfMedia = getMedia(term:"all", media:typeOfMedia.rawValue)
        case 3:
            
            UserDefaults.standard.set(false, forKey: MediaType.music.rawValue)
            UserDefaults.standard.set(false, forKey: MediaType.movie.rawValue)
            UserDefaults.standard.set(false, forKey: MediaType.tvShow.rawValue)
            UserDefaults.standard.set(true, forKey:  MediaType.myFavarote.rawValue)
            
            mediaSearchBar.isHidden = true
            print("in case of my favorate media")
            typeOfMedia = MediaType(rawValue: MediaType.myFavarote.rawValue)!
            arrOfMedia = loadDataFromSqlite()
            mediaTableView.reloadData()
        default: view.backgroundColor = .white
        }
        
    }
}
// MARK: - Table view data source
extension MediaListVC1 :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("filteredData count\(self.arrOfMedia.count)")
        return  self.arrOfMedia.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MediaCell else { return UITableViewCell()}
        cell.selectionStyle =  .none
        
        print("in cell \(typeOfMedia)")
        cell.configureCell(segmaChoice: self.arrOfMedia[indexPath.row], typeOfMedia: typeOfMedia.rawValue, indexPathOfRow: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //mediaTableView.rowHeight = UILabel.auto
        return 180
        
        
    }
}

//MARK:- Extensions

extension MediaListVC1: UISearchBarDelegate {
    func filterSearchResults(typeOfMedia: MediaType, searchText: String)-> [Media] {
        currentarrOfMedia = arrOfMedia
        print("arrOfMedia count : \(arrOfMedia.count)")
        print("currentarrOfMedia count : \(currentarrOfMedia.count)")
        print("filteredData count : \(filteredData.count)")
        guard !searchText.isEmpty else {
            self.arrOfMedia = getMedia(term: "all", media: typeOfMedia.rawValue.self)
            self.mediaTableView.reloadData()
            return arrOfMedia
        }
        print("in case of search \(typeOfMedia)")
        arrOfMedia = arrOfMedia.filter({ media -> Bool in
            (media.artistName.lowercased().contains(searchText.lowercased())) || (media.trackName.lowercased().contains(searchText.lowercased()))
        })
        print("currentarrOfMedia in search begin \(currentarrOfMedia.count)")
        print("arrOfMedia in search begin \(arrOfMedia.count)")
        self.mediaTableView.reloadData()
        return currentarrOfMedia
    }
   
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            guard let txtsearch = mediaSearchBar.text , !txtsearch.isEmpty || false else {return}
            saveDataInSQLite(typeOfMedia.rawValue, arrOfMedia)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        switch typeOfMedia {
        case MediaType.music : // music
            currentarrOfMedia = filterSearchResults(typeOfMedia: MediaType(rawValue: typeOfMedia.rawValue)!, searchText: searchText)
            print("arrOfMedia after filter:\(currentarrOfMedia.count)")
            
        case MediaType.movie :
            currentarrOfMedia = filterSearchResults(typeOfMedia: MediaType(rawValue: typeOfMedia.rawValue)!, searchText: searchText)

            print("in case of search \(typeOfMedia)")
        case MediaType.tvShow :
            currentarrOfMedia = filterSearchResults(typeOfMedia: MediaType(rawValue: typeOfMedia.rawValue)!, searchText: searchText)

            print("in case of search \(typeOfMedia)")
        default:
            return
        }
        
    }
    
}

