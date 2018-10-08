//
//  APIClientInterfaceMock.swift
//  WhatToWatchTests
//
//  Created by Fran on 07/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import UIKit

class APIClientMock : APIClientInterface {
    var apiConfiguration: APIConfiguration!
    var movies = [Movie]()
    
    var getConfigurationCallCount = 0
    var getPopularMoviesCount = 0
    var getUpcomingMoviesCount = 0
    var getTopRatedMoviesCount = 0
    var getImageCout = 0
    var getPopularShowsCount = 0
    var getOnTheAirShowsCount = 0
    var getTopRatedShowsCount = 0
    
    init() {
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
    
    func getAPIConfiguration(success: @escaping (APIConfiguration) -> Void, fail: @escaping (Error) -> Void) {
        getConfigurationCallCount += 1
        success(apiConfiguration)
    }
    
    func getPopularMovies(page: Int!, success: @escaping ([Movie]) -> Void, fail: @escaping (Error) -> Void) {
        getPopularMoviesCount += 1
        success(movies)
    }
    
    func getUpcomingMovies(page: Int!, success: @escaping ([Movie]) -> Void, fail: @escaping (Error) -> Void) {
        getUpcomingMoviesCount += 1
        success(movies)
    }
    
    func getTopRatedMovies(page: Int!, success: @escaping ([Movie]) -> Void, fail: @escaping (Error) -> Void) {
        getTopRatedMoviesCount += 1
        success(movies)
    }
    
    func getDetailMovie(movieId: Int!, success: @escaping ([Movie]) -> Void, fail: @escaping (Error) -> Void) {
        
    }
    
    func getImage(_ url: String, success: @escaping (UIImage) -> Void, fail: @escaping (NSError) -> Void) {
        getImageCout += 1
        success(UIImage(named: "empty_poster")!)
    }
    
    func getVideosMovie(movieId: Int!, success: @escaping ([VideoMovie]) -> Void, fail: @escaping (Error) -> Void) {
        
    }
    
    func getPopularShows(page: Int!, success: @escaping ([Show]) -> Void, fail: @escaping (Error) -> Void) {
        getPopularShowsCount += 1
    }
    
    func getOnTheAirShows(page: Int!, success: @escaping ([Show]) -> Void, fail: @escaping (Error) -> Void) {
        getOnTheAirShowsCount += 1
    }
    
    func getTopRatedShows(page: Int!, success: @escaping ([Show]) -> Void, fail: @escaping (Error) -> Void) {
        getTopRatedShowsCount += 1
    }
    
    func getVideosShow(showId: Int!, success: @escaping ([VideoMovie]) -> Void, fail: @escaping (Error) -> Void) {
        
    }
}
