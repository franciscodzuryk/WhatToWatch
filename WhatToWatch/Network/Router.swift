//
//  Router.swift
//  WhatToWatch
//
//  Created by Fran on 02/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import Foundation
import Alamofire


public struct MoviesSearchParameters {
    let query: String
    let page: Int?
    let language: String?
    
    var nextPage: MoviesSearchParameters {
        guard let page = self.page else { return self }
        return MoviesSearchParameters(query: self.query, page: page + 1, language: self.language)
    }
    
    var URLParametersList: [String: String] {
        var parameters = [String: String]()
        parameters["query"] = self.query
        if let page = self.page { parameters["page"] = "\(page + 1)" } // Pagination starts at 1 on TMDb API
        if let language = self.language { parameters["language"] = language }
        return parameters
    }
    
    init(query: String, page: Int?, language: String?) {
        self.query = query
        self.page = page
        self.language = language
    }
}

public enum Router: URLRequestConvertible {
    case APIConfig
    case searchMovies(parameters: MoviesSearchParameters)
    case popularMovies(page: Int!)
    case upcomingMovies(page: Int!)
    case topRatedMovies(page: Int!)
    case movieDetail(movieId: Int)
    case movieVideos(movieId: Int)
    case popularShows(page: Int!)
    case onTheAirShows(page: Int!)
    case topRatedShows(page: Int!)
    case showVideos(showId: Int)
    case searchShows(parameters: MoviesSearchParameters)

    // MARK: - Properties
    static let BaseURL: URL = URL(string: Bundle.main.infoDictionary!["kBaseURL"] as! String)!
    static let TMDbAPIKey = Bundle.main.infoDictionary!["kMDBAPIKey"] as! String
    
    var path: String {
        switch self {
            case .APIConfig: return "/configuration"
            case .searchMovies(_): return "/search/movie"
            case .popularMovies(_): return "/movie/popular"
            case .upcomingMovies(_): return "/movie/upcoming"
            case .topRatedMovies(_): return "/movie/top_rated"
            case .movieDetail(let movieId): return "/movie/\(movieId)"
            case .movieVideos(let movieId): return "/movie/\(movieId)/videos"
            case .popularShows(_): return "/tv/popular"
            case .onTheAirShows(_): return "/tv/on_the_air"
            case .topRatedShows(_): return "/tv/top_rated"
            case .showVideos(let showId): return "/tv/\(showId)/videos"
            case .searchShows(_): return "/search/tv"
        }
    }
    
    var httpMethod: Alamofire.HTTPMethod {
        switch self {
            case .APIConfig: return .get
            case .searchMovies(_): return .get
            case .popularMovies(_): return .get
            case .upcomingMovies(_): return .get
            case .topRatedMovies(_): return .get
            case .movieDetail(_): return .get
            case .movieVideos(_): return .get
            case .popularShows(_): return .get
            case .onTheAirShows(_): return .get
            case .topRatedShows(_): return .get
            case .showVideos(_): return .get
            case .searchShows(_): return .get
        }
    }
    
    // MARK: - URLRequestConvertible overriden properties / functions
    
    public func asURLRequest() throws -> URLRequest {
        let url: URL = Router.BaseURL.appendingPathComponent(self.path)
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = self.httpMethod.rawValue
        
        let result: URLRequest = try {
            switch self {
                case .APIConfig:
                    var urlParameters = [String : String]()
                    urlParameters["api_key"] = Router.TMDbAPIKey
                    return try URLEncoding.queryString.encode(request, with: urlParameters)
                
                case .searchMovies(let parameters):
                    var urlParameters = parameters.URLParametersList
                    urlParameters["api_key"] = Router.TMDbAPIKey
                    return try URLEncoding.queryString.encode(request, with: urlParameters)
                
                case .popularMovies(let page):
                    var urlParameters = [String: String]()
                    urlParameters["api_key"] = Router.TMDbAPIKey
                    if let page = page { urlParameters["page"] = "\(page + 1)" }
                    return try URLEncoding.queryString.encode(request, with: urlParameters)
                case .upcomingMovies(let page):
                    var urlParameters = [String: String]()
                    urlParameters["api_key"] = Router.TMDbAPIKey
                    if let page = page { urlParameters["page"] = "\(page + 1)" }
                    return try URLEncoding.queryString.encode(request, with: urlParameters)
                case .topRatedMovies(let page):
                    var urlParameters = [String: String]()
                    urlParameters["api_key"] = Router.TMDbAPIKey
                    if let page = page { urlParameters["page"] = "\(page + 1)" }
                    return try URLEncoding.queryString.encode(request, with: urlParameters)
            
                case .movieDetail(_):
                    var urlParameters = [String: String]()
                    urlParameters["api_key"] = Router.TMDbAPIKey
                    urlParameters["append_to_response"] = "videos"
                    return try URLEncoding.queryString.encode(request, with: urlParameters)
                case .movieVideos(_):
                    var urlParameters = [String: String]()
                    urlParameters["api_key"] = Router.TMDbAPIKey
                    return try URLEncoding.queryString.encode(request, with: urlParameters)
                
                case .popularShows(let page):
                    var urlParameters = [String: String]()
                    urlParameters["api_key"] = Router.TMDbAPIKey
                    if let page = page { urlParameters["page"] = "\(page + 1)" }
                    return try URLEncoding.queryString.encode(request, with: urlParameters)
                case .onTheAirShows(let page):
                    var urlParameters = [String: String]()
                    urlParameters["api_key"] = Router.TMDbAPIKey
                    if let page = page { urlParameters["page"] = "\(page + 1)" }
                    return try URLEncoding.queryString.encode(request, with: urlParameters)
                case .topRatedShows(let page):
                    var urlParameters = [String: String]()
                    urlParameters["api_key"] = Router.TMDbAPIKey
                    if let page = page { urlParameters["page"] = "\(page + 1)" }
                    return try URLEncoding.queryString.encode(request, with: urlParameters)
                
                case .showVideos(_):
                    var urlParameters = [String: String]()
                    urlParameters["api_key"] = Router.TMDbAPIKey
                    return try URLEncoding.queryString.encode(request, with: urlParameters)
                
                case .searchShows(let parameters):
                    var urlParameters = parameters.URLParametersList
                    urlParameters["api_key"] = Router.TMDbAPIKey
                    return try URLEncoding.queryString.encode(request, with: urlParameters)
            }
        }()
        return result
    }
}
