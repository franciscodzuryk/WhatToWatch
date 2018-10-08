//
//  MovieDetailVC.swift
//  WhatToWatch
//
//  Created by Fran on 06/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import UIKit
import AVFoundation
import youtube_ios_player_helper_swift

class MovieDetailVC: UIViewController, MoviesDetailVCDelegate {
    
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblVoteAvarage: UILabel!
    @IBOutlet weak var lblVoteCount: UILabel!
    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var loadingMovieIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btnPlayPause: UIButton!
    
    private var ctrler: MovieDetailCtrler!
    var movie: MoviesVM?

    override func viewDidLoad() {
        super.viewDidLoad()
        ctrler = MovieDetailCtrler(self, persistenceManager: PersistenceManager(), apiClient: APIClient())
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
        let alert = UIAlertController(title: "Network Error", message: error.localizedDescription, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "OK", style:.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
 
     func loadVideo(videoId:String) {
        let playerVars:[String: Any] = [
            "controls" : "0",
            "showinfo" : "0",
            "autoplay": "0",
            "rel": "0",
            "modestbranding": "0",
            "iv_load_policy" : "3",
            "fs": "0",
            "playsinline" : "1"
        ]
        playerView.delegate = self
        _ = playerView.load(videoId: videoId, playerVars: playerVars)
        playerView.isUserInteractionEnabled = false
        //updateTime()
    }
    
    func updateImage(image:UIImage) {
        imgMovie.image = image
    }
    
    @IBAction func playPause(_ sender: Any) {
        if playerView.playerState == .playing {
            playerView.pauseVideo()
            btnPlayPause.backgroundColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 0.5104880137)
            btnPlayPause.setImage(UIImage(named:"play_icon"), for:.normal)
        } else {
            playerView.playVideo()
            btnPlayPause.backgroundColor = UIColor.clear
            btnPlayPause.setImage(nil, for:.normal)
        }
    }
    
}

extension MovieDetailVC: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView){
        loadingMovieIndicator.stopAnimating()
        btnPlayPause.backgroundColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 0.5104880137)
        btnPlayPause.setImage(UIImage(named:"play_icon"), for:.normal)
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState){

    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo quality: YTPlaybackQuality){

    }
    
    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
        print(error)
    }
    
    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float){

    }
    
    func playerViewPreferredWebViewBackgroundColor(_ playerView: YTPlayerView) -> UIColor{
        return UIColor.black
    }
    
    func playerViewPreferredInitialLoadingView(_ playerView: YTPlayerView) -> UIView?{
        return UIImageView(image:UIImage(named:"video_not_found"))
    }
}
