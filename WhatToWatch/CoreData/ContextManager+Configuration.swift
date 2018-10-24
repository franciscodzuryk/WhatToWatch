//
//  ContextManager+Configuration.swift
//  WhatToWatch
//
//  Created by Francisco on 12/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import Foundation
import CoreData

public enum ImageType : String {
    case backdropImage = "backdropImage"
    case posterImage = "posterImage"
}

protocol ContextManagerConfigurationInterface {
    func cleanConfigurationModel()
    func saveConfiguration(apiConf: APIConfiguration)
    func getConfigurationModel() -> APIConfigurationModel?
    func updateConfigurationPage(page: Int, forMovieModel model: MoviesPersistenModel)
    func updateConfigurationPage(page: Int, forShowModel model: ShowsPersistenModel)
}
extension ContextManager:ContextManagerConfigurationInterface {
    
    func cleanConfigurationModel() {
        do {
            _ = try getContext().execute(NSBatchDeleteRequest(fetchRequest:
                NSFetchRequest<NSFetchRequestResult>(entityName: "APIConfigurationModel")))
            saveContext()
        } catch {
            
        }
    }
    
    func saveConfiguration(apiConf: APIConfiguration) {
        let encodedData = try? JSONEncoder().encode(apiConf)
        let entity = NSEntityDescription.insertNewObject(forEntityName: "APIConfigurationModel", into: getContext()) as! APIConfigurationModel
        entity.popularMoviesPage = 1
        entity.upcomingPageCounter = 1
        entity.topRatedPageCounter = 1
        entity.popularShowsPage = 1
        entity.topRatedShowPage = 1
        entity.onTheAirShowPage = 1
        entity.configJSON = encodedData
        saveContext()
    }
    
    func getConfigurationModel() -> APIConfigurationModel? {
        let request:NSFetchRequest<APIConfigurationModel> = APIConfigurationModel.fetchRequest()
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
    
    func updateConfigurationPage(page: Int, forMovieModel model: MoviesPersistenModel) {
        let request:NSFetchRequest<APIConfigurationModel> = APIConfigurationModel.fetchRequest()
        do {
            let result = try getContext().fetch(request)
            if (result.count > 0) {
                let apiConfiguration = result.first
                switch model {
                case .popular: apiConfiguration!.popularMoviesPage = Int32(page)
                case .upcoming: apiConfiguration!.upcomingPageCounter = Int32(page)
                case .topRated: apiConfiguration!.topRatedPageCounter = Int32(page)
                }
            }
        } catch {
            print("fail on updateConfigurationPages update")
        }
        saveContext()
    }
    
    func updateConfigurationPage(page: Int, forShowModel model: ShowsPersistenModel) {
        let request:NSFetchRequest<APIConfigurationModel> = APIConfigurationModel.fetchRequest()
        do {
            let result = try getContext().fetch(request)
            if (result.count > 0) {
                let apiConfiguration = result.first
                switch model {
                case .popular: apiConfiguration!.popularShowsPage = Int32(page)
                case .onTheAir: apiConfiguration!.onTheAirShowPage = Int32(page)
                case .topRated: apiConfiguration!.topRatedShowPage = Int32(page)
                }
            }
        } catch {
            print("fail on updateConfigurationPages update")
        }
        saveContext()
    }
}
