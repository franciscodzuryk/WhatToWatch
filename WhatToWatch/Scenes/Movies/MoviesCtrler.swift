//
//  MoviesCtrler.swift
//  WhatToWatch
//
//  Created by Fran on 03/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//


import UIKit
import CoreData

class MoviesCtrler {
    private weak var view: MoviesVCDelegate!
    private var popularPageCounter: Int
    private var upcomingPageCounter: Int
    private var topRatedPageCounter: Int
    private var apiConfiguration: APIConfiguration?
    private let contextManager: ContextManagerInterface
    private let apiClient: APIClientInterface
    private var selectedModel = MoviesPersistenModel.popular
    var loading = false
    
    init(_ view: MoviesVCDelegate, contextManager: ContextManagerInterface, apiClient: APIClientInterface) {
        self.view = view
        self.contextManager = contextManager
        self.apiClient = apiClient
        self.popularPageCounter = 1
        self.upcomingPageCounter = 1
        self.topRatedPageCounter = 1
        //THIS MUST BE DONE ON THE SPLASH SCREEN
        if let config = contextManager.getConfigurationModel() {
            self.popularPageCounter = Int(config.popularMoviesPage)
            self.upcomingPageCounter = Int(config.upcomingPageCounter)
            self.topRatedPageCounter = Int(config.topRatedPageCounter)
        } else {
            self.fetchAPIConfiguration()
        }
        //THIS MUST BE DONE ON THE SPLASH SCREEN
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadAllData(notification:)), name: Notification.Name("ReloadAllData"), object: nil)
    }
    @objc func reloadAllData(notification: Notification) {
        self.popularPageCounter = 1
        self.upcomingPageCounter = 1
        self.topRatedPageCounter = 1
        loadMovies(forModel: selectedModel)
    }
    
    //THIS MUST BE DONE ON THE SPLASH SCREEN
    func fetchAPIConfiguration() {
        apiClient.getAPIConfiguration(success: { [weak self] (apiConfig: APIConfiguration) in
            self?.contextManager.saveConfiguration(apiConf: apiConfig)
        }) { [weak self] (error: Error) in
            DispatchQueue.main.async { [weak self] in
                self?.view.networkError(error: error)
            }
        }
    }
    //THIS MUST BE DONE ON THE SPLASH SCREEN
    
    func loadMovies(forModel model: MoviesPersistenModel) {
        selectedModel = model
        let movies = contextManager.getMovies(fromModel:model).map { MoviesVM(movieModel: $0)}
        if movies.count > 0 {
            view.updateMovies(movies: movies)
        } else {
            view.updateMovies(movies: [MoviesVM]())
            loadNextPageMovies()
        }
    }
    
    func loadNextPageMovies() {
        switch selectedModel {
            case .popular:
                fetchPopularMovies()
            case .upcoming:
                fetchUpcomingMovies()
            case .topRated:
                fetchTopRatedMovies()
        }
    }
    
    func fetchPopularMovies() {
        if !loading {
            loading = true
            apiClient.getPopularMovies(page: self.popularPageCounter, success: { [weak self] (movies: [Movie]) in
                self?.loading = false
                self?.popularPageCounter += 1
                self?.contextManager.updateConfigurationPage(page: (self?.popularPageCounter)!, forMovieModel:.popular)
                self?.contextManager.saveMovies(movies: movies, onModel:.popular)
                let movies = self?.contextManager.getMovies(fromModel:.popular).map { MoviesVM(movieModel: $0 )}
                DispatchQueue.main.async { [weak self] in
                    self?.view.updateMovies(movies:movies!)
                }
            }) { [weak self] (error: Error) in
                DispatchQueue.main.async { [weak self] in
                    self?.view.networkError(error: error)
                }
            }
        }
    }
    
    func fetchUpcomingMovies() {
        if !loading {
            loading = true
            apiClient.getUpcomingMovies(page: self.upcomingPageCounter, success: { [weak self] (movies: [Movie]) in
                self?.loading = false
                self?.upcomingPageCounter += 1
                self?.contextManager.updateConfigurationPage(page: (self?.upcomingPageCounter)!, forMovieModel:.upcoming)
                self?.contextManager.saveMovies(movies: movies, onModel:.upcoming)
                let movies = self?.contextManager.getMovies(fromModel:.upcoming).map { MoviesVM(movieModel: $0 )}
                DispatchQueue.main.async { [weak self] in
                    self?.view.updateMovies(movies:movies!)
                }
            }) { [weak self] (error: Error) in
                DispatchQueue.main.async { [weak self] in
                    self?.view.networkError(error: error)
                }
            }
        }
    }
    
    func fetchTopRatedMovies() {
        if !loading {
            loading = true
            apiClient.getTopRatedMovies(page: self.topRatedPageCounter, success: { [weak self] (movies: [Movie]) in
                self?.loading = false
                self?.topRatedPageCounter += 1
                self?.contextManager.updateConfigurationPage(page: (self?.topRatedPageCounter)!, forMovieModel:.topRated)
                self?.contextManager.saveMovies(movies: movies, onModel:.topRated)
                let movies = self?.contextManager.getMovies(fromModel:.topRated).map { MoviesVM(movieModel: $0 )}
                DispatchQueue.main.async { [weak self] in
                    self?.view.updateMovies(movies:movies!)
                }
            }) { (error: Error) in
                DispatchQueue.main.async { [weak self] in
                    self?.view.networkError(error: error)
                }
            }
        }
    }
    
    func getImageForMovie(movie: MoviesVM, indexPath: IndexPath) {
        if let urlImage = movie.posterPath {
            apiClient.getImage("https://image.tmdb.org/t/p/w185/" + urlImage, success: { [weak self] (image: UIImage) in
                self?.contextManager.saveImageForMovieId(movie.id, image:image, type:.posterImage)
                self?.view.updateImage(image: image, indexPath: indexPath)
            }) { [weak self] (error: Error) in
                DispatchQueue.main.async { [weak self] in
                    self?.view.networkError(error: error)
                }
            }
        }
    }
}
