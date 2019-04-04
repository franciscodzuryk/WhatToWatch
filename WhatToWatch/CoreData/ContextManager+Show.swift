//
//  ContextManager+Show.swift
//  WhatToWatch
//
//  Created by Francisco on 12/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import UIKit
import CoreData

public enum ShowsPersistenModel : String, CaseIterable {
    case popular = "ShowPopularModel"
    case onTheAir = "ShowOnTheAirModel"
    case topRated = "ShowTopRatedModel"
}

protocol ContextManagerShowInterface {
    func cleanShowModel()
    func saveShows(shows: [Show], onModel model: ShowsPersistenModel)
    func getShowById(id:Int, fromModel model: ShowsPersistenModel) -> ShowModel? 
    func getShows(fromModel model:ShowsPersistenModel) -> [ShowModel]
    func saveImageForShowId(_ id:Int, image:UIImage, type:ImageType)
}

extension ContextManager:ContextManagerShowInterface {
    
    func cleanShowModel() {
        do {
            _ = try getContext().execute(NSBatchDeleteRequest(fetchRequest:
                NSFetchRequest<NSFetchRequestResult>(entityName: ShowsPersistenModel.popular.rawValue)))
            _ = try getContext().execute(NSBatchDeleteRequest(fetchRequest:
                NSFetchRequest<NSFetchRequestResult>(entityName: ShowsPersistenModel.onTheAir.rawValue)))
            _ = try getContext().execute(NSBatchDeleteRequest(fetchRequest:
                NSFetchRequest<NSFetchRequestResult>(entityName: ShowsPersistenModel.topRated.rawValue)))
            saveContext()
        } catch {
            
        }
    }
    
    func saveShows(shows: [Show], onModel model: ShowsPersistenModel) {
        for show in shows {
            if let _ = getShowById(id: show.id, fromModel: model) {
                continue
            }
            
            let showModel = NSEntityDescription.insertNewObject(forEntityName: model.rawValue , into: getContext()) as! ShowModel
            showModel.id = Int32(show.id)
            showModel.name = show.name
            showModel.backdropPath = show.backdropPath
            showModel.overview = show.overview
            showModel.popularity = show.popularity
            showModel.posterPath = show.posterPath
            showModel.voteAverage = show.voteAverage
            showModel.voteCount = Int32(show.voteCount)
            showModel.originalName = show.originalName
            showModel.originalLanguage = show.originalLanguage
        }
        saveContext()
    }
    
    func getShowById(id:Int, fromModel model: ShowsPersistenModel) -> ShowModel? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: model.rawValue) as! NSFetchRequest<ShowModel>
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
    
    func getShows(fromModel model:ShowsPersistenModel) -> [ShowModel] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: model.rawValue) as! NSFetchRequest<ShowModel>
        do {
            let result = try getContext().fetch(request)
            return result
        } catch {
            return [ShowModel]()
        }
    }
    
    func saveImageForShowId(_ id:Int, image:UIImage, type:ImageType) {
        let imageData = image.jpegData(compressionQuality:1.0)
        ShowsPersistenModel.allCases.forEach {
            let model = $0.rawValue
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: model)
            request.predicate = NSPredicate(format: "id = \(id)")
            do {
                let result = try getContext().fetch(request)
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
