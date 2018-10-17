//
//  MoviesVM.swift
//  WhatToWatch
//
//  Created by Fran on 04/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public struct MoviesVM {
    let id: Int
    let posterPath: String?
    let adult: Bool
    let overview: String
    let releaseDate: String
    let originalTitle: String
    let originalLanguage: String?
    let title: String
    let backdropPathString: String?
    let popularity: Double
    let voteCount: Int
    let voteAverage: Double
    let backdropImage: UIImage?
    var posterImage: UIImage?
    
    init(movieModel: MovieModel) {
        self.id = Int(movieModel.id)
        self.posterPath = movieModel.posterPath
        self.adult = movieModel.adult
        self.overview = movieModel.overview!
        self.releaseDate = movieModel.releaseDate!
        self.originalTitle = movieModel.originalTitle!
        self.originalLanguage = movieModel.originalLanguage
        self.title = movieModel.title!
        self.backdropPathString = movieModel.backdropPath
        self.popularity = movieModel.popularity
        self.voteCount = Int(movieModel.voteCount)
        self.voteAverage = movieModel.voteAverage
        
        if let backdropImageData = movieModel.backdropImage {
            self.backdropImage = UIImage(data: backdropImageData)
        } else {
            self.backdropImage = nil
        }
        
        if let posterImageData = movieModel.posterImage {
            self.posterImage = UIImage(data: posterImageData)
        } else {
            self.posterImage = nil
        }
    }
    
    init(item:Item) {
        self.id = item.id
        self.posterPath = item.posterPath
        self.adult = item.adult
        self.overview = item.overview
        self.releaseDate = item.releaseDate
        self.originalTitle = item.originalTitle
        self.originalLanguage = item.originalTitle
        self.title = item.title
        self.backdropPathString = item.backdropPathString
        self.popularity = item.popularity
        self.voteCount = item.voteCount
        self.voteAverage = item.voteAverage
        self.backdropImage = item.backdropImage
        self.posterImage = item.posterImage
    }
}
