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
    
    init(managedObject: NSManagedObject) {
        self.id = managedObject.value(forKey:"id") as! Int
        self.posterPath = managedObject.value(forKey:"posterPath") as? String
        self.overview = managedObject.value(forKey:"overview") as! String
        self.originalName = managedObject.value(forKey:"originalName") as! String
        self.originalLanguage = managedObject.value(forKey:"originalLanguage") as? String
        self.name = managedObject.value(forKey:"name") as! String
        self.backdropPath = managedObject.value(forKey:"backdropPath") as? String
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
