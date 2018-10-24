//
//  SearchInteractor.swift
//  WhatToWatch
//
//  Created by Fran on 04/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import UIKit

protocol SearchInteractorInput {
    func loadMovieList()
    func loadMovieList(_ request: SearchRequest)
    func loadMovieListNextPage()
    func loadShowList()
    func loadShowList(_ request: SearchRequest)
    func loadShowListNextPage()
    func filterList(_ model: SearchViewModel, searhText: String)
    func loadImage(_ forItem: Item, fotIndexPath: IndexPath, withUrl: String)
}

protocol SearchInteractorOutput {
    func presentList (_ items: [Item])
    func presentNextPageList (_ items: [Item])
    func presentLoadListError()
    func presentFilterList(_ list: [Item])
    func presentListFromModel()
    func presentImage(_ image: UIImage, forIndexPath: IndexPath)
}

class SearchInteractor: SearchInteractorInput {
    var  output: SearchInteractorOutput!
    var worker: SearchWorkerProtocol!
    var searchRequest: SearchRequest?
    var loading = false
    // MARK: Business logic
    
    func filterList(_ model: SearchViewModel, searhText: String) {
        var filterItems = [Item]()
        
        
        let trimmedString = searhText.trimmingCharacters(
            in: CharacterSet.whitespacesAndNewlines
        )
        
        if trimmedString.count > 2 {
            filterItems = model.items.filter { item in
                return item.title.lowercased().contains(trimmedString.lowercased())
            }
            output.presentFilterList(filterItems)
            
        } else {
            output.presentListFromModel()
        }
    }
    
    func loadImage(_ forItem: Item, fotIndexPath: IndexPath,
                   withUrl: String) {
        
        worker.getImage(withUrl, success: {
            image in
            self.output.presentImage(image, forIndexPath:fotIndexPath)
            
        }, fail: { err in
            print(err)
            print("No se pudo cargar la imagen para la url: " + withUrl)
        })
    }
    
    func loadMovieList(_ request: SearchRequest) {
        if (!self.loading) {
            self.loading = true
            self.searchRequest = request
            worker.getMovieList(request.query!, success: { [weak self] (result: [Item]) in
                self?.output.presentList(result)
                self?.loading = false
            }) { [weak self] (error: Error) in
                self?.output.presentLoadListError()
                self?.loading = false
            }
        }
    }
    
    func loadMovieListNextPage() {
        if let request = self.searchRequest?.nextPage() {
            if (!self.loading) {
                self.loading = true
                worker.getMovieList(request.query!, success: { [weak self] (result: [Item]) in
                    self?.output.presentNextPageList(result)
                    self?.loading = false
                }) { [weak self] (error: Error) in
                    self?.output.presentLoadListError()
                    self?.loading = false
                }
            }
        }
    }
    
    func loadMovieList() {
        worker.getLocalMovieList({ (result: [Item]) in
            self.output.presentList(result)
        }) { (error: Error) in
            self.output.presentLoadListError()
        }
    }
    
    func loadShowList(_ request: SearchRequest) {
        if (!self.loading) {
            self.loading = true
            self.searchRequest = request
            worker.getShowList(request.query!, success: { [weak self] (result: [Item]) in
                self?.output.presentList(result)
                self?.loading = false
            }) { [weak self] (error: Error) in
                self?.output.presentLoadListError()
                self?.loading = false
            }
        }
    }
    
    func loadShowListNextPage() {
        if let request = self.searchRequest?.nextPage() {
            if (!self.loading) {
                self.loading = true
                worker.getShowList(request.query!, success: { [weak self] (result: [Item]) in
                    self?.output.presentNextPageList(result)
                    self?.loading = false
                }) { [weak self] (error: Error) in
                    self?.output.presentLoadListError()
                    self?.loading = false
                }
            }
        }
    }
    
    func loadShowList() {
        worker.getLocalShowList({ (result: [Item]) in
            self.output.presentList(result)
        }) { (error: Error) in
            self.output.presentLoadListError()
        }
    }
}

