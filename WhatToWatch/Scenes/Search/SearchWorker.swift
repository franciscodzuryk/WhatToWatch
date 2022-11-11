//
//  SearchWorker.swift
//  WhatToWatch
//
//  Created by Fran on 04/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import UIKit
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
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let results = try appDelegate.contextManager.getContext().fetch(request)
            let items = results.map { return Item($0 as! NSManagedObject) }
            success(items)
        } catch let error {
            fail(error)
        }
    }
    
    internal func getMovieList(_ query: MoviesSearchParameters, success: @escaping ([Item]) -> Void, fail: @escaping (_ error: Error) -> Void) {
        AF.request(Router.searchMovies(parameters: query)).responseData { response in
            switch response.result {
            case .success(let data):
                do{
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(SearchMovieResponse.self, from: data)
                    let items = result.results.map { return Item(itemMovieDTO:$0) }
                    success(items)
                }catch let error {
                    fail(error)
                }
            case .failure(let error):
                fail(error)
            }
        }
    }
    
    internal func getLocalShowList(_ success: @escaping ([Item]) -> Void, fail: @escaping (_ error: Error) -> Void) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ShowPopularModel")
        request.returnsObjectsAsFaults = false
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let results = try appDelegate.contextManager.getContext().fetch(request)
            let items = results.map { return Item($0 as! NSManagedObject) }
            success(items)
        } catch let error {
            fail(error)
        }
    }
    
    internal func getShowList(_ query: MoviesSearchParameters, success: @escaping ([Item]) -> Void, fail: @escaping (_ error: Error) -> Void) {
        AF.request(Router.searchShows(parameters: query)).responseData { response in
            switch response.result {
            case .success(let data):
                do{
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(SearchShowResponse.self, from: data)
                    let items = result.results.map { return Item(itemShowDTO:$0) }
                    success(items)
                }catch let error {
                    fail(error)
                }
            case .failure(let error):
                fail(error)
            }
        }
    }
    
    internal func getImage(_ url: String, success: @escaping (UIImage) -> Void, fail: @escaping (NSError) -> Void) {
        AF.request(url)
            .responseImage { response in
                switch response.result {
                case .success(let image):
                        success(image)
                case .failure(let error):
                    fail(error as NSError)
                }
        }
    }
    
    
    
}
