//
//  ContextManager+Movie.swift
//  WhatToWatch
//
//  Created by Francisco on 12/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import UIKit
import CoreData

public enum MoviesPersistenModel : String, CaseIterable {
    case popular = "MoviePopularModel"
    case upcoming = "MovieUpcomingModel"
    case topRated = "MovieTopRatedModel"
}

protocol ContextManagerMovieInterface {
    func cleanMovieModel()
    func saveMovies(movies: [Movie], onModel model: MoviesPersistenModel)
    func getMovieById(id:Int, fromModel model: MoviesPersistenModel) -> MovieModel?
    func getMovies(fromModel model:MoviesPersistenModel) -> [MovieModel]
    func saveImageForMovieId(_ id:Int, image:UIImage, type:ImageType)
}

extension ContextManager:ContextManagerMovieInterface {
    func cleanMovieModel() {
        do {
            _ = try getContext().execute(NSBatchDeleteRequest(fetchRequest:
                NSFetchRequest<NSFetchRequestResult>(entityName: MoviesPersistenModel.popular.rawValue)))
            _ = try getContext().execute(NSBatchDeleteRequest(fetchRequest:
                NSFetchRequest<NSFetchRequestResult>(entityName: MoviesPersistenModel.upcoming.rawValue)))
            _ = try getContext().execute(NSBatchDeleteRequest(fetchRequest:
                NSFetchRequest<NSFetchRequestResult>(entityName: MoviesPersistenModel.topRated.rawValue)))
            saveContext()
        } catch {
            
        }
    }
    
    func saveMovies(movies: [Movie], onModel model: MoviesPersistenModel) {
        for movie in movies {
            if let _ = getMovieById(id: movie.id, fromModel: model) {
                continue
            }
            let movieModel = NSEntityDescription.insertNewObject(forEntityName: model.rawValue , into: getContext()) as! MovieModel
            movieModel.id = Int32(movie.id)
            movieModel.title = movie.title
            movieModel.adult = movie.adult
            movieModel.backdropPath = movie.backdropPath
            movieModel.overview = movie.overview
            movieModel.popularity = movie.popularity
            movieModel.posterPath = movie.posterPath
            movieModel.releaseDate = movie.releaseDate
            movieModel.voteAverage = movie.voteAverage
            movieModel.voteCount = Int32(movie.voteCount)
            movieModel.originalTitle = movie.originalTitle
            movieModel.originalLanguage = movie.originalLanguage
        }
        saveContext()
    }
    
    func getMovieById(id:Int, fromModel model: MoviesPersistenModel) -> MovieModel? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: model.rawValue) as! NSFetchRequest<MovieModel>
        request.predicate = NSPredicate(format: "id = \(id)")
        do {
            let result = try getContext().fetch(request)
            if (result.count > 0) {
                return result.first
            }
        } catch {
            return nil
        }
        return nil
    }
    
    func getMovies(fromModel model:MoviesPersistenModel) -> [MovieModel] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: model.rawValue) as! NSFetchRequest<MovieModel>
        do {
            let result = try getContext().fetch(request)
            return result
        } catch {
            return [MovieModel]()
        }
    }
    
    func saveImageForMovieId(_ id:Int, image:UIImage, type:ImageType) {
        let imageData = image.jpegData(compressionQuality: 1.0)
        MoviesPersistenModel.allCases.forEach {
            let model = $0.rawValue
            let request = NSFetchRequest<NSFetchRequestResult>(entityName:model)
            request.predicate = NSPredicate(format: "id = \(id)")
            do {
                let result = try getContext().fetch(request)
                if (result.count > 0) {
                    let movieModel = result.first as! NSManagedObject
                    movieModel.setValue(imageData, forKeyPath: type.rawValue)
                }
            } catch {
                
            }
        }
        saveContext()
    }
}
