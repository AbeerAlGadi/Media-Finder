//
//  MediaCell.swift
//  Media Finder
//
//  Created by AbeerSharaf on 6/9/20.
//  Copyright © 2020 Abeer. All rights reserved.
//

import UIKit

class MediaCell: UITableViewCell {
    @IBOutlet weak var imagOfUrlView: UIImageView!
    @IBOutlet weak var artistNameOrTrackNameLabel: UILabel!
    @IBOutlet weak var longDecreptionTextView: UITextView!
    @IBOutlet weak var likeImgeView: UIImageView!
    @IBOutlet weak var likeImgView: UIImageView!
    
    var isClicked = false
    var mediaType = ""
    var media: Media?
    var arrOfartitsUrl = [String]()
    var arrOfTrackUrl = [String]()
    
    var indexPathFMusic = [Int]()
    var indexPathFMovie = [Int]()
    var indexPathFTvShow = [Int]()
    
    // var arrOfMedia = [Media]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code\
    }
    
    @IBAction func myFavorateBtnPressed(_ sender: UIButton) {
    }
    @IBAction func artistUrlBtnPressed(_ sender: UIButton) {
        if mediaType == "movie" {
            guard let url = URL(string: media?.trackViewUrl ?? "") else { return }
            UIApplication.shared.open(url)
            print("track pressed")
        }else {
            guard let url = URL(string: media?.artistViewUrl ?? "") else { return }
            UIApplication.shared.open(url)
            print("artist pressed")
        }
    }
    
    @IBAction func trackUrlBtnPressed(_ sender: UIButton) {
        guard let url = URL(string: media?.trackViewUrl ?? "") else { return }
        UIApplication.shared.open(url)
        print("track pressed")
    }
    
    @IBAction func flipImagBtnPressed(_ sender: UIButton) {
        print("image pressed")
        if isClicked {
            isClicked = false
            UIView.transition(with: self.imagOfUrlView, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }else {
            isClicked = true
            UIView.transition(with: self.imagOfUrlView, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func urlToImage(_ imageUrl1: String){
        let url = URL(string: imageUrl1)
        if let data = try? Data(contentsOf: url!)
        {
            let imageUrl: UIImage = UIImage(data: data)!
            self.imagOfUrlView.image = imageUrl
        }
    }
    override func prepareForReuse() {
        self.artistNameOrTrackNameLabel.text = ""
        self.longDecreptionTextView.text = "" 
    }
    
    func configureCell(segmaChoice: Media, typeOfMedia : String, indexPathOfRow: Int ){
        media = segmaChoice
        mediaType = typeOfMedia
        switch typeOfMedia{
        // MARK: -
        case MediaType.music.rawValue  : // music
            print("in case of cell \(typeOfMedia)")
            urlToImage(segmaChoice.imageUrl)
            self.artistNameOrTrackNameLabel.text = segmaChoice.artistName
            self.longDecreptionTextView.text =  segmaChoice.trackName
            
            
        case MediaType.movie.rawValue :
            print("in case of cell \(typeOfMedia)")
            urlToImage(segmaChoice.imageUrl)
            self.artistNameOrTrackNameLabel.text = segmaChoice.trackName
            self.longDecreptionTextView.text = segmaChoice.longDescription
            
        case MediaType.tvShow.rawValue :
            print("in case of cell \(typeOfMedia)")
            urlToImage(segmaChoice.imageUrl)
            self.artistNameOrTrackNameLabel.text = segmaChoice.artistName
            self.longDecreptionTextView.text = segmaChoice.longDescription
            
        case MediaType.myFavarote.rawValue :
            print("in case of cell \(typeOfMedia)")
            urlToImage(segmaChoice.imageUrl)
            self.longDecreptionTextView.text =  segmaChoice.trackName ?? segmaChoice.artistName
            self.artistNameOrTrackNameLabel.text = segmaChoice.artistName ??  segmaChoice.longDescription
        default:
            return
        }
    }
}
