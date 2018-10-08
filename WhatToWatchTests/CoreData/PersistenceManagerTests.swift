//
//  PersistenceManagerTests.swift
//  WhatToWatchTests
//
//  Created by Fran on 06/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import XCTest
import CoreData

class PersistenceManagerTests: XCTestCase {
    var persistenceManager: PersistenceManager?
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
        contextManager = ContextManager(testSotreCoordinator: container)
        persistenceManager = PersistenceManager(testContextManager: contextManager!)
        persistenceManager!.cleanAllData()
        
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
        persistenceManager!.saveConfiguration(apiConf: apiConfiguration!)
        let savedConf = persistenceManager!.getConfiguration()
        XCTAssert(savedConf != nil)
    }
    
    func testUpdateConfigurationPage() {
        persistenceManager!.saveConfiguration(apiConf: apiConfiguration!)
        persistenceManager!.updateConfigurationPage(page: 2, forMovieModel:.popular )
        persistenceManager!.updateConfigurationPage(page: 2, forMovieModel:.upcoming)
        persistenceManager!.updateConfigurationPage(page: 2, forMovieModel:.topRated)
        let savedConf = persistenceManager!.getConfiguration()!
        
        let popularPageCounter = (savedConf.value(forKey:"popularMoviesPage") as! Int)
        let upcomingPageCounter = (savedConf.value(forKey:"upcomingPageCounter") as! Int)
        let topRatedPageCounter = (savedConf.value(forKey:"topRatedPageCounter") as! Int)
        
        XCTAssert(popularPageCounter == 2)
        XCTAssert(upcomingPageCounter == 2)
        XCTAssert(topRatedPageCounter == 2)
    }
    
    func testSaveCheckAndGetMovie() {
        persistenceManager!.saveMovies(movies: movies, onModel: .popular)
        persistenceManager!.saveMovies(movies: movies, onModel: .upcoming)
        persistenceManager!.saveMovies(movies: movies, onModel: .topRated)
        let savedPopular = persistenceManager!.getMovies(fromModel: .popular)
        let savedUpcoming = persistenceManager!.getMovies(fromModel: .upcoming)
        let savedTopRated = persistenceManager!.getMovies(fromModel: .topRated)
        
        XCTAssert(savedPopular.count == 20)
        XCTAssert(savedUpcoming.count == 20)
        XCTAssert(savedTopRated.count == 20)
        
        XCTAssert(persistenceManager!.movieWasAdded(id: 559, onModel: .popular))
        XCTAssert(persistenceManager!.movieWasAdded(id: 324857, onModel: .upcoming))
        XCTAssert(persistenceManager!.movieWasAdded(id: 166822, onModel: .topRated))
    }
    
    func testCleanAllData() {
        persistenceManager!.saveConfiguration(apiConf: apiConfiguration!)
        persistenceManager!.saveMovies(movies: movies, onModel: .popular)
        persistenceManager!.saveMovies(movies: movies, onModel: .upcoming)
        persistenceManager!.saveMovies(movies: movies, onModel: .topRated)

        persistenceManager!.cleanAllData()
        
        let savedConf = persistenceManager!.getConfiguration()
        let savedPopular = persistenceManager!.getMovies(fromModel: .popular)
        let savedUpcoming = persistenceManager!.getMovies(fromModel: .upcoming)
        let savedTopRated = persistenceManager!.getMovies(fromModel: .topRated)
        
        XCTAssert(savedConf == nil)
        XCTAssert(savedPopular.count == 0)
        XCTAssert(savedUpcoming.count == 0)
        XCTAssert(savedTopRated.count == 0)
    }
    
    func testSavePosterImageForMovieId() {
        persistenceManager!.saveMovies(movies: movies, onModel: .popular)
        persistenceManager!.saveMovies(movies: movies, onModel: .upcoming)
        persistenceManager!.saveMovies(movies: movies, onModel: .topRated)
        
        let image = UIImage(named: "empty_poster")
        persistenceManager!.saveImageForMovieId(55825, image: image!, type:.posterImage)
        
        let savedPopular = persistenceManager!.getMovies(fromModel: .popular)
        let savedUpcoming = persistenceManager!.getMovies(fromModel: .upcoming)
        let savedTopRated = persistenceManager!.getMovies(fromModel: .topRated)
        
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
