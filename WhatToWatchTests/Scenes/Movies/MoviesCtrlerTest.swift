//
//  MoviesCtrlerTest.swift
//  WhatToWatchTests
//
//  Created by Fran on 07/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import XCTest

class MoviesCtrlerTest: XCTestCase {
    let persistenceManager: PersistenceManagerInterface? = nil
    let apiClient: APIClientInterface? = nil

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInit() {
        let persistenceManager = PersistenceManagerMock()
        let apiClient = APIClientMock()
        _ = MoviesCtrler(MoviesViewMock(), persistenceManager: persistenceManager, apiClient: apiClient)
        XCTAssert(persistenceManager.getConfigurationCount == 1)
        XCTAssert(persistenceManager.saveConfigurationCount == 1)
        XCTAssert(apiClient.getConfigurationCallCount == 1)
    }
    
    func testInitWithConfig() {
        let persistenceManager = PersistenceManagerMock()
        persistenceManager.returnConfiguration = true
        let apiClient = APIClientMock()
        _ = MoviesCtrler(MoviesViewMock(), persistenceManager: persistenceManager, apiClient: apiClient)
        XCTAssert(persistenceManager.getConfigurationCount == 1)
        XCTAssert(persistenceManager.saveConfigurationCount == 0)
        XCTAssert(apiClient.getConfigurationCallCount == 0)
    }

    func testPopularLoadMoviesNoData() {
        let persistenceManager = PersistenceManagerMock()
        let apiClient = APIClientMock()
        let moviesView = MoviesViewMock()
        
        let ctrler = MoviesCtrler(moviesView, persistenceManager: persistenceManager, apiClient: apiClient)
        ctrler.loadMovies(forModel: .popular)
        
        XCTAssert(persistenceManager.getMoviesCount == 2)
        XCTAssert(persistenceManager.updateConfigurationPageMoviesCount == 1)
        XCTAssert(persistenceManager.saveMoviesCount == 1)
        XCTAssert(moviesView.updateMoviesCount == 1)
        XCTAssert(apiClient.getPopularMoviesCount == 1)
    }
    
    func testPopularLoadMovies() {
        let persistenceManager = PersistenceManagerMock()
        persistenceManager.returnGetMovies = true
        let apiClient = APIClientMock()
        let moviesView = MoviesViewMock()
        
        let ctrler = MoviesCtrler(moviesView, persistenceManager: persistenceManager, apiClient: apiClient)
        ctrler.loadMovies(forModel: .popular)
        
        XCTAssert(persistenceManager.getMoviesCount == 1)
        XCTAssert(persistenceManager.updateConfigurationPageMoviesCount == 0)
        XCTAssert(persistenceManager.saveMoviesCount == 0)
        XCTAssert(moviesView.updateMoviesCount == 1)
        XCTAssert(apiClient.getPopularMoviesCount == 0)
    }
    
    func testPopularLoadNextPageMovies() {
        let persistenceManager = PersistenceManagerMock()
        persistenceManager.returnGetMovies = true
        let apiClient = APIClientMock()
        let moviesView = MoviesViewMock()
        
        let ctrler = MoviesCtrler(moviesView, persistenceManager: persistenceManager, apiClient: apiClient)
        ctrler.loadMovies(forModel: .popular)
        ctrler.loadNextPageMovies()
        
        XCTAssert(persistenceManager.getMoviesCount == 2)
        XCTAssert(persistenceManager.updateConfigurationPageMoviesCount == 1)
        XCTAssert(persistenceManager.saveMoviesCount == 1)
        XCTAssert(moviesView.updateMoviesCount == 1)
        XCTAssert(apiClient.getPopularMoviesCount == 1)
    }
    
    func testUpcomingLoadMoviesNoData() {
        let persistenceManager = PersistenceManagerMock()
        let apiClient = APIClientMock()
        let moviesView = MoviesViewMock()
        
        let ctrler = MoviesCtrler(moviesView, persistenceManager: persistenceManager, apiClient: apiClient)
        ctrler.loadMovies(forModel: .upcoming)
        
        XCTAssert(persistenceManager.getMoviesCount == 2)
        XCTAssert(persistenceManager.updateConfigurationPageMoviesCount == 1)
        XCTAssert(persistenceManager.saveMoviesCount == 1)
        XCTAssert(moviesView.updateMoviesCount == 1)
        XCTAssert(apiClient.getUpcomingMoviesCount == 1)
    }
    
    func testUpcomingLoadMovies() {
        let persistenceManager = PersistenceManagerMock()
        persistenceManager.returnGetMovies = true
        let apiClient = APIClientMock()
        let moviesView = MoviesViewMock()
        
        let ctrler = MoviesCtrler(moviesView, persistenceManager: persistenceManager, apiClient: apiClient)
        ctrler.loadMovies(forModel: .upcoming)
        
        XCTAssert(persistenceManager.getMoviesCount == 1)
        XCTAssert(persistenceManager.updateConfigurationPageMoviesCount == 0)
        XCTAssert(persistenceManager.saveMoviesCount == 0)
        XCTAssert(moviesView.updateMoviesCount == 1)
        XCTAssert(apiClient.getUpcomingMoviesCount == 0)
    }
    
    func testUpcomingLoadNextPageMovies() {
        let persistenceManager = PersistenceManagerMock()
        persistenceManager.returnGetMovies = true
        let apiClient = APIClientMock()
        let moviesView = MoviesViewMock()
        
        let ctrler = MoviesCtrler(moviesView, persistenceManager: persistenceManager, apiClient: apiClient)
        ctrler.loadMovies(forModel: .upcoming)
        ctrler.loadNextPageMovies()
        
        XCTAssert(persistenceManager.getMoviesCount == 2)
        XCTAssert(persistenceManager.updateConfigurationPageMoviesCount == 1)
        XCTAssert(persistenceManager.saveMoviesCount == 1)
        XCTAssert(moviesView.updateMoviesCount == 1)
        XCTAssert(apiClient.getUpcomingMoviesCount == 1)
    }
    
    func testTopRatedLoadMoviesNoData() {
        let persistenceManager = PersistenceManagerMock()
        let apiClient = APIClientMock()
        let moviesView = MoviesViewMock()
        
        let ctrler = MoviesCtrler(moviesView, persistenceManager: persistenceManager, apiClient: apiClient)
        ctrler.loadMovies(forModel: .topRated)
        
        XCTAssert(persistenceManager.getMoviesCount == 2)
        XCTAssert(persistenceManager.updateConfigurationPageMoviesCount == 1)
        XCTAssert(persistenceManager.saveMoviesCount == 1)
        XCTAssert(moviesView.updateMoviesCount == 1)
        XCTAssert(apiClient.getTopRatedMoviesCount == 1)
    }
    
    func testTopRatedLoadMovies() {
        let persistenceManager = PersistenceManagerMock()
        persistenceManager.returnGetMovies = true
        let apiClient = APIClientMock()
        let moviesView = MoviesViewMock()
        
        let ctrler = MoviesCtrler(moviesView, persistenceManager: persistenceManager, apiClient: apiClient)
        ctrler.loadMovies(forModel: .topRated)
        
        XCTAssert(persistenceManager.getMoviesCount == 1)
        XCTAssert(persistenceManager.updateConfigurationPageMoviesCount == 0)
        XCTAssert(persistenceManager.saveMoviesCount == 0)
        XCTAssert(moviesView.updateMoviesCount == 1)
        XCTAssert(apiClient.getTopRatedMoviesCount == 0)
    }
    
    func testTopRatedLoadNextPageMovies() {
        let persistenceManager = PersistenceManagerMock()
        persistenceManager.returnGetMovies = true
        let apiClient = APIClientMock()
        let moviesView = MoviesViewMock()
        
        let ctrler = MoviesCtrler(moviesView, persistenceManager: persistenceManager, apiClient: apiClient)
        ctrler.loadMovies(forModel: .topRated)
        ctrler.loadNextPageMovies()
        
        XCTAssert(persistenceManager.getMoviesCount == 2)
        XCTAssert(persistenceManager.updateConfigurationPageMoviesCount == 1)
        XCTAssert(persistenceManager.saveMoviesCount == 1)
        XCTAssert(moviesView.updateMoviesCount == 1)
        XCTAssert(apiClient.getTopRatedMoviesCount == 1)
    }
    
    func testGetImageForMovie() {
        let persistenceManager = PersistenceManagerMock()
        persistenceManager.returnGetMovies = true
        let apiClient = APIClientMock()
        let moviesView = MoviesViewMock()
        let ctrler = MoviesCtrler(moviesView, persistenceManager: persistenceManager, apiClient: apiClient)
        
        let movie = MoviesVM(managedObject: persistenceManager.getMovies(fromModel: .popular).first!)
        ctrler.getImageForMovie(movie: movie, indexPath: IndexPath(row: 0, section: 0))
        
        XCTAssert(persistenceManager.saveImageForMovieIdCount == 1)
        XCTAssert(apiClient.getImageCout == 1)
        XCTAssert(moviesView.updateImageCount == 1)
    }
}

class MoviesViewMock: MoviesVCDelegate {
    var updateMoviesCount = 0
    var updateImageCount = 0
    
    func networkError(error: Error) {
        
    }
    
    func updateMovies(movies: [MoviesVM]) {
        updateMoviesCount += 1
    }
    
    func updateImage(image: UIImage, indexPath: IndexPath) {
        updateImageCount += 1
    }
}
