//
//  PersistenceManagerMock.swift
//  WhatToWatchTests
//
//  Created by Fran on 07/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import UIKit
import CoreData
@testable import WhatToWatch

class ContextManagerMock : ContextManagerInterface {
    func getContext() -> NSManagedObjectContext {
        return contextManager.getContext()
    }
    
    
    var saveConfigurationCount = 0
    var getConfigurationCount = 0
    var updateConfigurationPageMoviesCount = 0
    var updateConfigurationPageShowsCount = 0
    var saveMoviesCount = 0
    var getMoviesCount = 0
    var saveImageForMovieIdCount = 0
    var saveShowsCount = 0
    var getShowsCount = 0
    var saveImageForShowIdCount = 0
    
    var returnConfiguration = false
    var returnGetMovies = false
    var returnGetShows = false
    
    var contextManager: ContextManager!
    
    init() {
        let bnl = Bundle(for: AppDelegate.self)
        guard let modelURL = bnl.url(forResource: "WhatToWhatchModel", withExtension: "momd"),
            let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
            else {
                fatalError("Unable to located Core Data model")
        }
        
        let container = NSPersistentContainer(name: "WhatToWhatchModel", managedObjectModel: managedObjectModel)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = container.persistentStoreCoordinator
        contextManager = ContextManager(testSotreCoordinator: container, testContext: context)
    }
    
    func saveContext() {
        
    }   
    
    func cleanConfigurationModel() {
        
    }
    
    func saveConfiguration(apiConf: APIConfiguration) {
        saveConfigurationCount += 1
    }
    
    func getConfigurationModel() -> APIConfigurationModel? {
        getConfigurationCount += 1
        if returnConfiguration {
            let entity = NSEntityDescription.insertNewObject(forEntityName: "APIConfigurationModel", into: getContext()) as! APIConfigurationModel
            entity.popularMoviesPage = 1
            entity.upcomingPageCounter = 1
            entity.topRatedPageCounter = 1
            entity.popularShowsPage = 1
            entity.topRatedShowPage = 1
            entity.onTheAirShowPage = 1
            return entity
        } else {
            return nil
        }
    }
    
    func updateConfigurationPage(page: Int, forMovieModel model: MoviesPersistenModel) {
        updateConfigurationPageMoviesCount += 1
    }
    
    func updateConfigurationPage(page: Int, forShowModel model: ShowsPersistenModel) {
        
    }
    
    func cleanMovieModel() {
        
    }
    
    func saveMovies(movies: [Movie], onModel model: MoviesPersistenModel) {
        saveMoviesCount += 1
    }
    
    func getMovieById(id:Int, fromModel model: MoviesPersistenModel) -> MovieModel? {
        return nil
    }
    
    func getMovies(fromModel model:MoviesPersistenModel) -> [MovieModel] {
        getMoviesCount += 1
        if returnGetMovies {
            return getMockMoviesArray()
        } else {
            return []
        }
    }
    
    func saveImageForMovieId(_ id:Int, image:UIImage, type:ImageType) {
        saveImageForMovieIdCount += 1
    }
    
    func cleanShowModel() {
        
    }
    
    func saveShows(shows: [Show], onModel model: ShowsPersistenModel) {
        
    }
    
    func getShowById(id:Int, fromModel model: ShowsPersistenModel) -> ShowModel? {
        return nil
    }
    
    func getShows(fromModel model:ShowsPersistenModel) -> [ShowModel] {
        return []
    }
    
    func saveImageForShowId(_ id:Int, image:UIImage, type:ImageType) {
        
    }
    
    private func getMockMoviesArray() -> [MovieModel] {
        
        let movieModel = NSEntityDescription.insertNewObject(forEntityName: "MoviePopularModel", into: getContext()) as! MovieModel
        movieModel.id = Int32(1)
        movieModel.title = "movie.title"
        movieModel.adult = false
        movieModel.backdropPath = "movie.backdropPath"
        movieModel.overview = "movie.overview"
        movieModel.popularity = 3.3
        movieModel.posterPath = "movie.posterPath"
        movieModel.releaseDate = "2018-11-22"
        movieModel.voteAverage = 3.3
        movieModel.voteCount = Int32(11)
        movieModel.originalTitle = "movie.originalTitle"
        movieModel.originalLanguage = "en-US"
        
        return [movieModel]
    }
}
