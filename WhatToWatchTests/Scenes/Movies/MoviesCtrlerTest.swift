//
//  MoviesCtrlerTest.swift
//  WhatToWatchTests
//
//  Created by Fran on 07/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import XCTest

class MoviesCtrlerTest: XCTestCase {

    let contextManager: ContextManagerInterface? = nil
    let apiClient: APIClientInterface? = nil
    let view: MoviesVCDelegate? = nil

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInit() {
        let contextManagerMock = ContextManagerMock()
        let apiClient = APIClientMock()
        _ = MoviesCtrler(MoviesViewMock(), contextManager: contextManagerMock, apiClient: apiClient)
        XCTAssert(contextManagerMock.getConfigurationCount == 1)
        XCTAssert(contextManagerMock.saveConfigurationCount == 1)
        XCTAssert(apiClient.getConfigurationCallCount == 1)
    }

    func testInitWithConfig() {
        let contextManager = ContextManagerMock()
        contextManager.returnConfiguration = true
        let apiClient = APIClientMock()
        _ = MoviesCtrler(MoviesViewMock(), contextManager: contextManager, apiClient: apiClient)
        XCTAssert(contextManager.getConfigurationCount == 1)
        XCTAssert(contextManager.saveConfigurationCount == 0)
        XCTAssert(apiClient.getConfigurationCallCount == 0)
    }

    func testPopularLoadMoviesNoData() {
        let contextManager = ContextManagerMock()
        let apiClient = APIClientMock()
        let moviesView = MoviesViewMock()

        let ctrler = MoviesCtrler(moviesView, contextManager: contextManager, apiClient: apiClient)
        ctrler.loadMovies(forModel: .popular)

        XCTAssert(contextManager.getMoviesCount == 2)
        XCTAssert(contextManager.updateConfigurationPageMoviesCount == 1)
        XCTAssert(contextManager.saveMoviesCount == 1)
        XCTAssert(moviesView.updateMoviesCount == 1)
        XCTAssert(apiClient.getPopularMoviesCount == 1)
    }

    func testPopularLoadMovies() {
        let contextManager = ContextManagerMock()
        contextManager.returnGetMovies = true
        let apiClient = APIClientMock()
        let moviesView = MoviesViewMock()

        let ctrler = MoviesCtrler(moviesView, contextManager: contextManager, apiClient: apiClient)
        ctrler.loadMovies(forModel: .popular)

        XCTAssert(contextManager.getMoviesCount == 1)
        XCTAssert(contextManager.updateConfigurationPageMoviesCount == 0)
        XCTAssert(contextManager.saveMoviesCount == 0)
        XCTAssert(moviesView.updateMoviesCount == 1)
        XCTAssert(apiClient.getPopularMoviesCount == 0)
    }

    func testPopularLoadNextPageMovies() {
        let contextManager = ContextManagerMock()
        contextManager.returnGetMovies = true
        let apiClient = APIClientMock()
        let moviesView = MoviesViewMock()

        let ctrler = MoviesCtrler(moviesView, contextManager: contextManager, apiClient: apiClient)
        ctrler.loadMovies(forModel: .popular)
        ctrler.loadNextPageMovies()

        XCTAssert(contextManager.getMoviesCount == 2)
        XCTAssert(contextManager.updateConfigurationPageMoviesCount == 1)
        XCTAssert(contextManager.saveMoviesCount == 1)
        XCTAssert(moviesView.updateMoviesCount == 1)
        XCTAssert(apiClient.getPopularMoviesCount == 1)
    }

    func testUpcomingLoadMoviesNoData() {
        let contextManager = ContextManagerMock()
        let apiClient = APIClientMock()
        let moviesView = MoviesViewMock()

        let ctrler = MoviesCtrler(moviesView, contextManager: contextManager, apiClient: apiClient)
        ctrler.loadMovies(forModel: .upcoming)

        XCTAssert(contextManager.getMoviesCount == 2)
        XCTAssert(contextManager.updateConfigurationPageMoviesCount == 1)
        XCTAssert(contextManager.saveMoviesCount == 1)
        XCTAssert(moviesView.updateMoviesCount == 1)
        XCTAssert(apiClient.getUpcomingMoviesCount == 1)
    }

    func testUpcomingLoadMovies() {
        let contextManager = ContextManagerMock()
        contextManager.returnGetMovies = true
        let apiClient = APIClientMock()
        let moviesView = MoviesViewMock()

        let ctrler = MoviesCtrler(moviesView, contextManager: contextManager, apiClient: apiClient)
        ctrler.loadMovies(forModel: .upcoming)

        XCTAssert(contextManager.getMoviesCount == 1)
        XCTAssert(contextManager.updateConfigurationPageMoviesCount == 0)
        XCTAssert(contextManager.saveMoviesCount == 0)
        XCTAssert(moviesView.updateMoviesCount == 1)
        XCTAssert(apiClient.getUpcomingMoviesCount == 0)
    }

    func testUpcomingLoadNextPageMovies() {
        let contextManager = ContextManagerMock()
        contextManager.returnGetMovies = true
        let apiClient = APIClientMock()
        let moviesView = MoviesViewMock()

        let ctrler = MoviesCtrler(moviesView, contextManager: contextManager, apiClient: apiClient)
        ctrler.loadMovies(forModel: .upcoming)
        ctrler.loadNextPageMovies()

        XCTAssert(contextManager.getMoviesCount == 2)
        XCTAssert(contextManager.updateConfigurationPageMoviesCount == 1)
        XCTAssert(contextManager.saveMoviesCount == 1)
        XCTAssert(moviesView.updateMoviesCount == 1)
        XCTAssert(apiClient.getUpcomingMoviesCount == 1)
    }

    func testTopRatedLoadMoviesNoData() {
        let contextManager = ContextManagerMock()
        let apiClient = APIClientMock()
        let moviesView = MoviesViewMock()

        let ctrler = MoviesCtrler(moviesView, contextManager: contextManager, apiClient: apiClient)
        ctrler.loadMovies(forModel: .topRated)

        XCTAssert(contextManager.getMoviesCount == 2)
        XCTAssert(contextManager.updateConfigurationPageMoviesCount == 1)
        XCTAssert(contextManager.saveMoviesCount == 1)
        XCTAssert(moviesView.updateMoviesCount == 1)
        XCTAssert(apiClient.getTopRatedMoviesCount == 1)
    }

    func testTopRatedLoadMovies() {
        let contextManager = ContextManagerMock()
        contextManager.returnGetMovies = true
        let apiClient = APIClientMock()
        let moviesView = MoviesViewMock()

        let ctrler = MoviesCtrler(moviesView, contextManager: contextManager, apiClient: apiClient)
        ctrler.loadMovies(forModel: .topRated)

        XCTAssert(contextManager.getMoviesCount == 1)
        XCTAssert(contextManager.updateConfigurationPageMoviesCount == 0)
        XCTAssert(contextManager.saveMoviesCount == 0)
        XCTAssert(moviesView.updateMoviesCount == 1)
        XCTAssert(apiClient.getTopRatedMoviesCount == 0)
    }

    func testTopRatedLoadNextPageMovies() {
        let contextManager = ContextManagerMock()
        contextManager.returnGetMovies = true
        let apiClient = APIClientMock()
        let moviesView = MoviesViewMock()

        let ctrler = MoviesCtrler(moviesView, contextManager: contextManager, apiClient: apiClient)
        ctrler.loadMovies(forModel: .topRated)
        ctrler.loadNextPageMovies()

        XCTAssert(contextManager.getMoviesCount == 2)
        XCTAssert(contextManager.updateConfigurationPageMoviesCount == 1)
        XCTAssert(contextManager.saveMoviesCount == 1)
        XCTAssert(moviesView.updateMoviesCount == 1)
        XCTAssert(apiClient.getTopRatedMoviesCount == 1)
    }

    func testGetImageForMovie() {
        let contextManager = ContextManagerMock()
        contextManager.returnGetMovies = true
        let apiClient = APIClientMock()
        let moviesView = MoviesViewMock()
        let ctrler = MoviesCtrler(moviesView, contextManager: contextManager, apiClient: apiClient)

        let movie = MoviesVM(movieModel: contextManager.getMovies(fromModel: .popular).first!)
        ctrler.getImageForMovie(movie: movie, indexPath: IndexPath(row: 0, section: 0))

        XCTAssert(contextManager.saveImageForMovieIdCount == 1)
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
