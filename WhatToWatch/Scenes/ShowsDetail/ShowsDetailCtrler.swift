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
    private let persistenceManager: PersistenceManagerInterface
    private let apiClient: APIClientInterface
    
    init(_ view: ShowsDetailVCDelegate, persistenceManager: PersistenceManagerInterface, apiClient: APIClientInterface) {
        self.view = view
        self.persistenceManager = persistenceManager
        self.apiClient = apiClient
    }

    func getVideos(forShow show:ShowsVM) {
        weak var weakSelf = self
        apiClient.getVideosShow(showId: show.id, success: {
            (videos: [VideoMovie]) in
            if let video = videos.first {
                weakSelf?.view.loadVideo(videoId: video.key)
            }
        }) { (error: Error) in
            print(error)
        }
    }
    
    func getImageForShow(show: ShowsVM) {
        weak var weakself = self
        if let urlImage = show.backdropPath {
            apiClient.getImage(urlImage, success: { (image: UIImage) in
                weakself!.persistenceManager.saveImageForShowId(show.id, image:image, type:.backdropImage)
                weakself!.view.updateImage(image: image)
            }) { (error:Error) in
                
            }
        }
    }
}

