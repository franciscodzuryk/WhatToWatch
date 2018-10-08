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
    private let persistenceManager: PersistenceManagerInterface
    private let apiClient: APIClientInterface
    private var selectedModel = ShowsPersistenModel.popular
    var loading = false
    
    init(_ view: ShowsVCDelegate, persistenceManager: PersistenceManagerInterface, apiClient: APIClientInterface) {
        self.view = view
        self.persistenceManager = persistenceManager
        self.apiClient = apiClient
        self.popularPageCounter = 1
        self.onTheAirPageCounter = 1
        self.topRatedPageCounter = 1
        //THIS MUST BE DONE ON THE SPLASH SCREEN
        if let config = persistenceManager.getConfiguration() {
            self.popularPageCounter = (config.value(forKey:"popularShowsPage") as! Int)
            self.onTheAirPageCounter = (config.value(forKey:"onTheAirShowPage") as! Int)
            self.topRatedPageCounter = (config.value(forKey:"topRatedShowPage") as! Int)
        }
        //THIS MUST BE DONE ON THE SPLASH SCREEN
    }
    
    func loadShows(forModel model: ShowsPersistenModel) {
        selectedModel = model
        let shows = persistenceManager.getShows(fromModel:model).map { ShowsVM(managedObject: $0 )}
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
            weak var weakSelf = self
            apiClient.getPopularShows(page: self.popularPageCounter, success: { (shows: [Show]) in
                weakSelf?.loading = false
                weakSelf?.popularPageCounter += 1
                weakSelf?.persistenceManager.updateConfigurationPage(page: (weakSelf?.popularPageCounter)!, forShowModel:.popular)
                weakSelf?.persistenceManager.saveShows(shows: shows, onModel:.popular)
                let showsVM = weakSelf?.persistenceManager.getShows(fromModel:.popular).map { ShowsVM(managedObject: $0 )}
                DispatchQueue.main.async {
                    weakSelf?.view.updateShows(shows:showsVM!)
                }
            }) { (error: Error) in
                weakSelf?.loading = false
                DispatchQueue.main.async {
                    weakSelf?.view.networkError(error: error)
                }
            }
        }
    }
    
    func fetchOnTheAirShows() {
        if !loading {
            loading = true
            weak var weakSelf = self
            apiClient.getOnTheAirShows(page: self.onTheAirPageCounter, success: { (shows: [Show]) in
                weakSelf?.loading = false
                weakSelf?.onTheAirPageCounter += 1
                weakSelf?.persistenceManager.updateConfigurationPage(page: (weakSelf?.onTheAirPageCounter)!, forShowModel:.onTheAir)
                weakSelf?.persistenceManager.saveShows(shows: shows, onModel:.onTheAir)
                let showsVM = weakSelf?.persistenceManager.getMovies(fromModel:.upcoming).map { ShowsVM(managedObject: $0 )}
                DispatchQueue.main.async {
                    weakSelf?.view.updateShows(shows:showsVM!)
                }
            }) { (error: Error) in
                weakSelf?.loading = false
                DispatchQueue.main.async {
                    weakSelf?.view.networkError(error: error)
                }
            }
        }
    }
    
    func fetchTopRatedShows() {
        if !loading {
            loading = true
            weak var weakSelf = self
            apiClient.getTopRatedShows(page: self.topRatedPageCounter, success: { (shows: [Show]) in
                weakSelf?.loading = false
                weakSelf?.topRatedPageCounter += 1
                weakSelf?.persistenceManager.updateConfigurationPage(page: (weakSelf?.topRatedPageCounter)!, forShowModel:.topRated)
                weakSelf?.persistenceManager.saveShows(shows: shows, onModel:.topRated)
                let showsVM = weakSelf?.persistenceManager.getShows(fromModel:.topRated).map { ShowsVM(managedObject: $0 )}
                DispatchQueue.main.async {
                    weakSelf?.view.updateShows(shows:showsVM!)
                }
            }) { (error: Error) in
                weakSelf?.loading = false
                DispatchQueue.main.async {
                    weakSelf?.view.networkError(error: error)
                }
            }
        }
    }
    
    func getImageForShow(show: ShowsVM, indexPath: IndexPath) {
        weak var weakself = self
        if let urlImage = show.posterPath {
            apiClient.getImage(urlImage, success: { (image: UIImage) in
                weakself!.persistenceManager.saveImageForShowId(show.id, image:image, type:.posterImage)
                weakself!.view.updateImage(image: image, indexPath: indexPath)
            }) { (error:Error) in
                
            }
        }
    }
    
    
}
