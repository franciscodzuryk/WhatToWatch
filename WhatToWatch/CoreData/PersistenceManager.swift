//
//  PersistenceManager.swift
//  WhatToWatch
//
//  Created by Fran on 03/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import UIKit
import CoreData

protocol PersistenceManagerInterface {
    func cleanAllData()
    func saveConfiguration(apiConf: APIConfiguration)
    func getConfiguration() -> NSManagedObject?
    func updateConfigurationPage(page: Int, forMovieModel: MoviesPersistenModel)
    func updateConfigurationPage(page: Int, forShowModel: ShowsPersistenModel)
    func saveMovies(movies: [Movie], onModel: MoviesPersistenModel)
    func movieWasAdded(id:Int, onModel: MoviesPersistenModel) -> Bool
    func getMovies(fromModel model:MoviesPersistenModel) -> [NSManagedObject]
    func saveImageForMovieId(_ id:Int, image:UIImage, type:ImageType)
    func saveShows(shows: [Show], onModel: ShowsPersistenModel)
    func showWasAdded(id:Int, onModel: ShowsPersistenModel) -> Bool
    func getShows(fromModel model:ShowsPersistenModel) -> [NSManagedObject]
    func saveImageForShowId(_ id:Int, image:UIImage, type:ImageType)
}

public enum MoviesPersistenModel : String, CaseIterable {
    case popular = "MoviePopularModel"
    case upcoming = "MovieUpcomingModel"
    case topRated = "MovieTopRatedModel"
}

public enum ShowsPersistenModel : String, CaseIterable {
    case popular = "ShowPopularModel"
    case onTheAir = "ShowOnTheAirModel"
    case topRated = "ShowTopRatedModel"
}

public enum ImageType : String {
    case backdropImage = "backdropImage"
    case posterImage = "posterImage"
}

class PersistenceManager {
    fileprivate var contextInstance: NSManagedObjectContext
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        contextInstance = appDelegate.contextManager.managedObjectContext
    }
    
    init(testContextManager:ContextManager) {
        contextInstance = testContextManager.managedObjectContext
    }
    
    func getContext() -> NSManagedObjectContext {
        return self.contextInstance
    }
    
    func saveContext() {
        do {
            try  self.contextInstance.save()
        } catch let saveError as NSError {
            print("save minion worker error: \(saveError.localizedDescription)")
        }
    }    
}

extension PersistenceManager : PersistenceManagerInterface {
    func cleanAllData() {
        do {
            _ = try contextInstance.execute(NSBatchDeleteRequest(fetchRequest:
                NSFetchRequest<NSFetchRequestResult>(entityName: "APIConfigurationModel")))
            _ = try contextInstance.execute(NSBatchDeleteRequest(fetchRequest:
                NSFetchRequest<NSFetchRequestResult>(entityName: "MoviePopularModel")))
            _ = try contextInstance.execute(NSBatchDeleteRequest(fetchRequest:
                NSFetchRequest<NSFetchRequestResult>(entityName: "MovieUpcomingModel")))
            _ = try contextInstance.execute(NSBatchDeleteRequest(fetchRequest:
                NSFetchRequest<NSFetchRequestResult>(entityName: "MovieTopRatedModel")))
            _ = try contextInstance.execute(NSBatchDeleteRequest(fetchRequest:
                NSFetchRequest<NSFetchRequestResult>(entityName: "ShowPopularModel")))
            _ = try contextInstance.execute(NSBatchDeleteRequest(fetchRequest:
                NSFetchRequest<NSFetchRequestResult>(entityName: "ShowOnTheAirModel")))
            _ = try contextInstance.execute(NSBatchDeleteRequest(fetchRequest:
                NSFetchRequest<NSFetchRequestResult>(entityName: "ShowTopRatedModel")))
            saveContext()
        } catch {
            
        }
    }
    
    func saveConfiguration(apiConf: APIConfiguration) {
        let encodedData = try? JSONEncoder().encode(apiConf)
        let entity = NSEntityDescription.entity(forEntityName: "APIConfigurationModel", in: self.contextInstance)
        let apiConfiguration = NSManagedObject(entity: entity!, insertInto: self.contextInstance)
        apiConfiguration.setValue(1, forKeyPath: "popularMoviesPage")
        apiConfiguration.setValue(1, forKeyPath: "upcomingPageCounter")
        apiConfiguration.setValue(1, forKeyPath: "topRatedPageCounter")
        apiConfiguration.setValue(1, forKeyPath: "popularShowsPage")
        apiConfiguration.setValue(1, forKeyPath: "onTheAirShowPage")
        apiConfiguration.setValue(1, forKeyPath: "topRatedShowPage")
        apiConfiguration.setValue(encodedData, forKeyPath: "configJSON")
        saveContext()
    }
    
    func getConfiguration() -> NSManagedObject? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "APIConfigurationModel")
        request.returnsObjectsAsFaults = false
        do {
            let result = try contextInstance.fetch(request)
            if (result.count > 0) {
                return result.first as? NSManagedObject
            }
        } catch {
            return nil
        }
        return nil
    }
    
    func updateConfigurationPage(page: Int, forMovieModel model: MoviesPersistenModel) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "APIConfigurationModel")
        request.returnsObjectsAsFaults = false
        do {
            let result = try contextInstance.fetch(request)
            if (result.count > 0) {
                let apiConfiguration = result.first as! NSManagedObject
                switch model {
                    case .popular: apiConfiguration.setValue(page, forKeyPath: "popularMoviesPage")
                    case .upcoming: apiConfiguration.setValue(page, forKeyPath: "upcomingPageCounter")
                    case .topRated: apiConfiguration.setValue(page, forKeyPath: "topRatedPageCounter")
                }
            }
        } catch {
            print("fail on updateConfigurationPages update")
        }
        saveContext()
    }
    
    func updateConfigurationPage(page: Int, forShowModel model: ShowsPersistenModel) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "APIConfigurationModel")
        request.returnsObjectsAsFaults = false
        do {
            let result = try contextInstance.fetch(request)
            if (result.count > 0) {
                let apiConfiguration = result.first as! NSManagedObject
                switch model {
                case .popular: apiConfiguration.setValue(page, forKeyPath: "popularShowsPage")
                case .onTheAir: apiConfiguration.setValue(page, forKeyPath: "onTheAirShowPage")
                case .topRated: apiConfiguration.setValue(page, forKeyPath: "topRatedShowPage")
                }
            }
        } catch {
            print("fail on updateConfigurationPages update")
        }
        saveContext()
    }
    
    func saveMovies(movies: [Movie], onModel: MoviesPersistenModel) {
        let entity = NSEntityDescription.entity(forEntityName: onModel.rawValue, in: self.contextInstance)
        for movie in movies {
            if (self.movieWasAdded(id: movie.id, onModel: onModel)) {
                continue
            }
            
            let movieModel = NSManagedObject(entity: entity!, insertInto: self.contextInstance)
            movieModel.setValue(movie.id, forKeyPath: "id")
            movieModel.setValue(movie.title, forKeyPath: "title")
            movieModel.setValue(movie.adult, forKeyPath: "adult")
            //Concatenate the base image string is wrong. I do this because this is just an example.
            //The ideal will be user selection from Config Screen. Not developed on this example.
            if let _ = movie.backdropPathString {
                movieModel.setValue("https://image.tmdb.org/t/p/w300/" + movie.backdropPathString!, forKeyPath: "backdropPathString")
            }
            movieModel.setValue(movie.overview, forKeyPath: "overview")
            movieModel.setValue(movie.popularity, forKeyPath: "popularity")
            //Concatenate the base image string is wrong. I do this because this is just an example.
            //The ideal will be user selection from Config Screen. Not developed on this example.
            if let _ = movie.posterPath {
                movieModel.setValue("https://image.tmdb.org/t/p/w185/" + movie.posterPath!, forKeyPath: "posterPath")
            }
            movieModel.setValue(movie.releaseDate, forKeyPath: "releaseDate")
            movieModel.setValue(movie.voteAverage, forKeyPath: "voteAverage")
            movieModel.setValue(movie.voteCount, forKeyPath: "voteCount")
            movieModel.setValue(movie.originalTitle, forKeyPath: "originalTitle")
            movieModel.setValue(movie.originalLanguage, forKeyPath: "originalLanguage")
        }
        saveContext()
    }
    
    func movieWasAdded(id:Int, onModel: MoviesPersistenModel) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: onModel.rawValue)
        request.predicate = NSPredicate(format: "id = \(id)")
        request.returnsObjectsAsFaults = false
        do {
            let result = try self.contextInstance.fetch(request)
            if (result.count > 0) {
                return true
            }
        } catch {
            return false
        }
        return false
    }
    
    func getMovies(fromModel model:MoviesPersistenModel) -> [NSManagedObject] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: model.rawValue)
        request.returnsObjectsAsFaults = false
        do {
            let result = try self.contextInstance.fetch(request)
            return result as! [NSManagedObject]
        } catch {
            return [NSManagedObject]()
        }
    }
    
    func saveImageForMovieId(_ id:Int, image:UIImage, type:ImageType) {
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        MoviesPersistenModel.allCases.forEach {
            let model = $0.rawValue
            let request = NSFetchRequest<NSFetchRequestResult>(entityName:model)
            request.predicate = NSPredicate(format: "id = \(id)")
            request.returnsObjectsAsFaults = false
            do {
                let result = try contextInstance.fetch(request)
                if (result.count > 0) {
                    let movieModel = result.first as! NSManagedObject
                    movieModel.setValue(imageData, forKeyPath: type.rawValue)
                }
            } catch {
                
            }
        }
        saveContext()
    }
    
    func saveShows(shows: [Show], onModel: ShowsPersistenModel) {
        let entity = NSEntityDescription.entity(forEntityName: onModel.rawValue, in: self.contextInstance)
        for show in shows {
            if (self.showWasAdded(id: show.id, onModel: onModel)) {
                continue
            }
            
            let showModel = NSManagedObject(entity: entity!, insertInto: self.contextInstance)
            showModel.setValue(show.id, forKeyPath: "id")
            showModel.setValue(show.name, forKeyPath: "name")
            //Concatenate the base image string is wrong. I do this because this is just an example.
            //The ideal will be user selection from Config Screen. Not developed on this example.
            if let backdropPath = show.backdropPath {
                showModel.setValue("https://image.tmdb.org/t/p/w300/" + backdropPath, forKeyPath: "backdropPath")
            }
            showModel.setValue(show.overview, forKeyPath: "overview")
            showModel.setValue(show.popularity, forKeyPath: "popularity")
            //Concatenate the base image string is wrong. I do this because this is just an example.
            //The ideal will be user selection from Config Screen. Not developed on this example.
            if let posterPath = show.posterPath {
                showModel.setValue("https://image.tmdb.org/t/p/w185/" + posterPath, forKeyPath: "posterPath")
            }
            showModel.setValue(show.voteAverage, forKeyPath: "voteAverage")
            showModel.setValue(show.voteCount, forKeyPath: "voteCount")
            showModel.setValue(show.originalName, forKeyPath: "originalName")
            showModel.setValue(show.originalLanguage, forKeyPath: "originalLanguage")
        }
        saveContext()
    }
    
    func showWasAdded(id:Int, onModel: ShowsPersistenModel) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: onModel.rawValue)
        request.predicate = NSPredicate(format: "id = \(id)")
        request.returnsObjectsAsFaults = false
        do {
            let result = try self.contextInstance.fetch(request)
            if (result.count > 0) {
                return true
            }
        } catch {
            return false
        }
        return false
    }
    
    func getShows(fromModel model:ShowsPersistenModel) -> [NSManagedObject] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: model.rawValue)
        request.returnsObjectsAsFaults = false
        do {
            let result = try self.contextInstance.fetch(request)
            return result as! [NSManagedObject]
        } catch {
            return [NSManagedObject]()
        }
    }
    
    func saveImageForShowId(_ id:Int, image:UIImage, type:ImageType) {
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        ShowsPersistenModel.allCases.forEach {
            let model = $0.rawValue
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: model)
            request.predicate = NSPredicate(format: "id = \(id)")
            request.returnsObjectsAsFaults = false
            do {
                let result = try contextInstance.fetch(request)
                if (result.count > 0) {
                    let showModel = result.first as! NSManagedObject
                    showModel.setValue(imageData, forKeyPath: type.rawValue)
                }
            } catch {
                
            }
        }
        saveContext()
    }
}
