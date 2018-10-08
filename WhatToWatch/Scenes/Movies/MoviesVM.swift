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
    
    init(managedObject: NSManagedObject) {
        self.id = managedObject.value(forKey:"id") as! Int
        self.posterPath = managedObject.value(forKey:"posterPath") as? String
        self.adult = managedObject.value(forKey:"adult") as! Bool
        self.overview = managedObject.value(forKey:"overview") as! String
        self.releaseDate = managedObject.value(forKey:"releaseDate") as! String
        self.originalTitle = managedObject.value(forKey:"originalTitle") as! String
        self.originalLanguage = managedObject.value(forKey:"originalLanguage") as? String
        self.title = managedObject.value(forKey:"title") as! String
        self.backdropPathString = managedObject.value(forKey:"backdropPathString") as? String
        self.popularity = managedObject.value(forKey:"popularity") as! Double
        self.voteCount = managedObject.value(forKey:"voteCount") as! Int
        self.voteAverage = managedObject.value(forKey:"voteAverage") as! Double
        
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
