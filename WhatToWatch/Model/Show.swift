//
//  Show.swift
//  WhatToWatch
//
//  Created by Fran on 08/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import Foundation

public struct ShowResult: Codable {
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let results: [Show]
    
    private enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}

public struct Show: Codable {
    let id: Int
    let posterPath: String?
    let overview: String
    let genreIds: [Int]
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
        case genreIds = "genre_ids"
        case originalName = "original_name"
        case originalLanguage = "original_language"
        case name
        case backdropPath = "backdrop_path"
        case popularity
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
    }
}
