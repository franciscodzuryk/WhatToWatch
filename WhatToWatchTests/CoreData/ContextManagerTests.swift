//
//  PersistenceManagerTests.swift
//  WhatToWatchTests
//
//  Created by Fran on 06/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import XCTest
import CoreData

class ContextManagerTests: XCTestCase {
    var contextManager: ContextManager?
    var apiConfiguration: APIConfiguration?
    var movies = [Movie]()

    override func setUp() {
        let container = NSPersistentContainer(name: "WhatToWhatchModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = container.persistentStoreCoordinator
        contextManager = ContextManager(testSotreCoordinator: container, testContext: context)
        contextManager?.cleanConfigurationModel()
        contextManager?.cleanMovieModel()
        contextManager?.cleanShowModel()
        
        if let pathConfig = Bundle(for: SearchInteractorTest.self).path(forResource: "APIConfiguration", ofType: "json")
        {
            do {
                let json = try Data(contentsOf: URL(fileURLWithPath: pathConfig), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                apiConfiguration = try decoder.decode(APIConfiguration.self, from: json)
            } catch {
                // handle error
            }
        }
        if let pathMovies = Bundle(for: SearchInteractorTest.self).path(forResource: "Movies", ofType: "json")
        {
            do {
                let json = try Data(contentsOf: URL(fileURLWithPath: pathMovies), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                let movieResponse = try decoder.decode(MovieResult.self, from: json)
                movies = movieResponse.results
            } catch {
                // handle error
            }
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSaveAndGetConfiguration() {
        contextManager!.saveConfiguration(apiConf: apiConfiguration!)
        let savedConf = contextManager!.getConfigurationModel()
        XCTAssert(savedConf != nil)
    }
    
    func testUpdateConfigurationPage() {
        contextManager!.saveConfiguration(apiConf: apiConfiguration!)
        contextManager!.updateConfigurationPage(page: 2, forMovieModel:.popular )
        contextManager!.updateConfigurationPage(page: 2, forMovieModel:.upcoming)
        contextManager!.updateConfigurationPage(page: 2, forMovieModel:.topRated)
        let savedConf = contextManager!.getConfigurationModel()!
        
        let popularPageCounter = (savedConf.value(forKey:"popularMoviesPage") as! Int)
        let upcomingPageCounter = (savedConf.value(forKey:"upcomingPageCounter") as! Int)
        let topRatedPageCounter = (savedConf.value(forKey:"topRatedPageCounter") as! Int)
        
        XCTAssert(popularPageCounter == 2)
        XCTAssert(upcomingPageCounter == 2)
        XCTAssert(topRatedPageCounter == 2)
    }
    
    func testSaveCheckAndGetMovie() {
        contextManager!.saveMovies(movies: movies, onModel: .popular)
        contextManager!.saveMovies(movies: movies, onModel: .upcoming)
        contextManager!.saveMovies(movies: movies, onModel: .topRated)
        let savedPopular = contextManager!.getMovies(fromModel: .popular)
        let savedUpcoming = contextManager!.getMovies(fromModel: .upcoming)
        let savedTopRated = contextManager!.getMovies(fromModel: .topRated)
        
        XCTAssert(savedPopular.count == 20)
        XCTAssert(savedUpcoming.count == 20)
        XCTAssert(savedTopRated.count == 20)
        
        XCTAssertNotNil(contextManager!.getMovieById(id: 559, fromModel: .popular))
        XCTAssertNotNil(contextManager!.getMovieById(id: 324857, fromModel: .upcoming))
        XCTAssertNotNil(contextManager!.getMovieById(id: 166822, fromModel: .topRated))
    }
    
    func testCleanAllData() {
        contextManager!.saveConfiguration(apiConf: apiConfiguration!)
        contextManager!.saveMovies(movies: movies, onModel: .popular)
        contextManager!.saveMovies(movies: movies, onModel: .upcoming)
        contextManager!.saveMovies(movies: movies, onModel: .topRated)

        contextManager!.cleanConfigurationModel()
        contextManager!.cleanMovieModel()
        contextManager!.cleanShowModel()
        
        let savedConf = contextManager!.getConfigurationModel()
        let savedPopular = contextManager!.getMovies(fromModel: .popular)
        let savedUpcoming = contextManager!.getMovies(fromModel: .upcoming)
        let savedTopRated = contextManager!.getMovies(fromModel: .topRated)
        
        XCTAssert(savedConf == nil)
        XCTAssert(savedPopular.count == 0)
        XCTAssert(savedUpcoming.count == 0)
        XCTAssert(savedTopRated.count == 0)
    }
    
    func testSavePosterImageForMovieId() {
        contextManager!.saveMovies(movies: movies, onModel: .popular)
        contextManager!.saveMovies(movies: movies, onModel: .upcoming)
        contextManager!.saveMovies(movies: movies, onModel: .topRated)
        
        let image = UIImage(named: "empty_poster")
        contextManager!.saveImageForMovieId(55825, image: image!, type:.posterImage)
        
        let savedPopular = contextManager!.getMovies(fromModel: .popular)
        let savedUpcoming = contextManager!.getMovies(fromModel: .upcoming)
        let savedTopRated = contextManager!.getMovies(fromModel: .topRated)
        
        if let movie = savedPopular.first(where: {($0.value(forKey:"id") as! Int) == 55825}) {
            XCTAssert(movie.value(forKey:"posterImage") != nil)
        } else {
            XCTAssert(true)
        }
        
        if let movie = savedUpcoming.first(where: {($0.value(forKey:"id") as! Int) == 55825}) {
            XCTAssert(movie.value(forKey:"posterImage") != nil)
        } else {
            XCTAssert(true)
        }
        
        if let movie = savedTopRated.first(where: {($0.value(forKey:"id") as! Int) == 55825}) {
            XCTAssert(movie.value(forKey:"posterImage") != nil)
        } else {
            XCTAssert(true)
        }
    }
}
