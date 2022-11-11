//
//  MovieDetailCtrler.swift
//  WhatToWatch
//
//  Created by Fran on 06/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import UIKit
import CoreData

class ShowsDetailCtrler {
    private weak var view: ShowsDetailVCDelegate!
    private var apiConfiguration: APIConfiguration?
    private let contextManager: ContextManagerInterface
    private let apiClient: APIClientInterface
    
    init(_ view: ShowsDetailVCDelegate, contextManager: ContextManagerInterface, apiClient: APIClientInterface) {
        self.view = view
        self.contextManager = contextManager
        self.apiClient = apiClient
    }

    func getVideos(forShow show:ShowsVM) {
        apiClient.getVideosShow(showId: show.id, success: { [weak self] (videos: [VideoMovie]) in
            if let video = videos.first {
                self?.view.loadVideo(videoId: video.key)
            }
        }) { (error: Error) in
            print(error)
        }
    }
    
    func getImageForShow(show: ShowsVM) {
        if let urlImage = show.backdropPath {
            apiClient.getImage("https://image.tmdb.org/t/p/w300/" + urlImage, success: { [weak self] (image: UIImage) in
                self?.contextManager.saveImageForShowId(show.id, image:image, type:.backdropImage)
                self?.view.updateImage(image: image)
            }) { (error: Error) in
                print("getImageForShow")
                print(error)
            }
        }
    }
}

