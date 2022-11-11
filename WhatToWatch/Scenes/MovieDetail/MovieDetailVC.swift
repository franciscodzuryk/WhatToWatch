//
//  MovieDetailVC.swift
//  WhatToWatch
//
//  Created by Fran on 06/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import UIKit
import AVFoundation
import WebKit

class MovieDetailVC: UIViewController, MoviesDetailVCDelegate {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblVoteAvarage: UILabel!
    @IBOutlet weak var lblVoteCount: UILabel!
    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var videoWebView: WKWebView!
    
    private var ctrler: MovieDetailCtrler!
    var movie: MoviesVM?

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        ctrler = MovieDetailCtrler(self, contextManager: appDelegate.contextManager, apiClient: APIClient())
        ctrler.getVideos(forMovie: movie!)
        if let image = movie!.backdropImage {
            imgMovie.image = image
        } else {
            ctrler.getImageForMovie(movie: movie!)
        }
        setUpViews()
    }
    
    func setUpViews(){
        lblTitle.text = movie?.title
        lblVoteCount.text = "\(movie?.voteCount ?? 0)"
        lblReleaseDate.text = movie?.releaseDate ?? ""
        lblVoteAvarage.text = String(format:"%.1f", movie?.voteAverage ?? 0.0)
        imgMovie.image = movie?.backdropImage ?? #imageLiteral(resourceName: "details_placeholder")
        lblDescription.text = movie?.overview ?? ""
    }
    
    func networkError(error:Error) {
        let dialog = DialogViewController.dialogWithTitle(title: "Network Error", message: error.localizedDescription, cancelTitle: "Ok")
        dialog.show()
    }
 
    func updateImage(image:UIImage) {
        imgMovie.image = image
    }
    
    func loadVideo(videoId: String) {
        let myURL = URL(string: "https://www.youtube.com/embed/\(videoId)")
        videoWebView.load(URLRequest(url: myURL!))
    }
}
