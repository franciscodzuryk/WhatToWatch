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

public struct ShowsVM {
    let id: Int
    let posterPath: String?
    let overview: String
    let originalName: String
    let originalLanguage: String?
    let name: String
    let backdropPath: String?
    let popularity: Double
    let voteCount: Int
    let voteAverage: Double
    let backdropImage: UIImage?
    var posterImage: UIImage?
    
    init(showModel: ShowModel) {
        self.id = Int(showModel.id)
        self.posterPath = showModel.posterPath
        self.overview = showModel.overview!
        self.originalName = showModel.originalName!
        self.originalLanguage = showModel.originalLanguage
        self.name = showModel.name!
        self.backdropPath = showModel.backdropPath
        self.popularity = showModel.popularity
        self.voteCount = Int(showModel.voteCount)
        self.voteAverage = showModel.voteAverage
        if let backdropImageData = showModel.backdropImage {
            self.backdropImage = UIImage(data: backdropImageData)
        } else {
            self.backdropImage = nil
        }
        
        if let posterImageData = showModel.posterImage {
            self.posterImage = UIImage(data: posterImageData)
        } else {
            self.posterImage = nil
        }
    }
    
    init(item:Item) {
        self.id = item.id
        self.posterPath = item.posterPath
        self.overview = item.overview
        self.originalName = item.originalTitle
        self.originalLanguage = item.originalTitle
        self.name = item.title
        self.backdropPath = item.backdropPathString
        self.popularity = item.popularity
        self.voteCount = item.voteCount
        self.voteAverage = item.voteAverage
        self.backdropImage = item.backdropImage
        self.posterImage = item.posterImage
    }
}
