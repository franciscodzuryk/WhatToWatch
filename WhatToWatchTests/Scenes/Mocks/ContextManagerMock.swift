//
//  PersistenceManagerMock.swift
//  WhatToWatchTests
//
//  Created by Fran on 07/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import UIKit
import CoreData
/*
class ContextManagerMock : ContextManagerInterface {
    func getContextManager() -> ContextManager {
        return contextManager
    }
    
    var contextManager: ContextManager!
    
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
    
    init() {
        let container = NSPersistentContainer(name: "WhatToWhatchModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = container.persistentStoreCoordinator
        contextManager = ContextManager(testSotreCoordinator: container, testContext: context)
    }
    
    func cleanAllData() {
        
    }
    
    func saveConfiguration(apiConf: APIConfiguration) {
        saveConfigurationCount += 1
    }
    
    func getConfiguration() -> NSManagedObject? {
        getConfigurationCount += 1
        
        if returnConfiguration {
            let entity = NSEntityDescription.entity(forEntityName: "APIConfigurationModel", in: contextManager.managedObjectContext)
            let apiConfiguration = NSManagedObject(entity: entity!, insertInto: contextManager.managedObjectContext)
            apiConfiguration.setValue(1, forKeyPath: "popularMoviesPage")
            apiConfiguration.setValue(1, forKeyPath: "upcomingPageCounter")
            apiConfiguration.setValue(1, forKeyPath: "topRatedPageCounter")
            return apiConfiguration
        } else {
            return nil
        }
    }
    
    func saveImageForMovieId(_ id:Int, image:UIImage, type:ImageType) {
        saveImageForMovieIdCount += 1
    }
    
    func saveMovies(movies: [Movie], onModel: MoviesPersistenModel) {
        saveMoviesCount += 1
    }
    
    func movieWasAdded(id: Int, onModel: MoviesPersistenModel) -> Bool {
        return true
    }
    
    func getMovies(fromModel model: MoviesPersistenModel) -> [NSManagedObject] {
        getMoviesCount += 1
        if returnGetMovies {
            return getMockMoviesArray()
        } else {
            return [NSManagedObject]()
        }
    }
    
    func updateConfigurationPage(page: Int, forMovieModel: MoviesPersistenModel) {
        updateConfigurationPageMoviesCount += 1
    }
    
    func updateConfigurationPage(page: Int, forShowModel: ShowsPersistenModel) {
        updateConfigurationPageShowsCount += 1
    }
    
    func saveShows(shows: [Show], onModel: ShowsPersistenModel) {
        saveShowsCount += 1
    }
    
    func showWasAdded(id: Int, onModel: ShowsPersistenModel) -> Bool {
        return true
    }
    
    func getShows(fromModel model: ShowsPersistenModel) -> [NSManagedObject] {
        getShowsCount += 1
        if returnGetShows {
            return getMockShowsArray()
        } else {
            return [NSManagedObject]()
        }
    }
    
    func saveImageForShowId(_ id: Int, image: UIImage, type: ImageType) {
        saveImageForShowIdCount += 1
    }
    
    private func getMockMoviesArray() -> [NSManagedObject] {
        let entity = NSEntityDescription.entity(forEntityName: "MoviePopularModel", in: contextManager.managedObjectContext)
        let movieModel = NSManagedObject(entity: entity!, insertInto: contextManager.managedObjectContext)
        movieModel.setValue(1, forKeyPath: "id")
        movieModel.setValue("movie.title", forKeyPath: "title")
        movieModel.setValue(false, forKeyPath: "adult")
        movieModel.setValue("backdropImage.jpg", forKeyPath: "backdropPathString")
        movieModel.setValue("movie.overview", forKeyPath: "overview")
        movieModel.setValue(3.3, forKeyPath: "popularity")
        movieModel.setValue("posterImage.jpg", forKeyPath: "posterPath")
        movieModel.setValue("2018-11-22", forKeyPath: "releaseDate")
        movieModel.setValue(3.3, forKeyPath: "voteAverage")
        movieModel.setValue(11, forKeyPath: "voteCount")
        movieModel.setValue("movie.originalTitle", forKeyPath: "originalTitle")
        movieModel.setValue("en-US", forKeyPath: "originalLanguage")
        
        return [movieModel]
    }
    
    private func getMockShowsArray() -> [NSManagedObject] {
        let entity = NSEntityDescription.entity(forEntityName: "MoviePopularModel", in: contextManager.managedObjectContext)
        let movieModel = NSManagedObject(entity: entity!, insertInto: contextManager.managedObjectContext)
        movieModel.setValue(1, forKeyPath: "id")
        movieModel.setValue("movie.title", forKeyPath: "name")
        movieModel.setValue("backdropImage.jpg", forKeyPath: "backdropPath")
        movieModel.setValue("movie.overview", forKeyPath: "overview")
        movieModel.setValue(3.3, forKeyPath: "popularity")
        movieModel.setValue("posterImage.jpg", forKeyPath: "posterPath")
        movieModel.setValue(3.3, forKeyPath: "voteAverage")
        movieModel.setValue(11, forKeyPath: "voteCount")
        movieModel.setValue("movie.originalTitle", forKeyPath: "originalName")
        movieModel.setValue("en-US", forKeyPath: "originalLanguage")
        
        return [movieModel]
    }
}
*/
