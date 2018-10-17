//
//  ShowsCtrler.swift
//  WhatToWatch
//
//  Created by Fran on 03/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//


import UIKit
import CoreData

class ShowsCtrler {
    private weak var view: ShowsVCDelegate!
    private var popularPageCounter: Int
    private var onTheAirPageCounter: Int
    private var topRatedPageCounter: Int
    private var apiConfiguration: APIConfiguration?
    private let contextManager: ContextManagerInterface
    private let apiClient: APIClientInterface
    private var selectedModel = ShowsPersistenModel.popular
    var loading = false
    
    init(_ view: ShowsVCDelegate, contextManager: ContextManagerInterface, apiClient: APIClientInterface) {
        self.view = view
        self.contextManager = contextManager
        self.apiClient = apiClient
        self.popularPageCounter = 1
        self.onTheAirPageCounter = 1
        self.topRatedPageCounter = 1
        //THIS MUST BE DONE ON THE SPLASH SCREEN
        if let config = contextManager.getConfigurationModel() {
            self.popularPageCounter = (config.value(forKey:"popularShowsPage") as! Int)
            self.onTheAirPageCounter = (config.value(forKey:"onTheAirShowPage") as! Int)
            self.topRatedPageCounter = (config.value(forKey:"topRatedShowPage") as! Int)
        }
        //THIS MUST BE DONE ON THE SPLASH SCREEN
    }
    
    func loadShows(forModel model: ShowsPersistenModel) {
        selectedModel = model
        let shows = contextManager.getShows(fromModel:model).map { ShowsVM(showModel: $0 )}
        if shows.count > 0 {
            view.updateShows(shows: shows)
        } else {
            view.updateShows(shows: [ShowsVM]())
            loadNextPageShows()
        }
    }
    
    func loadNextPageShows() {
        switch selectedModel {
            case .popular:
                fetchPopularShows()
            case .onTheAir:
                fetchOnTheAirShows()
            case .topRated:
                fetchTopRatedShows()
        }
    }
    
    func fetchPopularShows() {
        if !loading {
            loading = true
            apiClient.getPopularShows(page: self.popularPageCounter, success: { [weak self] (shows: [Show]) in
                self?.loading = false
                self?.popularPageCounter += 1
                self?.contextManager.updateConfigurationPage(page: (self?.popularPageCounter)!, forShowModel:.popular)
                self?.contextManager.saveShows(shows: shows, onModel:.popular)
                let showsVM = self?.contextManager.getShows(fromModel:.popular).map { ShowsVM(showModel: $0 )}
                DispatchQueue.main.async { [weak self] in
                    self?.view.updateShows(shows:showsVM!)
                }
            }) { [weak self] (error: Error) in
                self?.loading = false
                DispatchQueue.main.async { [weak self] in
                    self?.view.networkError(error: error)
                }
            }
        }
    }
    
    func fetchOnTheAirShows() {
        if !loading {
            loading = true
            apiClient.getOnTheAirShows(page: self.onTheAirPageCounter, success: { [weak self] (shows: [Show]) in
                self?.loading = false
                self?.onTheAirPageCounter += 1
                self?.contextManager.updateConfigurationPage(page: (self?.onTheAirPageCounter)!, forShowModel:.onTheAir)
                self?.contextManager.saveShows(shows: shows, onModel:.onTheAir)
                let showsVM = self?.contextManager.getShows(fromModel:.onTheAir).map { ShowsVM(showModel: $0 )}
                DispatchQueue.main.async {
                    self?.view.updateShows(shows:showsVM!)
                }
            }) { [weak self] (error: Error) in
                self?.loading = false
                DispatchQueue.main.async { [weak self] in
                    self?.view.networkError(error: error)
                }
            }
        }
    }
    
    func fetchTopRatedShows() {
        if !loading {
            loading = true
            apiClient.getTopRatedShows(page: self.topRatedPageCounter, success: { [weak self] (shows: [Show]) in
                self?.loading = false
                self?.topRatedPageCounter += 1
                self?.contextManager.updateConfigurationPage(page: (self?.topRatedPageCounter)!, forShowModel:.topRated)
                self?.contextManager.saveShows(shows: shows, onModel:.topRated)
                let showsVM = self?.contextManager.getShows(fromModel:.topRated).map { ShowsVM(showModel: $0 )}
                DispatchQueue.main.async { [weak self] in
                    self?.view.updateShows(shows:showsVM!)
                }
            }) { [weak self] (error: Error) in
                self?.loading = false
                DispatchQueue.main.async { [weak self] in
                    self?.view.networkError(error: error)
                }
            }
        }
    }
    
    func getImageForShow(show: ShowsVM, indexPath: IndexPath) {
        if let urlImage = show.posterPath {
            apiClient.getImage("https://image.tmdb.org/t/p/w185/" + urlImage, success: { [weak self] (image: UIImage) in
                self?.contextManager.saveImageForShowId(show.id, image:image, type:.posterImage)
                self?.view.updateImage(image: image, indexPath: indexPath)
            }) { [weak self] (error: Error) in
                self?.loading = false
                DispatchQueue.main.async { [weak self] in
                    self?.view.networkError(error: error)
                }
            }
        }
    }
    
    
}
