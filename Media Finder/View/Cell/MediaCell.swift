//
//  MediaCell.swift
//  Media Finder
//
//  Created by AbeerSharaf on 6/9/20.
//  Copyright © 2020 Abeer. All rights reserved.
//

import UIKit
import AVKit

class MediaCell: UITableViewCell {
    @IBOutlet weak var imagOfUrlView: UIImageView!
    @IBOutlet weak var artistNameOrTrackNameLabel: UILabel!
    @IBOutlet weak var longDecreptionTextView: UITextView!
    
    @IBOutlet weak var lineUIview: UIView!
    @IBOutlet weak var noDataLabel: UILabel!
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
            guard let url = URL(string: media?.previewUrl ?? "") else { return }
            UIApplication.shared.open(url)
            print("track pressed")
        }else {
            guard let url = URL(string: media?.artistViewUrl ?? "") else { return }
            UIApplication.shared.open(url)
            print("artist pressed")
        }
    }
    
    @IBAction func trackUrlBtnPressed(_ sender: UIButton) {
        let videoURL = URL(string: media?.previewUrl ?? "")
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        //playerViewController.frame = self.view.bounds
       // self.view.layer.addSublayer(playerViewController)
//       .present(playerViewController, animated: true)
        playerViewController.player!.play()
//        guard let url = URL(string: media?.previewUrl ?? "") else { return }
//        UIApplication.shared.open(url)
        print("track pressed")
    }
    
    @IBAction func flipImagBtnPressed(_ sender: UIButton) {
        let origin:CGPoint = self.imagOfUrlView.center
        let target:CGPoint = CGPoint (x: self.imagOfUrlView.center.x+5, y: self.imagOfUrlView.center.y+5)


       // let target:CGPoint = CGPointMake(self.imagOfUrlView.center.x, self.imagOfUrlView.center.y+100)
        let bounce = CABasicAnimation(keyPath: "position.x")
        bounce.duration = 0.3
        bounce.fromValue = origin.y
        bounce.toValue = target.y
        bounce.repeatCount = 2
        bounce.autoreverses = true
        self.imagOfUrlView.layer.add(bounce, forKey: "position")
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
        prepareForReuse()
        media = segmaChoice
        mediaType = typeOfMedia
        switch typeOfMedia{
        // MARK: -
        case MediaType.music.rawValue  : // music
            prepareForReuse()
            self.noDataLabel.isHidden = true
            print("in case of cell \(typeOfMedia)")
            urlToImage(segmaChoice.imageUrl)
            self.artistNameOrTrackNameLabel.text = segmaChoice.artistName
            self.longDecreptionTextView.text =  segmaChoice.trackName
            
            
        case MediaType.movie.rawValue :
            self.noDataLabel.isHidden = true
            print("in case of cell \(typeOfMedia)")
            urlToImage(segmaChoice.imageUrl)
            self.artistNameOrTrackNameLabel.text = segmaChoice.trackName
            self.longDecreptionTextView.text = segmaChoice.longDescription
            
        case MediaType.tvShow.rawValue :
            prepareForReuse()
            self.noDataLabel.isHidden = true
            print("in case of cell \(typeOfMedia)")
            urlToImage(segmaChoice.imageUrl)
            self.artistNameOrTrackNameLabel.text = segmaChoice.artistName
            self.longDecreptionTextView.text = segmaChoice.longDescription
            
        case MediaType.myFavarote.rawValue :
            prepareForReuse()
            print("in case of cell \(typeOfMedia)")
            if media != nil {
            self.noDataLabel.isHidden = true
            urlToImage(segmaChoice.imageUrl)
            self.longDecreptionTextView.text =  segmaChoice.trackName ?? segmaChoice.artistName
            self.artistNameOrTrackNameLabel.text = segmaChoice.artistName ??  segmaChoice.longDescription
            }else {
                self.noDataLabel.isHidden = false
            }
                
        default:
        return
        }
    }
    

}
