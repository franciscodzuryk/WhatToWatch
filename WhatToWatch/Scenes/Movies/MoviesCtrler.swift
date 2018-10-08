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
    private let persistenceManager: PersistenceManagerInterface
    private let apiClient: APIClientInterface
    private var selectedModel = MoviesPersistenModel.popular
    var loading = false
    
    init(_ view: MoviesVCDelegate, persistenceManager: PersistenceManagerInterface, apiClient: APIClientInterface) {
        self.view = view
        self.persistenceManager = persistenceManager
        self.apiClient = apiClient
        self.popularPageCounter = 1
        self.upcomingPageCounter = 1
        self.topRatedPageCounter = 1
        //THIS MUST BE DONE ON THE SPLASH SCREEN
        if let config = persistenceManager.getConfiguration() {
            self.popularPageCounter = (config.value(forKey:"popularMoviesPage") as! Int)
            self.upcomingPageCounter = (config.value(forKey:"upcomingPageCounter") as! Int)
            self.topRatedPageCounter = (config.value(forKey:"topRatedPageCounter") as! Int)
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
        weak var weakSelf = self
        apiClient.getAPIConfiguration(success: { (apiConfig: APIConfiguration) in
            weakSelf?.persistenceManager.saveConfiguration(apiConf: apiConfig)
        }) { (error: Error) in
            DispatchQueue.main.async {
                self.view.networkError(error: error)
            }
        }
    }
    //THIS MUST BE DONE ON THE SPLASH SCREEN
    
    func loadMovies(forModel model: MoviesPersistenModel) {
        selectedModel = model
        let movies = persistenceManager.getMovies(fromModel:model).map { MoviesVM(managedObject: $0 )}
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
            weak var weakSelf = self
            apiClient.getPopularMovies(page: self.popularPageCounter, success: { (movies: [Movie]) in
                weakSelf?.loading = false
                weakSelf?.popularPageCounter += 1
                weakSelf?.persistenceManager.updateConfigurationPage(page: (weakSelf?.popularPageCounter)!, forMovieModel:.popular)
                weakSelf?.persistenceManager.saveMovies(movies: movies, onModel:.popular)
                let movies = weakSelf?.persistenceManager.getMovies(fromModel:.popular).map { MoviesVM(managedObject: $0 )}
                DispatchQueue.main.async {
                    weakSelf?.view.updateMovies(movies:movies!)
                }
            }) { (error: Error) in
                weakSelf?.loading = false
                DispatchQueue.main.async {
                    weakSelf?.view.networkError(error: error)
                }
            }
        }
    }
    
    func fetchUpcomingMovies() {
        if !loading {
            loading = true
            weak var weakSelf = self
            apiClient.getUpcomingMovies(page: self.upcomingPageCounter, success: { (movies: [Movie]) in
                weakSelf?.loading = false
                weakSelf?.upcomingPageCounter += 1
                weakSelf?.persistenceManager.updateConfigurationPage(page: (weakSelf?.upcomingPageCounter)!, forMovieModel:.upcoming)
                weakSelf?.persistenceManager.saveMovies(movies: movies, onModel:.upcoming)
                let movies = weakSelf?.persistenceManager.getMovies(fromModel:.upcoming).map { MoviesVM(managedObject: $0 )}
                DispatchQueue.main.async {
                    weakSelf?.view.updateMovies(movies:movies!)
                }
            }) { (error: Error) in
                weakSelf?.loading = false
                DispatchQueue.main.async {
                    weakSelf?.view.networkError(error: error)
                }
            }
        }
    }
    
    func fetchTopRatedMovies() {
        if !loading {
            loading = true
            weak var weakSelf = self
            apiClient.getTopRatedMovies(page: self.topRatedPageCounter, success: { (movies: [Movie]) in
                weakSelf?.loading = false
                weakSelf?.topRatedPageCounter += 1
                weakSelf?.persistenceManager.updateConfigurationPage(page: (weakSelf?.topRatedPageCounter)!, forMovieModel:.topRated)
                weakSelf?.persistenceManager.saveMovies(movies: movies, onModel:.topRated)
                let movies = weakSelf?.persistenceManager.getMovies(fromModel:.topRated).map { MoviesVM(managedObject: $0 )}
                DispatchQueue.main.async {
                    weakSelf?.view.updateMovies(movies:movies!)
                }
            }) { (error: Error) in
                weakSelf?.loading = false
                DispatchQueue.main.async {
                    weakSelf?.view.networkError(error: error)
                }
            }
        }
    }
    
    func getImageForMovie(movie: MoviesVM, indexPath: IndexPath) {
        weak var weakself = self
        if let urlImage = movie.posterPath {
            apiClient.getImage(urlImage, success: { (image: UIImage) in
                weakself!.persistenceManager.saveImageForMovieId(movie.id, image:image, type:.posterImage)
                weakself!.view.updateImage(image: image, indexPath: indexPath)
            }) { (error:Error) in
                
            }
        }
    }
    
    
}
