//
//  MovieDetailCtrler.swift
//  WhatToWatch
//
//  Created by Fran on 06/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import UIKit
import CoreData

class MovieDetailCtrler {
    private weak var view: MoviesDetailVCDelegate!
    private var apiConfiguration: APIConfiguration?
    private let persistenceManager: PersistenceManagerInterface
    private let apiClient: APIClientInterface
    
    init(_ view: MoviesDetailVCDelegate, persistenceManager: PersistenceManagerInterface, apiClient: APIClientInterface) {
        self.view = view
        self.persistenceManager = persistenceManager
        self.apiClient = apiClient
    }

    func getVideos(forMovie movie:MoviesVM) {
        weak var weakSelf = self
        apiClient.getVideosMovie(movieId: movie.id, success: {
            (videos: [VideoMovie]) in
            if let video = videos.first {
                weakSelf?.view.loadVideo(videoId: video.key)
            }
        }) { (error: Error) in
            print(error)
        }
    }
    
    func getImageForMovie(movie: MoviesVM) {
        weak var weakself = self
        if let urlImage = movie.backdropPathString {
            apiClient.getImage(urlImage, success: { (image: UIImage) in
                weakself!.persistenceManager.saveImageForMovieId(movie.id, image:image, type:.backdropImage)
                weakself!.view.updateImage(image: image)
            }) { (error:Error) in
                
            }
        }
    }
}

