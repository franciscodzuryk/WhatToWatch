//
//  APIClient.swift
//  WhatToWatch
//
//  Created by Fran on 02/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

protocol APIClientInterface {
    func getAPIConfiguration(success:@escaping (_ result: APIConfiguration) -> Void, fail: @escaping (_ error: Error) -> Void)
    func getPopularMovies(page: Int!, success:@escaping (_ result: [Movie]) -> Void, fail: @escaping (_ error: Error) -> Void)
    func getUpcomingMovies(page: Int!, success:@escaping (_ result: [Movie]) -> Void, fail: @escaping (_ error: Error) -> Void)
    func getTopRatedMovies(page: Int!, success:@escaping (_ result: [Movie]) -> Void, fail: @escaping (_ error: Error) -> Void)
    func getDetailMovie(movieId: Int!, success:@escaping (_ result: [Movie]) -> Void, fail: @escaping (_ error: Error) -> Void)
    func getImage(_ url: String, success:@escaping (_ response: UIImage) -> Void, fail:@escaping (_ error: NSError) -> Void)
    func getVideosMovie(movieId: Int!, success:@escaping (_ result: [VideoMovie]) -> Void, fail: @escaping (_ error: Error) -> Void)
    func getPopularShows(page: Int!, success:@escaping (_ result: [Show]) -> Void, fail: @escaping (_ error: Error) -> Void)
    func getOnTheAirShows(page: Int!, success:@escaping (_ result: [Show]) -> Void, fail: @escaping (_ error: Error) -> Void)
    func getTopRatedShows(page: Int!, success:@escaping (_ result: [Show]) -> Void, fail: @escaping (_ error: Error) -> Void)
    func getVideosShow(showId: Int!, success:@escaping (_ result: [VideoMovie]) -> Void, fail: @escaping (_ error: Error) -> Void)
}

class APIClient : APIClientInterface {
    func getAPIConfiguration(success:@escaping (_ result: APIConfiguration) -> Void, fail: @escaping (_ error: Error) -> Void) {
        AF.request(Router.APIConfig).responseData { response in
            switch response.result {
            case .success(let data):
                do{
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(APIConfiguration.self, from: data)
                    success(result)
                }catch let error {
                    fail(error)
                }
            case .failure(let error):
                fail(error)
            }
        }
    }
    
    func getPopularMovies(page: Int!, success:@escaping (_ result: [Movie]) -> Void, fail: @escaping (_ error: Error) -> Void) {
        AF.request(Router.popularMovies(page: page)).responseData { response in
            switch response.result {
            case .success(let data):
                do{
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(MovieResult.self, from: data)
                    success(result.results)
                }catch let error {
                    fail(error)
                }
            case .failure(let error):
                fail(error)
            }
        }
    }
    
    func getUpcomingMovies(page: Int!, success:@escaping (_ result: [Movie]) -> Void, fail: @escaping (_ error: Error) -> Void) {
        AF.request(Router.upcomingMovies(page: page)).responseData { response in
            switch response.result {
            case .success(let data):
                do{
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(MovieResult.self, from: data)
                    success(result.results)
                }catch let error {
                    fail(error)
                }
            case .failure(let error):
                fail(error)
            }
        }
    }
    
    func getTopRatedMovies(page: Int!, success:@escaping (_ result: [Movie]) -> Void, fail: @escaping (_ error: Error) -> Void) {
        AF.request(Router.topRatedMovies(page: page)).responseData { response in
            switch response.result {
            case .success(let data):
                do{
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(MovieResult.self, from: data)
                    success(result.results)
                }catch let error {
                    fail(error)
                }
            case .failure(let error):
                fail(error)
            }
        }
    }
    
    func getDetailMovie(movieId: Int!, success:@escaping (_ result: [Movie]) -> Void, fail: @escaping (_ error: Error) -> Void) {
        AF.request(Router.movieDetail(movieId: movieId)).responseData { response in
            switch response.result {
            case .success(let data):
                do{
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(MovieResult.self, from: data)
                    success(result.results)
                }catch let error {
                    fail(error)
                }
            case .failure(let error):
                fail(error)
            }
        }
    }

    func getVideosMovie(movieId: Int!, success:@escaping (_ result: [VideoMovie]) -> Void, fail: @escaping (_ error: Error) -> Void) {
        AF.request(Router.movieVideos(movieId: movieId)).responseData { response in
            switch response.result {
            case .success(let data):
                do{
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(VideosMovieResult.self, from: data)
                    success(result.results)
                }catch let error {
                    fail(error)
                }
            case .failure(let error):
                fail(error)
            }
        }
    }
    
    func getImage(_ url: String, success:@escaping (_ response: UIImage) -> Void, fail:@escaping (_ error: NSError) -> Void) {
        AF.request(url)
            .responseImage { response in
                switch response.result {
                case .success(let image):
                        success(image)
                case .failure(let error):
                    fail(error as NSError)
                }
        }
    }

    func getPopularShows(page: Int!, success:@escaping (_ result: [Show]) -> Void, fail: @escaping (_ error: Error) -> Void) {
        AF.request(Router.popularShows(page: page)).responseData { response in
            switch response.result {
            case .success(let data):
                do{
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(ShowResult.self, from: data)
                    success(result.results)
                }catch let error {
                    fail(error)
                }
            case .failure(let error):
                fail(error)
            }
        }
    }
    
    func getOnTheAirShows(page: Int!, success:@escaping (_ result: [Show]) -> Void, fail: @escaping (_ error: Error) -> Void) {
        AF.request(Router.onTheAirShows(page: page)).responseData { response in
            switch response.result {
            case .success(let data):
                do{
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(ShowResult.self, from: data)
                    success(result.results)
                }catch let error {
                    fail(error)
                }
            case .failure(let error):
                fail(error)
            }
        }
    }
    
    func getTopRatedShows(page: Int!, success:@escaping (_ result: [Show]) -> Void, fail: @escaping (_ error: Error) -> Void) {
        AF.request(Router.topRatedShows(page: page)).responseData { response in
            switch response.result {
            case .success(let data):
                do{
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(ShowResult.self, from: data)
                    success(result.results)
                }catch let error {
                    fail(error)
                }
            case .failure(let error):
                fail(error)
            }
        }
    }
    
    func getVideosShow(showId: Int!, success:@escaping (_ result: [VideoMovie]) -> Void, fail: @escaping (_ error: Error) -> Void) {
        AF.request(Router.showVideos(showId: showId)).responseData { response in
            switch response.result {
            case .success(let data):
                do{
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(VideosMovieResult.self, from: data)
                    success(result.results)
                }catch let error {
                    fail(error)
                }
            case .failure(let error):
                fail(error)
            }
        }
    }
}
