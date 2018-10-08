//
//  SearchModels.swift
//  WhatToWatch
//
//  Created by Fran on 04/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import UIKit
import CoreData

struct SearchRequest {
    var query: MoviesSearchParameters?
    
    init(_ query: String) {
        self.query = MoviesSearchParameters(query: query, page: 0, language: "en-US")
    }
    
    mutating func nextPage() -> SearchRequest {
        self.query = self.query?.nextPage
        return self
    }
    
}

struct SearchMovieResponse: Codable {
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let results: [ItemMovieDTO]
    
    private enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}

struct ItemMovieDTO: Codable {
    let id: Int
    let posterPath: String?
    let adult: Bool
    let overview: String
    let releaseDate: String
    let genreIds: [Int]
    let originalTitle: String
    let originalLanguage: String
    let title: String
    let backdropPathString: String?
    let popularity: Double
    let voteCount: Int
    let video: Bool
    let voteAverage: Double
    
    private enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case adult
        case overview
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case title
        case backdropPathString = "backdrop_path"
        case popularity
        case voteCount = "vote_count"
        case video
        case voteAverage = "vote_average"
    }
}

struct SearchShowResponse: Codable {
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let results: [ItemShowDTO]
    
    private enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}

struct ItemShowDTO: Codable {
    let id: Int
    let posterPath: String?
    let overview: String
    let originalName: String
    let originalLanguage: String
    let name: String
    let backdropPath: String?
    let popularity: Double
    let voteCount: Int
    let voteAverage: Double
    
    private enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case overview
        case originalName = "original_name"
        case originalLanguage = "original_language"
        case name
        case backdropPath = "backdrop_path"
        case popularity
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
    }
}

struct Item {
    let id: Int
    let posterPath: String?
    let adult: Bool
    let overview: String
    let releaseDate: String
    let genreIds: [Int]
    let originalTitle: String
    let originalLanguage: String?
    let title: String
    let backdropPathString: String?
    let popularity: Double
    let voteCount: Int
    let video: Bool
    let voteAverage: Double
    var backdropImage: UIImage?
    var posterImage: UIImage?
    
    init(_ id: Int, posterPath: String?, adult: Bool, overview: String, releaseDate: String,
         genreIds: [Int], originalTitle: String, originalLanguage: String?, title: String, backdropPathString: String?,
         popularity: Double, voteCount: Int, video: Bool, voteAverage: Double, image: UIImage?, backdropImage: UIImage?,
         posterImage: UIImage?) {
        self.id = id
        self.posterPath = posterPath
        self.adult = adult
        self.overview = overview
        self.releaseDate = releaseDate
        self.genreIds = genreIds
        self.originalTitle = originalTitle
        self.originalLanguage = originalTitle
        self.title = title
        self.backdropPathString = backdropPathString
        self.popularity = popularity
        self.voteCount = voteCount
        self.video = video
        self.voteAverage = voteAverage
        self.backdropImage = backdropImage
        self.posterImage = posterImage
    }
    
    init(itemMovieDTO itemDTO: ItemMovieDTO) {
        self.id = itemDTO.id
        if let posterURL = itemDTO.posterPath {
            self.posterPath = "https://image.tmdb.org/t/p/w185/" + posterURL
        } else {
            self.posterPath = nil
        }
        self.adult = itemDTO.adult
        self.overview = itemDTO.overview
        self.releaseDate = itemDTO.releaseDate
        self.genreIds = itemDTO.genreIds
        self.originalTitle = itemDTO.originalTitle
        self.originalLanguage = itemDTO.originalLanguage
        self.title = itemDTO.title
        if let posterURL = itemDTO.backdropPathString {
            self.backdropPathString = "https://image.tmdb.org/t/p/w185/" + posterURL
        } else {
            self.backdropPathString = nil
        }
        self.popularity = itemDTO.popularity
        self.voteCount = itemDTO.voteCount
        self.video = itemDTO.video
        self.voteAverage = itemDTO.voteAverage
        self.backdropImage = nil
        self.posterImage = nil
    }
    
    init(itemShowDTO itemDTO: ItemShowDTO) {
        self.id = itemDTO.id
        if let posterURL = itemDTO.posterPath {
            self.posterPath = "https://image.tmdb.org/t/p/w185/" + posterURL
        } else {
            self.posterPath = nil
        }
        self.adult = false
        self.overview = itemDTO.overview
        self.releaseDate = ""
        self.genreIds = [Int]()
        self.originalTitle = itemDTO.originalName
        self.originalLanguage = itemDTO.originalLanguage
        self.title = itemDTO.name
        if let posterURL = itemDTO.backdropPath {
            self.backdropPathString = "https://image.tmdb.org/t/p/w185/" + posterURL
        } else {
            self.backdropPathString = nil
        }
        self.popularity = itemDTO.popularity
        self.voteCount = itemDTO.voteCount
        self.video = false
        self.voteAverage = itemDTO.voteAverage
        self.backdropImage = nil
        self.posterImage = nil
    }
    
    init(_ managedObject: NSManagedObject) {
        self.id = managedObject.value(forKey:"id") as! Int
        self.posterPath = managedObject.value(forKey:"posterPath") as? String
        if managedObject.entity.propertiesByName.keys.contains("adult") {
            self.adult = managedObject.value(forKey:"adult") as! Bool
        } else {
            self.adult = false
        }
        self.overview = managedObject.value(forKey:"overview") as! String
        if managedObject.entity.propertiesByName.keys.contains("releaseDate") {
            self.releaseDate = managedObject.value(forKey:"releaseDate") as! String
        } else {
            self.releaseDate = ""
        }
        
        if managedObject.entity.propertiesByName.keys.contains("originalTitle") {
            self.originalTitle = managedObject.value(forKey:"originalTitle") as! String
        } else {
            self.originalTitle = managedObject.value(forKey:"originalName") as! String
        }
        
        self.originalLanguage = managedObject.value(forKey:"originalLanguage") as? String
        if managedObject.entity.propertiesByName.keys.contains("title") {
            self.title = managedObject.value(forKey:"title") as! String
        } else {
            self.title = managedObject.value(forKey:"name") as! String
        }
        
        if managedObject.entity.propertiesByName.keys.contains("backdropPathString") {
            self.backdropPathString = managedObject.value(forKey:"backdropPathString") as? String
        } else {
            self.backdropPathString = managedObject.value(forKey:"backdropPath") as? String
        }
        self.popularity = managedObject.value(forKey:"popularity") as! Double
        self.voteCount = managedObject.value(forKey:"voteCount") as! Int
        self.voteAverage = managedObject.value(forKey:"voteAverage") as! Double
        self.genreIds = [Int]()
        self.video = false
        
        if let backdropImageData = managedObject.value(forKey:"backdropImage") as! Data? {
            self.backdropImage = UIImage(data: backdropImageData)
        } else {
            self.backdropImage = nil
        }
        
        if let posterImageData = managedObject.value(forKey:"posterImage") as! Data? {
            self.posterImage = UIImage(data: posterImageData)
        } else {
            self.posterImage = nil
        }
    }
}

struct SearchViewModel {
    var items: [Item]
}
