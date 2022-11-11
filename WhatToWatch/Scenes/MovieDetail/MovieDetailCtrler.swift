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
    private let contextManager: ContextManagerInterface
    private let apiClient: APIClientInterface
    
    init(_ view: MoviesDetailVCDelegate, contextManager: ContextManagerInterface, apiClient: APIClientInterface) {
        self.view = view
        self.contextManager = contextManager
        self.apiClient = apiClient
    }

    func getVideos(forMovie movie:MoviesVM) {
        apiClient.getVideosMovie(movieId: movie.id, success: { [weak self] (videos: [VideoMovie]) in
            if let video = videos.first {
                self?.view.loadVideo(videoId: video.key)
            }
        }) { [weak self] (error: Error) in
            DispatchQueue.main.async { [weak self] in
                self?.view.networkError(error: error)
            }
        }
    }
    
    func getImageForMovie(movie: MoviesVM) {
        if let urlImage = movie.backdropPathString {
            apiClient.getImage("https://image.tmdb.org/t/p/w300/" + urlImage, success: { [weak self] (image: UIImage) in
                self?.contextManager.saveImageForMovieId(movie.id, image:image, type:.backdropImage)
                self?.view.updateImage(image: image)
            }) { (error: Error) in
                print("getImageForMovie")
                print(error)
            }
        }
    }
}

