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
    
    func getContext()  -> NSManagedObjectContext {
        return NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
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
        return nil
    }
    
    func updateConfigurationPage(page: Int, forMovieModel model: MoviesPersistenModel) {
        
    }
    
    func updateConfigurationPage(page: Int, forShowModel model: ShowsPersistenModel) {
        
    }
    
    func cleanMovieModel() {
        
    }
    
    func saveMovies(movies: [Movie], onModel model: MoviesPersistenModel) {
        
    }
    
    func getMovieById(id:Int, fromModel model: MoviesPersistenModel) -> MovieModel? {
        return nil
    }
    
    func getMovies(fromModel model:MoviesPersistenModel) -> [MovieModel] {
        return []
    }
    
    func saveImageForMovieId(_ id:Int, image:UIImage, type:ImageType) {
        
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
}
