//
//  SearchWorker.swift
//  WhatToWatch
//
//  Created by Fran on 04/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import Alamofire
import CoreData

protocol SearchWorkerProtocol {
    func getImage(_ url: String, success: @escaping (UIImage) -> Void, fail: @escaping (NSError) -> Void)
    func getMovieList(_ query: MoviesSearchParameters, success: @escaping ([Item]) -> Void, fail: @escaping (_ error: Error) -> Void)
    func getLocalMovieList(_ success: @escaping ([Item]) -> Void, fail: @escaping (_ error: Error) -> Void)
    func getShowList(_ query: MoviesSearchParameters, success: @escaping ([Item]) -> Void, fail: @escaping (_ error: Error) -> Void)
    func getLocalShowList(_ success: @escaping ([Item]) -> Void, fail: @escaping (_ error: Error) -> Void)

}

class SearchWorker: SearchWorkerProtocol {
    internal func getLocalMovieList(_ success: @escaping ([Item]) -> Void, fail: @escaping (_ error: Error) -> Void) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MoviePopularModel")
        request.returnsObjectsAsFaults = false
        do {
            let results = try PersistenceManager().getContext().fetch(request)
            let items = results.map { return Item($0 as! NSManagedObject) }
            success(items)
        } catch let error {
            fail(error)
        }
    }
    
    internal func getMovieList(_ query: MoviesSearchParameters, success: @escaping ([Item]) -> Void, fail: @escaping (_ error: Error) -> Void) {
        Alamofire.request(Router.searchMovies(parameters: query)).responseJSON { response in
            if response.result.isSuccess {
                let json = response.data
                do{
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(SearchMovieResponse.self, from: json!)
                    let items = result.results.map { return Item(itemMovieDTO:$0) }
                    success(items)
                }catch let error {
                    fail(error)
                }
            } else {
                fail(response.result.error!)
            }
        }
    }
    
    internal func getLocalShowList(_ success: @escaping ([Item]) -> Void, fail: @escaping (_ error: Error) -> Void) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ShowPopularModel")
        request.returnsObjectsAsFaults = false
        do {
            let results = try PersistenceManager().getContext().fetch(request)
            let items = results.map { return Item($0 as! NSManagedObject) }
            success(items)
        } catch let error {
            fail(error)
        }
    }
    
    internal func getShowList(_ query: MoviesSearchParameters, success: @escaping ([Item]) -> Void, fail: @escaping (_ error: Error) -> Void) {
        Alamofire.request(Router.searchShows(parameters: query)).responseJSON { response in
            if response.result.isSuccess {
                let json = response.data
                do{
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(SearchShowResponse.self, from: json!)
                    let items = result.results.map { return Item(itemShowDTO:$0) }
                    success(items)
                }catch let error {
                    fail(error)
                }
            } else {
                fail(response.result.error!)
            }
        }
    }
    
    internal func getImage(_ url: String, success: @escaping (UIImage) -> Void, fail: @escaping (NSError) -> Void) {
        Alamofire.request(url)
            .responseImage { response in
                if response.result.isSuccess {
                    success(response.result.value!)
                } else {
                    fail(response.result.error! as NSError)
                }
        }
    }
    
    
    
}
