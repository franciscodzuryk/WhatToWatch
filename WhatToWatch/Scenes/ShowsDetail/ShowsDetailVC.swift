//
//  ShowsDetailVC.swift
//  WhatToWatch
//
//  Created by Fran on 06/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import UIKit
import AVFoundation
import WebKit

class ShowsDetailVC: UIViewController, ShowsDetailVCDelegate {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblVoteAvarage: UILabel!
    @IBOutlet weak var lblVoteCount: UILabel!
    @IBOutlet weak var imgShow: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var videoWebView: WKWebView!
    
    private var ctrler: ShowsDetailCtrler!
    var show: ShowsVM?

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        ctrler = ShowsDetailCtrler(self, contextManager: appDelegate.contextManager, apiClient: APIClient())
        ctrler.getVideos(forShow: show!)
        if let image = show!.backdropImage {
            imgShow.image = image
        } else {
            ctrler.getImageForShow(show: show!)
        }
        setUpViews()
    }
    
    func setUpViews(){
        lblTitle.text = show?.name
        lblVoteCount.text = "\(show?.voteCount ?? 0)"
        lblVoteAvarage.text = String(format:"%.1f", show?.voteAverage ?? 0.0)
        imgShow.image = show?.backdropImage ?? #imageLiteral(resourceName: "details_placeholder")
        lblDescription.text = show?.overview ?? ""
    }
    
    func networkError(error:Error) {
        DialogViewController.dialogWithTitle(title: "Network Error", message: error.localizedDescription, cancelTitle: "Ok").show()
    }
    
    func updateImage(image:UIImage) {
        imgShow.image = image
    }
    
    func loadVideo(videoId: String) {
        let myURL = URL(string: "https://www.youtube.com/embed/\(videoId)")
        videoWebView.load(URLRequest(url: myURL!))
    }
}
